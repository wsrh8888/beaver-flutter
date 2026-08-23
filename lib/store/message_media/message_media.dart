/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

import 'dart:convert';

import 'package:beaver/api/chat.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/common/logger/index.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/chat/message_media.dart';
import 'package:beaver/core/database/services/datasync/datasync.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageMediaState extends Equatable {
  final Set<String> playedMessageIds;

  const MessageMediaState({this.playedMessageIds = const {}});

  MessageMediaState copyWith({Set<String>? playedMessageIds}) {
    return MessageMediaState(
      playedMessageIds: playedMessageIds ?? this.playedMessageIds,
    );
  }

  bool isPlayed(String messageId) {
    if (messageId.isEmpty) {
      return false;
    }
    return playedMessageIds.contains(messageId);
  }

  @override
  List<Object?> get props => [playedMessageIds];
}

class MessageMediaStore extends Cubit<MessageMediaState> {
  static const _syncModule = 'chat_message_medias';

  final _logger = Logger('message-media');
  final ChatMessageMediaService _mediaService = getIt<ChatMessageMediaService>();
  final DatasyncService _datasyncService = getIt<DatasyncService>();

  MessageMediaStore() : super(const MessageMediaState());

  String get _userId => StorageUtil.getString('userId') ?? '';

  Future<void> init() async {
    await _loadLocal();
    await sync();
  }

  /// 从服务端增量同步已听状态（WS 重连、后台恢复时也会调用）
  Future<void> sync() async {
    if (_userId.isEmpty || DatabaseManager.currentUserId == null) {
      return;
    }
    await _syncFromServer();
  }

  void mark(String messageId, {bool localOnly = false}) {
    if (messageId.isEmpty || state.isPlayed(messageId)) {
      return;
    }

    emit(
      state.copyWith(
        playedMessageIds: {...state.playedMessageIds, messageId},
      ),
    );
    _persistToDb([messageId]);

    if (!localOnly && _isRealMessageId(messageId)) {
      markMessageMediaApi(IMarkMessageMediaReq(messageIds: [messageId])).then(
        (res) {
          if (!res.isSuccess) {
            _logger.warn({
              'text': '标记消息媒体状态失败',
              'messageId': messageId,
              'code': res.code,
              'msg': res.msg,
            });
          }
        },
      );
    }
  }

  void merge(List<String> messageIds) {
    if (messageIds.isEmpty) {
      return;
    }

    final newIds = messageIds
        .where((id) => id.isNotEmpty && !state.playedMessageIds.contains(id))
        .toList();
    if (newIds.isEmpty) {
      return;
    }

    final merged = {...state.playedMessageIds, ...newIds};

    _logger.info({
      'text': '合并消息媒体已听状态',
      'count': newIds.length,
      'total': merged.length,
    });

    emit(state.copyWith(playedMessageIds: merged));
    _persistToDb(newIds);
  }

  Future<void> _loadLocal() async {
    if (_userId.isEmpty || DatabaseManager.currentUserId == null) {
      return;
    }

    try {
      await _migrateFromStorageIfNeeded();

      final messageIds = await _mediaService.getMessageIds(_userId);
      if (messageIds.isEmpty) {
        return;
      }

      emit(state.copyWith(playedMessageIds: messageIds.toSet()));
      _logger.info({
        'text': '从本地数据库加载消息媒体状态',
        'count': messageIds.length,
      });
    } catch (e) {
      _logger.warn({
        'text': '加载本地消息媒体状态失败',
        'error': e.toString(),
      });
    }
  }

  Future<void> _migrateFromStorageIfNeeded() async {
    final existing = await _mediaService.getMessageIds(_userId);
    if (existing.isNotEmpty) {
      return;
    }

    final raw = StorageUtil.getString('message_media_played_ids_$_userId') ??
        StorageUtil.getString('message_media_played_ids');
    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      final list = (jsonDecode(raw) as List).cast<String>();
      if (list.isEmpty) {
        return;
      }

      await _mediaService.batchCreate(_userId, list);
      _logger.info({
        'text': '已从 StorageUtil 迁移消息媒体状态到本地数据库',
        'count': list.length,
      });
    } catch (e) {
      _logger.warn({
        'text': '迁移消息媒体状态失败',
        'error': e.toString(),
      });
    }
  }

  Future<void> _persistToDb(List<String> messageIds) async {
    if (_userId.isEmpty || DatabaseManager.currentUserId == null) {
      return;
    }

    try {
      await _mediaService.batchCreate(_userId, messageIds);
    } catch (e) {
      _logger.warn({
        'text': '保存消息媒体状态到本地数据库失败',
        'count': messageIds.length,
        'error': e.toString(),
      });
    }
  }

  Future<void> _syncFromServer() async {
    final localCursor = await _datasyncService.get(_syncModule);
    final since = localCursor?.updatedAt ?? 0;

    _logger.info({'text': '开始同步消息媒体状态', 'since': since});

    final res = await datasyncGetSyncMessageMediasApi(
      IGetSyncMessageMediasReq(since: since),
    );
    if (!res.isSuccess || res.result == null) {
      _logger.warn({
        'text': '同步消息媒体状态失败',
        'since': since,
        'code': res.code,
        'msg': res.msg,
      });
      return;
    }

    final messageIds = res.result!.messageIds;
    _logger.info({
      'text': '同步消息媒体状态成功',
      'since': since,
      'count': messageIds.length,
      'serverTimestamp': res.result!.serverTimestamp,
    });

    if (messageIds.isNotEmpty) {
      merge(messageIds);
    }

    await _datasyncService.upsert(
      _syncModule,
      -1,
      res.result!.serverTimestamp,
    );
  }

  bool _isRealMessageId(String messageId) {
    return messageId.isNotEmpty && !messageId.startsWith('voice-url:');
  }
}

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
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'detail_event.dart';
import 'detail_state.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('chat-forward-detail');

class ForwardDetailBloc extends Bloc<ForwardDetailEvent, ForwardDetailState> {
  ForwardDetailBloc() : super(const ForwardDetailState()) {
    on<FetchForwardDetailEvent>(_onFetchDetail);
  }

  Future<void> _onFetchDetail(FetchForwardDetailEvent event, Emitter<ForwardDetailState> emit) async {
    emit(state.copyWith(status: ForwardDetailStatus.loading));
    _logger.info({'text': '加载转发消息详情', 'data': {'recordId': event.recordId}});

    final res = await getForwardDetailsApi(
      IGetForwardDetailsReq(recordId: event.recordId),
    );

    if (res.code == 0 && res.result != null) {
      final items = res.result!.list;
      _logger.info({
        'text': '加载转发消息详情成功',
        'data': {'recordId': event.recordId, 'title': res.result!.title, 'count': items.length},
      });
      final messages = items.map((item) {
        final msgJson = jsonDecode(item.msg);
        final msgContent = MessageContentModel.fromJson(msgJson);
        return MessageModel(
          id: item.messageId,
          conversationId: item.conversationId,
          userId: item.sendUserId,
          nickname: item.sender.nickName,
          avatar: item.sender.avatar,
          msg: msgContent,
          type: msgContent.type,
          status: MessageStatus.sent,
          createdAt: DateTime.fromMillisecondsSinceEpoch(item.createdAt * 1000),
          isSent: false,
        );
      }).toList();

      emit(state.copyWith(
        status: ForwardDetailStatus.success,
        title: res.result!.title,
        messages: messages,
      ));
    } else {
      _logger.warn({
        'text': '加载转发消息详情失败',
        'data': {'recordId': event.recordId, 'code': res.code, 'msg': res.msg},
      });
      emit(state.copyWith(
        status: ForwardDetailStatus.failure,
        error: res.msg,
      ));
    }
  }
}

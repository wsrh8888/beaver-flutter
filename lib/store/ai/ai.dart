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

import 'package:beaver/api/agent.dart';
import 'package:beaver/api/auth.dart';
import 'package:beaver/common/logger/index.dart';
import 'package:beaver/features/ai/types/chat.dart';
import 'package:beaver/features/ai/utils/toolEvent.dart';
import 'package:beaver/types/api/agent.dart';
import 'package:beaver/types/api/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('store-ai');

class AiMessage extends Equatable {
  final String id;
  final String role;
  final String content;
  final bool streaming;
  final int timestamp;
  final List<AiToolStep> tools;

  const AiMessage({
    required this.id,
    required this.role,
    this.content = '',
    this.streaming = false,
    this.timestamp = 0,
    this.tools = const [],
  });

  AiMessage copyWith({
    String? content,
    bool? streaming,
    List<AiToolStep>? tools,
  }) {
    return AiMessage(
      id: id,
      role: role,
      content: content ?? this.content,
      streaming: streaming ?? this.streaming,
      timestamp: timestamp,
      tools: tools ?? this.tools,
    );
  }

  @override
  List<Object?> get props => [id, role, content, streaming, timestamp, tools];
}

class AiThread extends Equatable {
  final String id;
  final String title;
  final String conversationId;
  final String topicId;
  final List<AiMessage> messages;
  final List<AiArtifact> artifacts;
  final int updatedAt;
  final bool remote;
  final String workspaceId;

  const AiThread({
    required this.id,
    required this.title,
    this.conversationId = '',
    this.topicId = '',
    this.messages = const [],
    this.artifacts = const [],
    required this.updatedAt,
    this.remote = false,
    this.workspaceId = '',
  });

  AiThread copyWith({
    String? id,
    String? title,
    String? conversationId,
    String? topicId,
    List<AiMessage>? messages,
    List<AiArtifact>? artifacts,
    int? updatedAt,
    String? workspaceId,
    bool? remote,
  }) {
    return AiThread(
      id: id ?? this.id,
      title: title ?? this.title,
      conversationId: conversationId ?? this.conversationId,
      topicId: topicId ?? this.topicId,
      messages: messages ?? this.messages,
      artifacts: artifacts ?? this.artifacts,
      updatedAt: updatedAt ?? this.updatedAt,
      remote: remote ?? this.remote,
      workspaceId: workspaceId ?? this.workspaceId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    conversationId,
    topicId,
    messages,
    artifacts,
    updatedAt,
    remote,
    workspaceId,
  ];
}

class AiSpace extends Equatable {
  final String id;
  final String deviceId;
  final String name;
  final String path;

  const AiSpace({required this.id, required this.deviceId, required this.name, this.path = ''});

  @override
  List<Object?> get props => [id, deviceId, name, path];
}

class AiStoreState extends Equatable {
  final List<AiThread> threads;
  final DeviceInfo? computer;
  final String streamingThreadId;
  final String activeThreadId;
  final List<DeviceInfo> desktops;
  final List<AiSpace> spaces;
  final String draftWorkspaceId;
  final String activeArtifactId;

  const AiStoreState({
    this.threads = const [],
    this.computer,
    this.streamingThreadId = '',
    this.activeThreadId = '',
    this.desktops = const [],
    this.spaces = const [],
    this.draftWorkspaceId = '',
    this.activeArtifactId = '',
  });

  bool get cloudMode => computer == null;

  AiThread? threadOf(String id) {
    for (final item in threads) {
      if (item.id == id) return item;
    }
    return null;
  }

  AiStoreState copyWith({
    List<AiThread>? threads,
    DeviceInfo? computer,
    bool clearComputer = false,
    String? streamingThreadId,
    String? activeThreadId,
    List<DeviceInfo>? desktops,
    List<AiSpace>? spaces,
    String? draftWorkspaceId,
    String? activeArtifactId,
    bool clearActiveArtifact = false,
  }) {
    return AiStoreState(
      threads: threads ?? this.threads,
      computer: clearComputer ? null : (computer ?? this.computer),
      streamingThreadId: streamingThreadId ?? this.streamingThreadId,
      activeThreadId: activeThreadId ?? this.activeThreadId,
      desktops: desktops ?? this.desktops,
      spaces: spaces ?? this.spaces,
      draftWorkspaceId: draftWorkspaceId ?? this.draftWorkspaceId,
      activeArtifactId: clearActiveArtifact ? '' : (activeArtifactId ?? this.activeArtifactId),
    );
  }

  @override
  List<Object?> get props => [
    threads,
    computer?.deviceId,
    computer?.isOnline,
    streamingThreadId,
    activeThreadId,
    desktops.map((item) => '${item.deviceId}:${item.isOnline}').join(','),
    spaces,
    draftWorkspaceId,
    activeArtifactId,
  ];
}

class _Pending {
  final String threadId;
  final String assistantId;
  _Pending(this.threadId, this.assistantId);
}

class AiStore extends Cubit<AiStoreState> {
  AiStore() : super(const AiStoreState());

  final Map<String, _Pending> _pending = {};
  int _seq = 0;

  Future<bool> refreshRemote() async {
    final desks = await loadDesktops();
    final catalog = await loadCatalog();
    return desks && catalog;
  }

  Future<bool> loadDesktops() async {
    try {
      final res = await getDevicesApi();
      if (!res.isSuccess || res.result == null) return false;
      final list = res.result!.devices.where((item) => item.deviceType == 'desktop').toList();
      final current = state.computer;
      if (current == null) {
        emit(state.copyWith(desktops: list));
        return true;
      }
      DeviceInfo? fresh;
      for (final item in list) {
        if (item.deviceId == current.deviceId) fresh = item;
      }
      if (fresh == null || !fresh.isOnline) {
        emit(state.copyWith(desktops: list, clearComputer: true));
        return true;
      }
      emit(state.copyWith(desktops: list, computer: fresh));
      return true;
    } catch (err) {
      _logger.error({'text': '读取在线电脑失败', 'data': {'error': err.toString()}});
      return false;
    }
  }

  void selectComputer(DeviceInfo? device) {
    if (device == null) {
      emit(state.copyWith(clearComputer: true, draftWorkspaceId: ''));
      return;
    }
    emit(state.copyWith(computer: device));
  }

  Future<bool> loadCatalog() async {
    try {
      final res = await listAgentConversationsApi();
      if (!res.isSuccess || res.result == null) return false;
      final catalog = res.result!;

      final draft = state.threads.where((t) => t.id == kAiDraftThreadId).firstOrNull;
      final liveId = state.streamingThreadId;
      final live = liveId.isNotEmpty ? state.threadOf(liveId) : null;

      final next = <AiThread>[];
      if (draft != null) next.add(draft);
      if (live != null && live.id != kAiDraftThreadId) next.add(live);

      for (final item in catalog.list) {
        final convId = item.conversationId;
        if (convId.isEmpty || seenContains(next, convId)) continue;
        if (item.workspaceId.isEmpty && item.module.isNotEmpty && item.module != 'workspace') continue;
        if (live?.conversationId == convId) continue;

        final title = item.title.trim().isNotEmpty ? item.title.trim() : item.preview.trim();
        next.add(AiThread(
          id: convId,
          title: title.isNotEmpty ? title : '未命名会话',
          conversationId: convId,
          topicId: item.latestTopicId,
          workspaceId: item.workspaceId,
          remote: item.workspaceId.isNotEmpty,
          updatedAt: item.updatedAt > 0 ? item.updatedAt : 0,
        ));
      }

      next.sort((a, b) {
        if (a.id == kAiDraftThreadId) return -1;
        if (b.id == kAiDraftThreadId) return 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });

      final spaces = catalog.workspaces
          .where((item) => item.workspaceId.isNotEmpty)
          .map((item) => AiSpace(
            id: item.workspaceId,
            deviceId: item.deviceId,
            name: item.name.isNotEmpty ? item.name : '空间',
            path: item.path,
          ))
          .toList();

      emit(state.copyWith(threads: next, spaces: spaces));
      return true;
    } catch (err) {
      _logger.error({'text': '读取会话和空间失败', 'data': {'error': err.toString()}});
      return false;
    }
  }

  bool seenContains(List<AiThread> list, String convId) {
    for (final t in list) {
      if (t.conversationId == convId || t.id == convId) return true;
    }
    return false;
  }

  void focusSpace(String workspaceId) {
    emit(state.copyWith(draftWorkspaceId: workspaceId, activeThreadId: ''));
  }

  void openThread(String id) {
    final thread = state.threadOf(id);
    if (thread == null) return;
    emit(state.copyWith(activeThreadId: id, draftWorkspaceId: '', clearActiveArtifact: true));
    if (thread.topicId.isNotEmpty) {
      _reloadMessages(id, thread.topicId);
    }
  }

  void showHome() {
    emit(state.copyWith(activeThreadId: '', clearActiveArtifact: true));
  }

  void setActiveArtifact(String artifactId) {
    emit(state.copyWith(activeArtifactId: artifactId));
  }

  void addArtifact(String threadId, AiArtifact artifact) {
    final thread = state.threadOf(threadId);
    if (thread == null) return;
    var artifacts = [...thread.artifacts];
    if (artifact.path.isNotEmpty) {
      final idx = artifacts.indexWhere((a) => a.path == artifact.path);
      if (idx >= 0) {
        artifacts[idx] = artifact;
      } else {
        artifacts.add(artifact);
      }
    } else if (artifact.type == AiArtifactType.html) {
      final idx = artifacts.indexWhere((a) => a.type == AiArtifactType.html);
      if (idx >= 0) {
        artifacts[idx] = artifact;
      } else {
        artifacts.add(artifact);
      }
    } else {
      artifacts.add(artifact);
    }
    _replace(thread.copyWith(artifacts: artifacts));
    emit(state.copyWith(activeArtifactId: artifact.id));
  }

  Future<void> _reloadMessages(String threadId, String topicId) async {
    if (topicId.isEmpty) return;
    try {
      final res = await listAgentMessagesApi(topicId);
      if (!res.isSuccess || res.result == null) return;
      final thread = state.threadOf(threadId);
      if (thread == null) return;
      if (state.streamingThreadId == threadId) return;

      final messages = res.result!.list.map(_messageFromHistory).toList();
      _replace(thread.copyWith(messages: messages));
    } catch (err) {
      _logger.error({'text': '读取会话消息失败', 'data': {'error': err.toString()}});
    }
  }

  AiMessage _messageFromHistory(AgentHistoryMessage item) {
    return AiMessage(
      id: item.messageId.isNotEmpty ? item.messageId : _id('m'),
      role: item.role,
      content: item.text,
      timestamp: item.createdAt,
    );
  }

  Future<String?> startTask(String text) async {
    final content = text.trim();
    if (content.isEmpty || state.streamingThreadId.isNotEmpty) return null;

    final now = DateTime.now().millisecondsSinceEpoch;
    final title = content.length > 16 ? content.substring(0, 16) : content;
    final remote = !state.cloudMode;
    final workspaceId = remote ? state.draftWorkspaceId : '';

    final user = AiMessage(id: _id('u'), role: 'user', content: content, timestamp: now);
    final assistantId = _id('a');
    final assistant = AiMessage(id: assistantId, role: 'assistant', streaming: true, timestamp: now + 1);

    final thread = AiThread(
      id: kAiDraftThreadId,
      title: title,
      messages: [user, assistant],
      updatedAt: now,
      remote: remote,
      workspaceId: workspaceId,
    );

    final threads = [thread, ...state.threads.where((t) => t.id != kAiDraftThreadId)];
    emit(state.copyWith(
      threads: threads,
      streamingThreadId: kAiDraftThreadId,
      activeThreadId: kAiDraftThreadId,
      draftWorkspaceId: '',
      clearActiveArtifact: true,
    ));

    await _dispatch(kAiDraftThreadId, assistantId, content, conversationId: '', topicId: '');
    final active = state.activeThreadId;
    return active.isNotEmpty ? active : null;
  }

  Future<void> reply(String threadId, String text) async {
    final content = text.trim();
    final thread = state.threadOf(threadId);
    if (content.isEmpty || thread == null || state.streamingThreadId.isNotEmpty) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final assistantId = _id('a');
    final messages = [
      ...thread.messages,
      AiMessage(id: _id('u'), role: 'user', content: content, timestamp: now),
      AiMessage(id: assistantId, role: 'assistant', streaming: true, timestamp: now + 1),
    ];
    _replace(thread.copyWith(messages: messages, updatedAt: now));
    emit(state.copyWith(streamingThreadId: threadId));
    await _dispatch(
      threadId,
      assistantId,
      content,
      conversationId: thread.conversationId,
      topicId: thread.topicId,
    );
  }

  Future<void> _dispatch(
    String threadId,
    String assistantId,
    String content, {
    required String conversationId,
    required String topicId,
  }) async {
    try {
      final currentThread = state.threadOf(threadId);
      final workspaceId = currentThread?.workspaceId ?? '';
      var workspacePath = '';
      for (final space in state.spaces) {
        if (space.id == workspaceId) workspacePath = space.path;
      }
      final res = await sendAgentMessageApi(SendAgentMessageReq(
        conversationId: conversationId,
        topicId: topicId,
        parts: [AgentMessagePart(text: content)],
        clientMsgId: _id('c'),
        targetDeviceId: state.computer?.deviceId ?? '',
        workspaceId: workspaceId,
        workspacePath: workspacePath,
      ));
      if (!res.isSuccess || res.result == null) {
        _finish(threadId, assistantId, fallback: res.msg.isNotEmpty ? res.msg : '发送失败');
        return;
      }
      final result = res.result!;
      var current = state.threadOf(threadId);
      if (current != null) {
        if (threadId == kAiDraftThreadId && result.conversationId.isNotEmpty) {
          _rekeyThread(kAiDraftThreadId, result.conversationId);
          threadId = result.conversationId;
          current = state.threadOf(threadId);
        }
        if (current != null) {
          _replace(current.copyWith(
            conversationId: result.conversationId,
            topicId: result.topicId,
          ));
        }
      }
      if (result.conversationId.isNotEmpty) {
        _pending[result.conversationId] = _Pending(threadId, assistantId);
      }
      _logger.info({
        'text': 'AI 消息已受理',
        'data': {'threadId': threadId, 'conversationId': result.conversationId},
      });
    } catch (err) {
      _logger.error({'text': 'AI 消息发送失败', 'data': {'error': err.toString()}});
      _finish(threadId, assistantId, fallback: '发送失败，请稍后重试');
    }
  }

  void onStream(Map<String, dynamic> data, Map<String, dynamic> body) {
    final conversationId = (data['conversationId'] ?? body['conversationId'] ?? '').toString();
    if (conversationId.isEmpty) return;

    final pending = _resolveStreamTarget(conversationId);
    if (pending == null) return;

    final event = (body['event'] ?? (body['done'] == true ? 'done' : 'delta')).toString();
    final delta = (body['delta'] ?? '').toString();

    if (event == 'delta' || (event.isEmpty && delta.isNotEmpty)) {
      _append(pending.threadId, pending.assistantId, delta);
      return;
    }
    if (event == 'lg') {
      _applyLg(pending.threadId, pending.assistantId, body);
      return;
    }
    if (event == 'error') {
      _finish(pending.threadId, pending.assistantId, fallback: delta.isNotEmpty ? delta : '生成失败');
      _pending.remove(conversationId);
      _afterStreamDone(pending.threadId);
      return;
    }
    if (event == 'done' || body['done'] == true) {
      _finish(pending.threadId, pending.assistantId);
      _pending.remove(conversationId);
      _afterStreamDone(pending.threadId);
    }
  }

  _Pending? _resolveStreamTarget(String conversationId) {
    final existing = _pending[conversationId];
    if (existing != null) return existing;

    AiThread? thread;
    for (final item in state.threads) {
      if (item.conversationId == conversationId) {
        thread = item;
        break;
      }
    }

    if (thread == null) {
      thread = AiThread(
        id: conversationId,
        title: '会话',
        conversationId: conversationId,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      emit(state.copyWith(threads: [thread, ...state.threads]));
    }

    AiMessage? streaming;
    for (final msg in thread.messages.reversed) {
      if (msg.role == 'assistant' && msg.streaming) {
        streaming = msg;
        break;
      }
    }

    String assistantId;
    if (streaming != null) {
      assistantId = streaming.id;
    } else {
      assistantId = _id('a');
      final now = DateTime.now().millisecondsSinceEpoch;
      final messages = [
        ...thread.messages,
        AiMessage(id: assistantId, role: 'assistant', streaming: true, timestamp: now),
      ];
      _replace(thread.copyWith(messages: messages, updatedAt: now));
    }

    final pending = _Pending(thread.id, assistantId);
    _pending[conversationId] = pending;
    if (state.streamingThreadId.isEmpty) {
      emit(state.copyWith(streamingThreadId: thread.id));
    }
    return pending;
  }

  void _afterStreamDone(String threadId) {
    final thread = state.threadOf(threadId);
    final topicId = thread?.topicId ?? '';
    if (topicId.isNotEmpty) {
      _reloadMessages(threadId, topicId);
    }
    loadCatalog();
  }

  LgPayload _lgFromBody(Map<String, dynamic> body) {
    final rawJson = body['dataJson']?.toString() ?? '';
    if (rawJson.isNotEmpty) {
      try {
        final parsed = jsonDecode(rawJson);
        if (parsed is Map) {
          final map = Map<String, dynamic>.from(parsed);
          return LgPayload(
            name: map['name']?.toString() ?? '',
            content: map['content']?.toString() ?? '',
            dataJson: map['dataJson']?.toString() ?? rawJson,
          );
        }
      } catch (_) {}
    }
    return LgPayload(
      name: body['name']?.toString() ?? '',
      content: body['content']?.toString() ?? '',
      dataJson: rawJson,
    );
  }

  void _applyLg(String threadId, String assistantId, Map<String, dynamic> body) {
    final thread = state.threadOf(threadId);
    if (thread == null) return;
    final payload = _lgFromBody(body);
    AiArtifact? artifact;
    final messages = thread.messages.map((item) {
      if (item.id != assistantId) return item;
      final applied = applyLgEvent(item.tools, payload);
      artifact = applied.artifact;
      return item.copyWith(tools: applied.tools);
    }).toList();
    _replace(thread.copyWith(messages: messages));
    if (artifact != null) addArtifact(threadId, artifact!);
  }

  void _append(String threadId, String assistantId, String delta) {
    if (delta.isEmpty) return;
    final thread = state.threadOf(threadId);
    if (thread == null) return;
    final messages = thread.messages.map((item) {
      if (item.id != assistantId) return item;
      return item.copyWith(content: item.content + delta);
    }).toList();
    _replace(thread.copyWith(messages: messages));
  }

  void _finish(String threadId, String assistantId, {String fallback = ''}) {
    final thread = state.threadOf(threadId);
    if (thread == null) {
      emit(state.copyWith(streamingThreadId: ''));
      return;
    }
    final messages = thread.messages.map((item) {
      if (item.id != assistantId) return item;
      final text = item.content.trim().isEmpty && fallback.isNotEmpty ? fallback : item.content;
      return item.copyWith(content: text, streaming: false);
    }).toList();
    _replace(thread.copyWith(messages: messages));
    emit(state.copyWith(streamingThreadId: ''));
  }

  void _rekeyThread(String fromId, String toId) {
    if (fromId == toId) return;
    final thread = state.threadOf(fromId);
    if (thread == null) return;
    final next = thread.copyWith(id: toId, conversationId: toId);
    final threads = state.threads.map((item) => item.id == fromId ? next : item).toList();
    var streaming = state.streamingThreadId;
    var active = state.activeThreadId;
    if (streaming == fromId) streaming = toId;
    if (active == fromId) active = toId;
    emit(state.copyWith(threads: threads, streamingThreadId: streaming, activeThreadId: active));
  }

  void _replace(AiThread next) {
    final threads = state.threads.map((item) => item.id == next.id ? next : item).toList();
    emit(state.copyWith(threads: threads));
  }

  String _id(String prefix) {
    _seq += 1;
    return '${prefix}_${DateTime.now().millisecondsSinceEpoch}_$_seq';
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}

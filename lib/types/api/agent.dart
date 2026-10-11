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

class AgentMessagePart {
  final String type;
  final String text;

  const AgentMessagePart({this.type = 'text', required this.text});

  Map<String, dynamic> toJson() => {'type': type, 'text': text};
}

class SendAgentMessageReq {
  final String conversationId;
  final String topicId;
  final List<AgentMessagePart> parts;
  final String module;
  final String clientMsgId;
  final String targetDeviceId;
  final String workspaceId;
  final String workspacePath;

  const SendAgentMessageReq({
    this.conversationId = '',
    this.topicId = '',
    required this.parts,
    this.module = 'workspace',
    this.clientMsgId = '',
    this.targetDeviceId = '',
    this.workspaceId = '',
    this.workspacePath = '',
  });

  Map<String, dynamic> toJson() => {
    if (conversationId.isNotEmpty) 'conversationId': conversationId,
    if (topicId.isNotEmpty) 'topicId': topicId,
    'parts': parts.map((item) => item.toJson()).toList(),
    'module': module,
    if (clientMsgId.isNotEmpty) 'clientMsgId': clientMsgId,
    if (targetDeviceId.isNotEmpty) 'targetDeviceId': targetDeviceId,
    if (workspaceId.isNotEmpty) 'workspaceId': workspaceId,
    if (workspacePath.isNotEmpty) 'workspacePath': workspacePath,
  };
}

class SendAgentMessageRes {
  final String conversationId;
  final String topicId;
  final String messageId;
  final String status;

  const SendAgentMessageRes({
    required this.conversationId,
    required this.topicId,
    required this.messageId,
    required this.status,
  });

  factory SendAgentMessageRes.fromJson(Map<String, dynamic> json) => SendAgentMessageRes(
    conversationId: json['conversationId']?.toString() ?? '',
    topicId: json['topicId']?.toString() ?? '',
    messageId: json['messageId']?.toString() ?? '',
    status: json['status']?.toString() ?? '',
  );
}

class AgentConversationItem {
  final String conversationId;
  final String title;
  final String module;
  final String workspaceId;
  final String latestTopicId;
  final String preview;
  final int updatedAt;

  const AgentConversationItem({
    required this.conversationId,
    this.title = '',
    this.module = '',
    this.workspaceId = '',
    this.latestTopicId = '',
    this.preview = '',
    this.updatedAt = 0,
  });

  factory AgentConversationItem.fromJson(Map<String, dynamic> json) => AgentConversationItem(
    conversationId: json['conversationId']?.toString() ?? '',
    title: json['title']?.toString() ?? '',
    module: json['module']?.toString() ?? '',
    workspaceId: json['workspaceId']?.toString() ?? '',
    latestTopicId: json['latestTopicId']?.toString() ?? '',
    preview: json['preview']?.toString() ?? '',
    updatedAt: int.tryParse(json['updatedAt']?.toString() ?? '') ?? 0,
  );
}

class AgentWorkspaceItem {
  final String workspaceId;
  final String deviceId;
  final String name;
  final String path;

  const AgentWorkspaceItem({
    required this.workspaceId,
    this.deviceId = '',
    this.name = '',
    this.path = '',
  });

  factory AgentWorkspaceItem.fromJson(Map<String, dynamic> json) => AgentWorkspaceItem(
    workspaceId: json['workspaceId']?.toString() ?? '',
    deviceId: json['deviceId']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    path: json['path']?.toString() ?? '',
  );
}

class ListAgentConversationsRes {
  final List<AgentConversationItem> list;
  final List<AgentWorkspaceItem> workspaces;

  const ListAgentConversationsRes({required this.list, required this.workspaces});

  factory ListAgentConversationsRes.fromJson(Map<String, dynamic> json) {
    final rawList = json['list'];
    final rawSpaces = json['workspaces'];
    return ListAgentConversationsRes(
      list: rawList is List
          ? rawList.whereType<Map>().map((item) => AgentConversationItem.fromJson(Map<String, dynamic>.from(item))).toList()
          : const [],
      workspaces: rawSpaces is List
          ? rawSpaces.whereType<Map>().map((item) => AgentWorkspaceItem.fromJson(Map<String, dynamic>.from(item))).toList()
          : const [],
    );
  }
}

class AgentHistoryMessage {
  final String messageId;
  final String role;
  final String text;
  final int createdAt;

  const AgentHistoryMessage({
    required this.messageId,
    required this.role,
    required this.text,
    this.createdAt = 0,
  });

  factory AgentHistoryMessage.fromJson(Map<String, dynamic> json) {
    final parts = json['parts'];
    final buffer = StringBuffer();
    if (parts is List) {
      for (final part in parts) {
        if (part is Map) {
          final text = part['text']?.toString() ?? '';
          if (text.isNotEmpty) buffer.writeln(text);
        }
      }
    }
    var text = buffer.toString().trim();
    if (text.isEmpty) {
      final msg = json['msg'];
      if (msg is Map) {
        final textMsg = msg['textMsg'];
        if (textMsg is Map) {
          final body = textMsg['content']?.toString() ?? '';
          if (body.isNotEmpty) text = body;
        }
      }
    }
    if (text.isEmpty) text = json['preview']?.toString() ?? '';
    return AgentHistoryMessage(
      messageId: json['messageId']?.toString() ?? '',
      role: json['role']?.toString() ?? 'assistant',
      text: text,
      createdAt: int.tryParse(json['createdAt']?.toString() ?? '') ?? 0,
    );
  }
}

class ListAgentMessagesRes {
  final List<AgentHistoryMessage> list;

  const ListAgentMessagesRes({required this.list});

  factory ListAgentMessagesRes.fromJson(Map<String, dynamic> json) {
    final raw = json['list'];
    return ListAgentMessagesRes(
      list: raw is List
          ? raw.whereType<Map>().map((item) => AgentHistoryMessage.fromJson(Map<String, dynamic>.from(item))).toList()
          : const [],
    );
  }
}

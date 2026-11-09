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

import 'package:beaver/common/config/env.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/agent.dart';

/// 发消息给 Agent。HTTP 只返回 accepted，增量经 IM WebSocket 推送。
Future<BaseResponse<ListAgentConversationsRes>> listAgentConversationsApi() {
  return httpClient.post<ListAgentConversationsRes>(
    '$baseUrl/api/agent/v1/sync/listConversations',
    data: {'since': 0, 'limit': 100},
    fromJsonT: (json) => ListAgentConversationsRes.fromJson(Map<String, dynamic>.from(json as Map)),
  );
}

Future<BaseResponse<ListAgentMessagesRes>> listAgentMessagesApi(String topicId) {
  return httpClient.post<ListAgentMessagesRes>(
    '$baseUrl/api/agent/v1/message/listMessages',
    data: {'topicId': topicId, 'limit': 100},
    fromJsonT: (json) => ListAgentMessagesRes.fromJson(Map<String, dynamic>.from(json as Map)),
  );
}

Future<BaseResponse<SendAgentMessageRes>> sendAgentMessageApi(SendAgentMessageReq data) {
  return httpClient.post<SendAgentMessageRes>(
    '$baseUrl/api/agent/v1/message/sendMessage',
    data: data.toJson(),
    fromJsonT: (json) => SendAgentMessageRes.fromJson(Map<String, dynamic>.from(json as Map)),
  );
}

/// 列某会话下的话题（分支）；用于本地无 topicId 时补齐当前话题。
Future<BaseResponse<ListAgentTopicsRes>> listAgentTopicsApi(String conversationId) {
  return httpClient.post<ListAgentTopicsRes>(
    '$baseUrl/api/agent/v1/sync/listTopics',
    data: {'conversationId': conversationId},
    fromJsonT: (json) => ListAgentTopicsRes.fromJson(Map<String, dynamic>.from(json as Map)),
  );
}

/// 列官方 + 自定义模型（一次返回两组）。模型目录由外部 ai 服务提供，桌面同网关已验证，这里镜像其调用。
Future<BaseResponse<ListAgentModelsRes>> listAgentModelsApi() {
  return httpClient.post<ListAgentModelsRes>(
    '$baseUrl/api/agent/v1/model/listModels',
    data: {},
    fromJsonT: (json) => ListAgentModelsRes.fromJson(Map<String, dynamic>.from(json as Map)),
  );
}

import 'package:beaver/common/config/env.dart';
import 'package:beaver/common/http/http_client.dart';

// 类型定义
class IRegisterToolReq {
  final String clientId;
  final String toolId;
  final String name;
  final String description;
  final String version;
  final Map<String, dynamic> metadata;

  IRegisterToolReq({
    required this.clientId,
    required this.toolId,
    required this.name,
    required this.description,
    required this.version,
    required this.metadata,
  });
}

class IRegisterToolResult {
  final bool success;
  final String? message;

  IRegisterToolResult({
    required this.success,
    this.message,
  });
}

class IGetClientToolsReq {
  final String clientId;

  IGetClientToolsReq({required this.clientId});
}

class ToolInfo {
  final String toolId;
  final String name;
  final String description;
  final String version;
  final Map<String, dynamic> metadata;

  ToolInfo({
    required this.toolId,
    required this.name,
    required this.description,
    required this.version,
    required this.metadata,
  });
}

class IGetClientToolsRes {
  final List<ToolInfo> tools;

  IGetClientToolsRes({required this.tools});
}

/// 注册工具到云端MCP服务器
Future<List<IRegisterToolResult>> registerToolApi(IRegisterToolReq data) async {
  // TODO: 实现注册工具功能
  return [];
}

/// 获取客户端工具列表
Future<IGetClientToolsRes> getClientToolsApi(IGetClientToolsReq data) async {
  // TODO: 实现获取客户端工具列表功能
  return IGetClientToolsRes(tools: []);
}

import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/mcp.dart';
import 'package:beaver/common/config/env.dart';

/// 注册工具到云端MCP服务器
Future<BaseResponse<List<IRegisterToolResult>>> registerToolApi(IRegisterToolReq data) async {
  return httpClient.post<List<IRegisterToolResult>>(
    '$baseUrl/api/mcp/registerTool',
    data: data.toJson(),
    fromJsonT: (json) => (json as List).map((e) => IRegisterToolResult.fromJson(e)).toList(),
  );
}

/// 获取客户端工具列表
Future<BaseResponse<IGetClientToolsRes>> getClientToolsApi(IGetClientToolsReq data) async {
  return httpClient.post<IGetClientToolsRes>(
    '$baseUrl/api/mcp/getClientTools',
    data: data.toJson(),
    fromJsonT: (json) => IGetClientToolsRes(
      tools: (json['tools'] as List).map((e) => ToolInfo.fromJson(e)).toList(),
    ),
  );
}

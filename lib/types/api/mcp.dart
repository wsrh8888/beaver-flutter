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

  Map<String, dynamic> toJson() => {
    'clientId': clientId,
    'toolId': toolId,
    'name': name,
    'description': description,
    'version': version,
    'metadata': metadata,
  };
}

class IRegisterToolResult {
  final bool success;
  final String? message;

  IRegisterToolResult({
    required this.success,
    this.message,
  });

  factory IRegisterToolResult.fromJson(Map<String, dynamic> json) => IRegisterToolResult(
    success: json['success'] ?? false,
    message: json['message'],
  );
}

class IGetClientToolsReq {
  final String clientId;
  IGetClientToolsReq({required this.clientId});
  Map<String, dynamic> toJson() => {'clientId': clientId};
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

  factory ToolInfo.fromJson(Map<String, dynamic> json) => ToolInfo(
    toolId: json['toolId'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    version: json['version'] ?? '',
    metadata: json['metadata'] ?? {},
  );
}

class IGetClientToolsRes {
  final List<ToolInfo> tools;
  IGetClientToolsRes({required this.tools});
}

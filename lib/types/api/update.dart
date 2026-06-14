class IReportVersionReq {
  final String? userId;
  final String deviceId;
  final String version;
  final String appId;
  final int platformId;
  final int archId;

  IReportVersionReq({
    this.userId,
    required this.deviceId,
    required this.version,
    required this.appId,
    required this.platformId,
    required this.archId,
  });

  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'platformId': platformId,
      'archId': archId,
    };
  }

  Map<String, String> toHeaders() {
    final headers = {
      'deviceId': deviceId,
      'version': version,
    };
    if (userId != null && userId!.isNotEmpty) {
      headers['Beaver-User-Id'] = userId!;
    }
    return headers;
  }
}

class IGetLatestVersionReq {
  final String? userId;
  final String deviceId;
  final String version;
  final String appId;
  final int platformId;
  final int archId;

  IGetLatestVersionReq({
    this.userId,
    required this.deviceId,
    required this.version,
    required this.appId,
    required this.platformId,
    required this.archId,
  });

  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'platformId': platformId,
      'archId': archId,
    };
  }

  Map<String, String> toHeaders() {
    final headers = {
      'deviceId': deviceId,
      'version': version,
    };
    if (userId != null && userId!.isNotEmpty) {
      headers['Beaver-User-Id'] = userId!;
    }
    return headers;
  }
}

class IGetLatestVersionRes {
  final bool hasUpdate;
  final bool forceUpdate;
  final int? architectureId;
  final String? version;
  final String fileUrl;
  final int size;
  final String md5;
  final String? description;
  final String? releaseNotes;

  IGetLatestVersionRes({
    required this.hasUpdate,
    this.forceUpdate = false,
    this.architectureId,
    this.version,
    required this.fileUrl,
    required this.size,
    required this.md5,
    this.description,
    this.releaseNotes,
  });

  factory IGetLatestVersionRes.fromJson(Map<String, dynamic> json) {
    return IGetLatestVersionRes(
      hasUpdate: json['hasUpdate'] ?? false,
      forceUpdate: json['forceUpdate'] ?? false,
      architectureId: json['architectureId'],
      version: json['version'],
      fileUrl: json['fileUrl']?.toString() ?? '',
      size: json['size'] ?? 0,
      md5: json['md5'] ?? '',
      description: json['description'],
      releaseNotes: json['releaseNotes'],
    );
  }
}

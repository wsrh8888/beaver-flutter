class ReportVersionReq {
  final String? userId; // header Beaver-User-Id
  final String deviceId; // header deviceId
  final String version; // header version
  final String appId; // json
  final int platformId; // json: 1=Windows, 2=MacOS, 3=iOS, 4=Android, 5=HarmonyOS
  final int archId; // json: 0=h5, 1=WinX64, 2=WinArm64, 3=MacIntel, 4=MacApple, 5=iOS, 6=Android, 7=HarmonyOS

  ReportVersionReq({
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
    if (userId != null) {
      headers['Beaver-User-Id'] = userId!;
    }
    return headers;
  }
}

class GetLatestVersionReq {
  final String? userId; // header Beaver-User-Id
  final String? cityName; // header X-City-Name
  final String deviceId; // header deviceId
  final String version; // header version
  final String appId; // json
  final int platformId; // json
  final int archId; // json

  GetLatestVersionReq({
    this.userId,
    this.cityName,
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
    if (userId != null) {
      headers['Beaver-User-Id'] = userId!;
    }
    if (cityName != null) {
      headers['X-City-Name'] = cityName!;
    }
    return headers;
  }
}

class GetLatestVersionRes {
  final bool hasUpdate;
  final int? architectureId;
  final String? version;
  final String fileKey;
  final int size;
  final String md5;
  final String? description;
  final String? releaseNotes;

  GetLatestVersionRes({
    required this.hasUpdate,
    this.architectureId,
    this.version,
    required this.fileKey,
    required this.size,
    required this.md5,
    this.description,
    this.releaseNotes,
  });

  factory GetLatestVersionRes.fromJson(Map<String, dynamic> json) {
    return GetLatestVersionRes(
      hasUpdate: json['hasUpdate'] ?? false,
      architectureId: json['architectureId'],
      version: json['version'],
      fileKey: json['fileKey'] ?? '',
      size: json['size'] ?? 0,
      md5: json['md5'] ?? '',
      description: json['description'],
      releaseNotes: json['releaseNotes'],
    );
  }
}

class IGetQrCodeSceneReq {
  final String sceneId;

  IGetQrCodeSceneReq({required this.sceneId});

  Map<String, dynamic> toJson() => {'sceneId': sceneId};
}

class IGetQrCodeSceneRes {
  final String sceneId;
  final String appId;
  final String appName;
  final String appIcon;
  final String status;
  final int expireIn;
  final List<String> scopes;

  IGetQrCodeSceneRes({
    required this.sceneId,
    required this.appId,
    required this.appName,
    required this.appIcon,
    required this.status,
    required this.expireIn,
    required this.scopes,
  });

  factory IGetQrCodeSceneRes.fromJson(Map<String, dynamic> json) {
    return IGetQrCodeSceneRes(
      sceneId: json['sceneId'] as String? ?? '',
      appId: json['appId'] as String? ?? '',
      appName: json['appName'] as String? ?? '',
      appIcon: json['appIcon'] as String? ?? '',
      status: json['status'] as String? ?? 'waiting',
      expireIn: json['expireIn'] as int? ?? 0,
      scopes: (json['scopes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class IScanQrCodeReq {
  final String sceneId;

  IScanQrCodeReq({required this.sceneId});

  Map<String, dynamic> toJson() => {'sceneId': sceneId};
}

class IScanQrCodeRes {
  final bool success;

  IScanQrCodeRes({required this.success});

  factory IScanQrCodeRes.fromJson(Map<String, dynamic> json) {
    return IScanQrCodeRes(success: json['success'] as bool? ?? false);
  }
}

class IConfirmQrCodeReq {
  final String sceneId;

  IConfirmQrCodeReq({required this.sceneId});

  Map<String, dynamic> toJson() => {'sceneId': sceneId};
}

class IConfirmQrCodeRes {
  final bool success;

  IConfirmQrCodeRes({required this.success});

  factory IConfirmQrCodeRes.fromJson(Map<String, dynamic> json) {
    return IConfirmQrCodeRes(success: json['success'] as bool? ?? false);
  }
}

class ICancelQrCodeReq {
  final String sceneId;

  ICancelQrCodeReq({required this.sceneId});

  Map<String, dynamic> toJson() => {'sceneId': sceneId};
}

class ICancelQrCodeRes {
  final bool success;

  ICancelQrCodeRes({required this.success});

  factory ICancelQrCodeRes.fromJson(Map<String, dynamic> json) {
    return ICancelQrCodeRes(success: json['success'] as bool? ?? false);
  }
}

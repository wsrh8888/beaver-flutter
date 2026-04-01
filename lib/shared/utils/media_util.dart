import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:beaver/shared/ui/toast/index.dart';

final ImagePicker _picker = ImagePicker();

/// 从相册选择图片或视频
Future<List<AssetEntity>?> pickAssets(BuildContext context, {RequestType type = RequestType.common}) async {
  final PermissionState ps = await AssetPicker.permissionCheck();
  if (ps == PermissionState.denied || ps == PermissionState.restricted) {
    if (context.mounted) BeaverToast.show(context, '请开启相册权限');
    return null;
  }

  return AssetPicker.pickAssets(
    context,
    pickerConfig: AssetPickerConfig(
      requestType: type,
      maxAssets: 9,
    ),
  );
}

/// 拍摄照片
Future<XFile?> takePhoto(BuildContext context) async {
  if (!await _checkPermission(context, Permission.camera)) return null;
  return _picker.pickImage(source: ImageSource.camera);
}

/// 拍摄视频
Future<XFile?> takeVideo(BuildContext context) async {
  if (!await _checkPermission(context, Permission.camera)) return null;
  if (!await _checkPermission(context, Permission.microphone)) return null;
  return _picker.pickVideo(source: ImageSource.camera);
}

/// 通用权限检查
Future<bool> _checkPermission(BuildContext context, Permission permission) async {
  final status = await permission.request();
  if (status.isPermanentlyDenied) {
    if (context.mounted) BeaverToast.show(context, '请在设置中开启相关权限');
    openAppSettings();
    return false;
  }
  if (!status.isGranted) {
    if (context.mounted) BeaverToast.show(context, '权限已被拒绝');
    return false;
  }
  return true;
}

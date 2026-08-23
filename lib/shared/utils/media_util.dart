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

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:beaver/shared/ui/toast/index.dart';

import 'package:wechat_camera_picker/wechat_camera_picker.dart';

final ImagePicker _picker = ImagePicker();

/// 请求相册保存权限
Future<bool> requestGallerySavePermission(BuildContext context) async {
  if (Platform.isAndroid) {
    final photos = await Permission.photos.request();
    if (photos.isGranted || photos.isLimited) return true;
    if (photos.isPermanentlyDenied) {
      if (context.mounted) BeaverToast.show(context, '请在设置中开启相册权限');
      await openAppSettings();
      return false;
    }
    final storage = await Permission.storage.request();
    if (storage.isGranted) return true;
    if (storage.isPermanentlyDenied) {
      if (context.mounted) BeaverToast.show(context, '请在设置中开启存储权限');
      await openAppSettings();
      return false;
    }
    if (context.mounted) BeaverToast.show(context, '需要相册权限才能保存');
    return false;
  }

  final status = await Permission.photos.request();
  if (status.isGranted || status.isLimited) return true;
  if (status.isPermanentlyDenied) {
    if (context.mounted) BeaverToast.show(context, '请在设置中开启相册权限');
    await openAppSettings();
    return false;
  }
  if (context.mounted) BeaverToast.show(context, '需要相册权限才能保存');
  return false;
}

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

/// 拍摄媒体 (对标微信，点击拍照，长按录像)
Future<AssetEntity?> takeMedia(BuildContext context) async {
  if (!await _checkPermission(context, Permission.camera)) return null;
  // 录像通常需要麦克风
  if (!await _checkPermission(context, Permission.microphone)) return null;

  return CameraPicker.pickFromCamera(
    context,
    pickerConfig: const CameraPickerConfig(
      enableRecording: true,
      onlyEnableRecording: false,
    ),
  );
}

/// 拍摄照片 (旧逻辑保持兼容)
Future<XFile?> takePhoto(BuildContext context) async {
  if (!await _checkPermission(context, Permission.camera)) return null;
  return _picker.pickImage(source: ImageSource.camera);
}

/// 拍摄视频 (旧逻辑保持兼容)
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

import 'package:beaver/features/chat/detail/components/bottom/panels/tool/item.dart';
import 'package:beaver/features/chat/detail/bloc/bloc.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/core/business/media/media.dart';
import 'package:beaver/shared/utils/media_util.dart' as media_util;
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/message.dart';
import 'package:beaver/types/api/file.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:beaver/core/business/call/call.dart';
import 'package:beaver/router/routes.dart';
import 'package:go_router/go_router.dart';

class ToolMenu extends StatelessWidget {
  final String conversationId;

  const ToolMenu({super.key, required this.conversationId});

  Future<void> _handleCall(BuildContext context, String mode) async {
    // 权限检查
    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      if (context.mounted) BeaverToast.show(context, '请先开启麦克风权限');
      return;
    }
    
    if (mode == 'video') {
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        if (context.mounted) BeaverToast.show(context, '请先开启摄像头权限');
        return;
      }
    }

    final chatBloc = context.read<ChatBloc>();
    final activeConversationId = chatBloc.state.conversationId ?? conversationId;
    if (activeConversationId.isEmpty) return;

    // 根据前缀判断会话类型 (1-私聊, 2-群聊)
    final int callType = activeConversationId.startsWith('group_') ? 2 : 1;
    // 初始通话模式 (1-语音, 2-视频)
    final int callMode = mode == 'video' ? 2 : 1;

    final callBusiness = getIt<CallBusiness>();
    final callInfo = await callBusiness.makeCall(activeConversationId, callType, callMode);

    if (callInfo != null && context.mounted) {
      context.push(AppRoutes.call, extra: {
        'conversationId': activeConversationId,
        'roomToken': callInfo.roomToken,
        'liveKitUrl': callInfo.liveKitUrl,
        'callType': mode, // 'audio' or 'video' for UI
      });
    } else if (context.mounted) {
      BeaverToast.show(context, '发起通话失败');
    }
  }

  Future<void> _handleAlbum(BuildContext context) async {
    final mediaBusiness = getIt<MediaBusiness>();
    final chatBloc = context.read<ChatBloc>();

    final List<AssetEntity>? result = await media_util.pickAssets(context);
    if (result == null || result.isEmpty) return;

    for (final entity in result) {
      final File? file = await entity.file;
      if (file == null) continue;

      final IFileUploadResult? uploadResult = await mediaBusiness.uploadFile(file.path);
      if (uploadResult == null) {
        if (context.mounted) BeaverToast.show(context, '上传失败');
        continue;
      }

      if (entity.type == AssetType.image) {
        chatBloc.add(
          SendMessageEvent(
            MessageContentModel(
              type: MessageType.image,
              imageMsg: ImageMsg(
                fileUrl: uploadResult.fileUrl,
                width: uploadResult.fileInfo?.imageFile?.width.toDouble() ?? entity.width.toDouble(),
                height: uploadResult.fileInfo?.imageFile?.height.toDouble() ?? entity.height.toDouble(),
                size: await file.length(),
              ),
            ),
            conversationId: conversationId,
          ),
        );
      } else if (entity.type == AssetType.video) {
        chatBloc.add(
          SendMessageEvent(
            MessageContentModel(
              type: MessageType.video,
              videoMsg: VideoMsg(
                fileUrl: uploadResult.fileUrl,
                width: uploadResult.fileInfo?.videoFile?.width.toDouble() ?? entity.width.toDouble(),
                height: uploadResult.fileInfo?.videoFile?.height.toDouble() ?? entity.height.toDouble(),
                duration: uploadResult.fileInfo?.videoFile?.duration ?? entity.duration,
              ),
            ),
            conversationId: conversationId,
          ),
        );
      }
    }
  }

  Future<void> _handleFile(BuildContext context) async {
    final chatBloc = context.read<ChatBloc>();
    final mediaBusiness = getIt<MediaBusiness>();

    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null || result.files.isEmpty) return;

    for (final platformFile in result.files) {
      final path = platformFile.path;
      if (path == null) continue;

      final file = File(path);
      final uploadResult = await mediaBusiness.uploadFile(path);
      if (uploadResult == null) {
        if (context.mounted) BeaverToast.show(context, '上传失败');
        continue;
      }

      final fileName = uploadResult.originalName.isNotEmpty
          ? uploadResult.originalName
          : (platformFile.name.isNotEmpty ? platformFile.name : p.basename(path));

      chatBloc.add(
        SendMessageEvent(
          MessageContentModel(
            type: MessageType.file,
            fileMsg: FileMsg(
              fileUrl: uploadResult.fileUrl,
              fileName: fileName,
              size: await file.length(),
            ),
          ),
          conversationId: conversationId,
        ),
      );
    }
  }

  Future<void> _handleCamera(BuildContext context) async {
    final chatBloc = context.read<ChatBloc>();
    final mediaBusiness = getIt<MediaBusiness>();

    // 调起统一拍摄界面
    final AssetEntity? entity = await media_util.takeMedia(context);
    if (entity == null) return;

    final File? file = await entity.file;
    if (file == null) return;

    final IFileUploadResult? uploadResult = await mediaBusiness.uploadFile(file.path);
    if (uploadResult == null) {
      if (context.mounted) BeaverToast.show(context, '上传失败');
      return;
    }

    if (entity.type == AssetType.image) {
      chatBloc.add(
        SendMessageEvent(
          MessageContentModel(
            type: MessageType.image,
            imageMsg: ImageMsg(
              fileUrl: uploadResult.fileUrl,
              width: uploadResult.fileInfo?.imageFile?.width.toDouble() ?? entity.width.toDouble(),
              height: uploadResult.fileInfo?.imageFile?.height.toDouble() ?? entity.height.toDouble(),
              size: await file.length(),
            ),
          ),
          conversationId: conversationId,
        ),
      );
    } else if (entity.type == AssetType.video) {
      chatBloc.add(
        SendMessageEvent(
          MessageContentModel(
            type: MessageType.video,
            videoMsg: VideoMsg(
              fileUrl: uploadResult.fileUrl,
              width: uploadResult.fileInfo?.videoFile?.width.toDouble() ?? entity.width.toDouble(),
              height: uploadResult.fileInfo?.videoFile?.height.toDouble() ?? entity.height.toDouble(),
              duration: uploadResult.fileInfo?.videoFile?.duration ?? entity.duration,
            ),
          ),
          conversationId: conversationId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'icon': 'photo', 'label': '相册'},
      {'icon': 'camera', 'label': '拍摄'},
      {'icon': 'phone', 'label': '语音通话'},
      {'icon': 'vedio', 'label': '视频通话'},
      {'icon': 'file', 'label': '文件'},
    ];

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 20.w,
        crossAxisSpacing: 20.w,
        childAspectRatio: 0.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ToolItem(
          icon: item['icon'],
          label: item['label'],
          onTap: () {
            if (item['label'] == '相册') {
              _handleAlbum(context);
            } else if (item['label'] == '拍摄') {
              _handleCamera(context);
            } else if (item['label'] == '语音通话') {
              _handleCall(context, 'audio');
            } else if (item['label'] == '视频通话') {
              _handleCall(context, 'video');
            } else if (item['label'] == '文件') {
              _handleFile(context);
            }
          },
        );
      },
    );
  }
}

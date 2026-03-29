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
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ToolMenu extends StatelessWidget {
  const ToolMenu({super.key});

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
                fileKey: uploadResult.fileKey,
                width: uploadResult.fileInfo?.imageFile?.width.toDouble() ?? entity.width.toDouble(),
                height: uploadResult.fileInfo?.imageFile?.height.toDouble() ?? entity.height.toDouble(),
                size: await file.length(),
              ),
            ),
          ),
        );
      } else if (entity.type == AssetType.video) {
        chatBloc.add(
          SendMessageEvent(
            MessageContentModel(
              type: MessageType.video,
              videoMsg: VideoMsg(
                fileKey: uploadResult.fileKey,
                width: uploadResult.fileInfo?.videoFile?.width.toDouble() ?? entity.width.toDouble(),
                height: uploadResult.fileInfo?.videoFile?.height.toDouble() ?? entity.height.toDouble(),
                duration: uploadResult.fileInfo?.videoFile?.duration ?? entity.duration,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleCamera(BuildContext context) async {
    final mediaBusiness = getIt<MediaBusiness>();
    final chatBloc = context.read<ChatBloc>();

    final type = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () => Navigator.pop(context, 'photo'),
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('录像'),
              onTap: () => Navigator.pop(context, 'video'),
            ),
          ],
        ),
      ),
    );

    if (type == null) return;

    XFile? xFile;
    if (type == 'photo') {
      xFile = await media_util.takePhoto(context);
    } else {
      xFile = await media_util.takeVideo(context);
    }

    if (xFile == null) return;

    final IFileUploadResult? uploadResult = await mediaBusiness.uploadFile(xFile.path);
    if (uploadResult == null) {
      if (context.mounted) BeaverToast.show(context, '上传失败');
      return;
    }

    if (type == 'photo') {
      chatBloc.add(
        SendMessageEvent(
          MessageContentModel(
            type: MessageType.image,
            imageMsg: ImageMsg(
              fileKey: uploadResult.fileKey,
              width: uploadResult.fileInfo?.imageFile?.width.toDouble() ?? 0,
              height: uploadResult.fileInfo?.imageFile?.height.toDouble() ?? 0,
              size: await xFile.length(),
            ),
          ),
        ),
      );
    } else {
      chatBloc.add(
        SendMessageEvent(
          MessageContentModel(
            type: MessageType.video,
            videoMsg: VideoMsg(
              fileKey: uploadResult.fileKey,
              width: uploadResult.fileInfo?.videoFile?.width.toDouble() ?? 0,
              height: uploadResult.fileInfo?.videoFile?.height.toDouble() ?? 0,
              duration: uploadResult.fileInfo?.videoFile?.duration ?? 0,
            ),
          ),
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
            }
          },
        );
      },
    );
  }
}

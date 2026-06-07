import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ota_update/ota_update.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/store/update/update.dart';
import 'package:beaver/types/api/update.dart';
import 'package:beaver/shared/ui/dialog/index.dart';

/// 登录后静默检查更新，有新版时用 BeaverDialog 提示
class UpdateListener extends StatefulWidget {
  final Widget child;

  const UpdateListener({super.key, required this.child});

  @override
  State<UpdateListener> createState() => _UpdateListenerState();
}

class _UpdateListenerState extends State<UpdateListener> {
  bool _shown = false;
  bool _dialogVisible = false;
  IGetLatestVersionRes? _pendingVersion;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateStore, UpdateStoreState>(
      listenWhen: (prev, curr) =>
          curr.checked && curr.latestVersion != null && !_shown,
      listener: (context, state) {
        final latest = state.latestVersion;
        if (latest == null) return;
        _shown = true;
        setState(() {
          _pendingVersion = latest;
          _dialogVisible = true;
        });
      },
      child: _dialogVisible
          ? AnnotatedRegion<SystemUiOverlayStyle>(
              value: BeaverDialog.overlaySystemStyle,
              child: _buildStack(),
            )
          : _buildStack(),
    );
  }

  Widget _buildStack() {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (_dialogVisible && _pendingVersion != null)
          _UpdatePromptDialog(
            latest: _pendingVersion!,
            onCancel: () => setState(() => _dialogVisible = false),
            onConfirm: () {
              final latest = _pendingVersion!;
              setState(() => _dialogVisible = false);
              if (Platform.isAndroid && latest.fileUrl.isNotEmpty) {
                OtaUpdate().execute(latest.fileUrl);
                return;
              }
              if (context.mounted) {
                context.push(AppRoutes.settingUpdate);
              }
            },
          ),
      ],
    );
  }
}

class _UpdatePromptDialog extends StatelessWidget {
  final IGetLatestVersionRes latest;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _UpdatePromptDialog({
    required this.latest,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final notes = latest.releaseNotes?.trim() ?? '';
    return BeaverDialog(
      title: '发现新版本',
      showCancel: !latest.forceUpdate,
      cancelText: '稍后再说',
      confirmText: '立即更新',
      maskClosable: !latest.forceUpdate,
      onCancel: onCancel,
      onConfirm: onConfirm,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '最新版本：v${latest.version ?? ''}',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF636E72),
              height: 1.5,
            ),
          ),
          if (notes.isNotEmpty) ...[
            SizedBox(height: 12.w),
            Text(
              notes,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF636E72),
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

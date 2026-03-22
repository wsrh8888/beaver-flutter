import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatToolbar extends StatelessWidget {
  final ComposerPanelType activePanel;
  final ValueChanged<ChatToolbarAction> onAction;

  const ChatToolbar({
    super.key,
    required this.activePanel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.w,
      child: Row(
        children: [
          _ToolbarButton(
            iconAsset: 'assets/images/chat/add-emoji.svg',
            active: activePanel == ComposerPanelType.emoji,
            onTap: () => onAction(ChatToolbarAction.emoji),
          ),
          SizedBox(width: 12.w),
          _ToolbarButton(
            iconAsset: 'assets/images/chat/emo.svg',
            active: activePanel == ComposerPanelType.package,
            onTap: () => onAction(ChatToolbarAction.package),
          ),
          SizedBox(width: 12.w),
          _ToolbarButton(
            iconAsset: 'assets/images/chat/photo.svg',
            onTap: () => onAction(ChatToolbarAction.image),
          ),
          SizedBox(width: 12.w),
          _ToolbarButton(
            iconAsset: 'assets/images/chat/camera.svg',
            onTap: () => onAction(ChatToolbarAction.camera),
          ),
          SizedBox(width: 12.w),
          _ToolbarButton(
            iconAsset: 'assets/images/chat/audio.svg',
            onTap: () => onAction(ChatToolbarAction.audio),
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final String iconAsset;
  final bool active;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.iconAsset,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.w,
        height: 30.w,
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFF7D45).withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(6.w),
        ),
        child: SvgPicture.asset(
          iconAsset,
          colorFilter: ColorFilter.mode(
            active ? const Color(0xFFFF7D45) : const Color(0xFF6A7480),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

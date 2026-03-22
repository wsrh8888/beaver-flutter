import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/features/chat/detail/widgets/panels/emoji_panel.dart';
import 'package:beaver/features/chat/detail/widgets/panels/package_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PanelSwitcher extends StatelessWidget {
  final ComposerPanelType activePanel;
  final ValueChanged<String> onInsertText;

  const PanelSwitcher({
    super.key,
    required this.activePanel,
    required this.onInsertText,
  });

  @override
  Widget build(BuildContext context) {
    if (activePanel == ComposerPanelType.none) {
      return SizedBox(height: 2.w);
    }

    return Container(
      margin: EdgeInsets.only(top: 8.w),
      height: 210.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: const Color(0xFFE7ECF1)),
      ),
      child: switch (activePanel) {
        ComposerPanelType.emoji => EmojiPanel(onInsertText: onInsertText),
        ComposerPanelType.package => const PackagePanel(),
        ComposerPanelType.none => const SizedBox.shrink(),
      },
    );
  }
}

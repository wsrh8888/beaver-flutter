import 'package:beaver/features/chat/detail/bloc/bloc.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/features/chat/detail/bloc/state.dart';
import 'package:beaver/features/chat/detail/components/bottom/editor.dart';
import 'package:beaver/features/chat/detail/components/bottom/recorder.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatBar extends StatelessWidget {
  final String conversationId;
  final ComposerPanelType activePanel;
  final bool isVoiceMode;
  final bool isSending;
  final bool isEditing;
  final bool isReplying;
  final FocusNode focusNode;
  final TextEditingController controller;
  const ChatBar({
    super.key,
    required this.conversationId,
    required this.activePanel,
    required this.isVoiceMode,
    required this.isSending,
    required this.isEditing,
    this.isReplying = false,
    required this.focusNode,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ChatBloc>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildIcon(context, 'chat', isVoiceMode ? 'keyboard' : 'audio', () async {
            if (!isVoiceMode) {
              final status = await Permission.microphone.request();
              if (!context.mounted) return;
              if (!status.isGranted) {
                BeaverToast.show(context, '请开启麦克风权限');
                return;
              }
              focusNode.unfocus();
            } else {
              focusNode.requestFocus();
            }
            bloc.add(const ToggleVoiceModeEvent());
          }),
          SizedBox(width: 8.w),
          Expanded(
            child: isVoiceMode
                ? ChatRecorder(conversationId: conversationId)
                : ChatEditor(
                    controller: controller,
                    focusNode: focusNode,
                    onTap: () {
                      if (activePanel != ComposerPanelType.none) {
                        bloc.add(const DismissComposerEvent());
                      }
                      focusNode.requestFocus();
                    },
                    onSubmitted: (val) {
                      final trimmed = val.trim();
                      if (trimmed.isEmpty) return;
                      if (isEditing) {
                        bloc.add(SubmitEditMessageEvent(trimmed));
                      } else {
                        bloc.add(
                          SendMessageEvent(
                            MessageContentModel(
                              type: MessageType.text,
                              textMsg: TextMsg(content: trimmed),
                            ),
                            conversationId: conversationId,
                          ),
                        );
                      }
                      controller.clear();
                    },
                  ),
          ),
          SizedBox(width: 8.w),
          _buildIcon(
            context,
            'chat',
            activePanel == ComposerPanelType.emoji ? 'keyboard' : 'emo',
            () {
              if (activePanel != ComposerPanelType.emoji)
                focusNode.unfocus();
              else
                focusNode.requestFocus();
              bloc.add(const ToggleComposerPanelEvent(ComposerPanelType.emoji));
            },
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              final hasText = value.text.trim().isNotEmpty;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: hasText
                    ? Padding(
                        key: const ValueKey('send_btn'),
                        padding: EdgeInsets.only(left: 8.w),
                        child: GestureDetector(
                          onTap: () {
                            final trimmed = value.text.trim();
                            if (trimmed.isEmpty) return;
                            if (isEditing) {
                              bloc.add(SubmitEditMessageEvent(trimmed));
                            } else {
                              bloc.add(
                                SendMessageEvent(
                                  MessageContentModel(
                                    type: MessageType.text,
                                    textMsg: TextMsg(content: trimmed),
                                  ),
                                  conversationId: conversationId,
                                ),
                              );
                            }
                            controller.clear();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 7.w,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF07C160),
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                            child: Text(
                              '发送',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Row(
                        key: const ValueKey('add_btn'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 8.w),
                          _buildIcon(context, 'common', 'add', () {
                            if (activePanel != ComposerPanelType.package)
                              focusNode.unfocus();
                            else
                              focusNode.requestFocus();
                            bloc.add(
                              const ToggleComposerPanelEvent(
                                ComposerPanelType.package,
                              ),
                            );
                          }),
                        ],
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(
    BuildContext context,
    String dir,
    String icon,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(6.w),
      child: SvgPicture.asset(
        'assets/images/$dir/$icon.svg',
        width: 26.w,
        height: 26.w,
      ),
    ),
  );
}

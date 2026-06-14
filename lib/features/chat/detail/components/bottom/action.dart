import 'package:beaver/features/chat/detail/bloc/bloc.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/features/chat/detail/bloc/state.dart';
import 'package:beaver/features/chat/detail/components/content/handler/forward.dart';
import 'package:beaver/shared/ui/dialog/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultiSelectAction extends StatelessWidget {
  const MultiSelectAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final selectedCount = state.selectedMessageIds.length;
        final hasSelection = selectedCount > 0;

        return Container(
          height: 64.w + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: const Color(0xFFE9EDF2), width: 1.w),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context,
                Icons.forward,
                '逐条转发',
                hasSelection,
                () {
                  ForwardHandler.navigateToPicker(
                    context,
                    messageIds: state.selectedMessageIds.toList(),
                    forwardMode: 1,
                  );
                  context.read<ChatBloc>().add(const CancelMultiSelectEvent());
                },
              ),
              _buildActionButton(
                context,
                Icons.layers_outlined,
                '合并转发',
                hasSelection,
                () {
                  ForwardHandler.navigateToPicker(
                    context,
                    messageIds: state.selectedMessageIds.toList(),
                    forwardMode: 2,
                  );
                  context.read<ChatBloc>().add(const CancelMultiSelectEvent());
                },
              ),
              _buildActionButton(
                context,
                Icons.delete_outline,
                '删除',
                hasSelection,
                () => _confirmDelete(context, selectedCount),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, int count) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => BeaverDialog(
        title: '删除消息',
        contentText: '确定删除选中的 $count 条消息吗？仅对自己生效。',
        confirmText: '删除',
        confirmColor: const Color(0xFFF44336),
        cancelText: '取消',
        onCancel: () => Navigator.of(dialogContext).pop(),
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          context.read<ChatBloc>().add(const DeleteSelectedMessagesEvent());
        },
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    bool enabled,
    VoidCallback onTap,
  ) {
    final color = enabled ? const Color(0xFF2D3436) : const Color(0xFFB2BEC3);
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22.w, color: color),
          SizedBox(height: 4.w),
          Text(label, style: TextStyle(fontSize: 10.sp, color: color)),
        ],
      ),
    );
  }
}

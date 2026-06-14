import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/chat/detail/bloc/bloc.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageAction {
  final String id;
  final String label;
  final IconData icon;
  final bool isDestructive;

  MessageAction({
    required this.id,
    required this.label,
    required this.icon,
    this.isDestructive = false,
  });
}

abstract class BaseMessageHandler {
  static final copyAction = MessageAction(
    id: 'copy',
    label: '复制',
    icon: Icons.content_copy,
  );
  static final replyAction = MessageAction(
    id: 'reply',
    label: '回复',
    icon: Icons.reply,
  );
  static final forwardAction = MessageAction(
    id: 'forward',
    label: '转发',
    icon: Icons.forward,
  );
  static final multiSelectAction = MessageAction(
    id: 'multiSelect',
    label: '多选',
    icon: Icons.checklist,
  );
  static final recallAction = MessageAction(
    id: 'recall',
    label: '撤回',
    icon: Icons.undo,
  );
  static final editAction = MessageAction(
    id: 'edit',
    label: '编辑',
    icon: Icons.edit_outlined,
  );
  static final deleteAction = MessageAction(
    id: 'delete',
    label: '删除',
    icon: Icons.delete_outline,
    isDestructive: true,
  );
  static final favoriteAction = MessageAction(
    id: 'favorite',
    label: '收藏',
    icon: Icons.favorite_border,
  );
  static final saveToEmojiAction = MessageAction(
    id: 'saveToEmoji',
    label: '存到表情',
    icon: Icons.add_reaction_outlined,
  );

  /// 处理命令 (如：复制, 转发, 撤回, 删除)
  Future<void> handleCommand(BuildContext context, String commandId, MessageModel message);

  /// 获取支持的命令列表
  List<String> getSupportedCommands();

  /// 获取菜单项列表
  List<MessageAction> getMenuItems(MessageModel message) {
    return [];
  }

  /// 是否可编辑（24 小时内、自己的文本/Markdown）
  bool canEditMessage(MessageModel message) {
    if (!message.isSent) return false;
    if (message.type != MessageType.text &&
        message.type != MessageType.markdown) {
      return false;
    }
    return DateTime.now().difference(message.createdAt).inHours < 24;
  }

  /// 进入编辑模式
  void startEditMessage(BuildContext context, MessageModel message) {
    context.read<ChatBloc>().add(StartEditMessageEvent(message));
  }

  /// 撤回消息
  Future<void> recallMessage(BuildContext context, MessageModel message) async {
    if (!message.isSent) {
      return;
    }

    final elapsed = DateTime.now().difference(message.createdAt);
    if (elapsed.inMinutes >= 3) {
      BeaverToast.show(context, '超过3分钟，无法撤回', type: ToastType.error);
      return;
    }

    final err = await getIt<MessageBusiness>().recallMessage(
      message.id,
      message.conversationId,
    );
    if (err != null && context.mounted) {
      BeaverToast.show(context, err, type: ToastType.error);
    }
  }

  /// 删除消息（仅对自己生效）
  Future<void> deleteMessage(BuildContext context, MessageModel message) async {
    final err = await getIt<MessageBusiness>().deleteMessage(
      message.id,
      message.conversationId,
    );
    if (err != null && context.mounted) {
      BeaverToast.show(context, err, type: ToastType.error);
    }
  }
}

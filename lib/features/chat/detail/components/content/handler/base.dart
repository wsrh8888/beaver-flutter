import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';

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
}

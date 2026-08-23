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

import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/store/chat/chat.dart';
import 'package:beaver/types/business/chat.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

/// 选择会话（对齐 PC selectConversation）
///
/// - 传入 [payload]：确认后发送消息到所选会话（分享场景）
/// - 不传 [payload]：确认后 pop 返回 [ChatModel]
class SelectConversationPage extends StatefulWidget {
  final String title;
  final Map<String, dynamic>? payload;

  const SelectConversationPage({
    super.key,
    this.title = '选择会话',
    this.payload,
  });

  @override
  State<SelectConversationPage> createState() => _SelectConversationPageState();
}

class _SelectConversationPageState extends State<SelectConversationPage> {
  String _query = '';
  String? _selectedId;
  bool _sending = false;

  bool get _isSendMode => widget.payload != null;

  List<ChatModel> _filtered(List<ChatModel> list) {
    final kw = _query.trim().toLowerCase();
    if (kw.isEmpty) return list;
    return list.where((c) => c.nickname.toLowerCase().contains(kw)).toList();
  }

  ChatModel? _findSelected(List<ChatModel> list) {
    final id = _selectedId;
    if (id == null) return null;
    for (final c in list) {
      if (c.conversationId == id) return c;
    }
    return null;
  }

  MessageContentModel _buildMessage() {
    final payload = widget.payload ?? const <String, dynamic>{};
    final mode = payload['mode'] as String? ?? 'card';

    if (mode == 'card' || mode == 'circleCard') {
      final cardType =
          payload['cardType'] as int? ?? (mode == 'circleCard' ? 3 : 0);
      final id = (payload['id'] as String?) ??
          (payload['circleId'] as String?) ??
          '';
      final inviteToken = (payload['inviteToken'] as String?)?.trim() ?? '';
      if (id.isEmpty && inviteToken.isEmpty) {
        throw Exception('名片信息不完整');
      }
      return MessageContentModel(
        type: MessageType.card,
        cardMsg: CardMsg(
          cardType: cardType,
          id: id,
          expireAt: (payload['expireAt'] as int?) ?? 0,
          inviteToken: inviteToken,
        ),
      );
    }

    if (mode == 'text') {
      return MessageContentModel(
        type: MessageType.text,
        textMsg: TextMsg(content: payload['content'] as String? ?? ''),
      );
    }

    throw Exception('不支持的分享类型');
  }

  Future<void> _onConfirm(List<ChatModel> conversations) async {
    final selected = _findSelected(conversations);
    if (selected == null) return;

    if (!_isSendMode) {
      context.pop(selected);
      return;
    }

    if (_sending) return;
    setState(() => _sending = true);

    try {
      final msg = _buildMessage();
      final chatType =
          selected.conversationId.startsWith('group_') ? 'group' : 'private';

      await getIt<MessageBusiness>().sendMessage(
        ChatMessageSendBody(
          conversationId: selected.conversationId,
          messageId: const Uuid().v4(),
          msg: msg,
          chatType: chatType,
        ),
      );

      if (!mounted) return;
      BeaverToast.show(context, '已发送');
      context.pop(true);
    } catch (_) {
      if (!mounted) return;
      BeaverToast.show(context, '发送失败');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: widget.title,
      showBack: true,
      isScrollable: false,
      child: BlocBuilder<ChatStore, ChatStoreState>(
        builder: (context, state) {
          final list = _filtered(state.conversations);
          final selected = _findSelected(state.conversations);
          final canConfirm = selected != null && !_sending;

          return Column(
            children: [
              _buildSearchBar(),
              Expanded(child: _buildList(list)),
              _buildBottomBar(
                selected: selected,
                canConfirm: canConfirm,
                onConfirm: () => _onConfirm(state.conversations),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F2F6),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 20.w, color: const Color(0xFF99A3AD)),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                onChanged: (val) => setState(() => _query = val),
                decoration: const InputDecoration(
                  hintText: '搜索会话',
                  hintStyle: TextStyle(color: Color(0xFF99A3AD)),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<ChatModel> list) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          '暂无会话',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFFB2BEC3)),
        ),
      );
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final isSelected = item.conversationId == _selectedId;

        return InkWell(
          onTap: _sending
              ? null
              : () => setState(() => _selectedId = item.conversationId),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFFF7D45).withValues(alpha: 0.06)
                  : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFFE9EDF2),
                  width: 1.w,
                ),
              ),
            ),
            child: Row(
              children: [
                BeaverAvatar(avatar: item.avatar, size: 40),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    item.nickname,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                ),
                Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(0xFFFF7D45)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFF7D45)
                          : const Color(0xFFDFE6E9),
                      width: 1.5.w,
                    ),
                  ),
                  child: isSelected
                      ? Icon(Icons.check, size: 14.w, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar({
    required ChatModel? selected,
    required bool canConfirm,
    required VoidCallback onConfirm,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border(
          top: BorderSide(color: const Color(0xFFEBEEF5), width: 1.w),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Text(
                selected == null
                    ? '请从列表选择会话'
                    : '已选择：${selected.nickname}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight:
                      selected == null ? FontWeight.w400 : FontWeight.w600,
                  color: selected == null
                      ? const Color(0xFFB2BEC3)
                      : const Color(0xFF2D3436),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: canConfirm ? onConfirm : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
                decoration: BoxDecoration(
                  color: canConfirm
                      ? const Color(0xFFFF7D45)
                      : const Color(0xFFFFD1BD),
                  borderRadius: BorderRadius.circular(6.w),
                ),
                child: Text(
                  _sending
                      ? '发送中...'
                      : (_isSendMode ? '发送' : '确定'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

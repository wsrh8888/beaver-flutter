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

import 'package:beaver/api/circle.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/chat/detail/components/content/message/card/components/preview_dialog.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/store/circle/circle.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/store/group/group.dart';
import 'package:beaver/theme/colors.dart';
import 'package:beaver/types/api/circle.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 通用名片消息：消息体只带 cardType + id，点击打开预览弹窗。
class CardMessage extends StatefulWidget {
  final CardMsg msg;
  final bool isSelf;

  const CardMessage({
    super.key,
    required this.msg,
    this.isSelf = false,
  });

  @override
  State<CardMessage> createState() => _CardMessageState();
}

class _CardMessageState extends State<CardMessage> {
  String _title = '';
  String? _avatar;
  String _subtitle = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant CardMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.msg.id != widget.msg.id ||
        oldWidget.msg.cardType != widget.msg.cardType) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _title = widget.msg.typeLabel;
      _avatar = null;
      _subtitle = '';
    });

    switch (widget.msg.cardType) {
      case 1:
        final user = getIt<ContactStore>().getContact(widget.msg.id);
        if (mounted) {
          setState(() {
            _title = user?.nickname.isNotEmpty == true
                ? user!.nickname
                : widget.msg.typeLabel;
            _avatar = user?.avatar;
            _subtitle = '个人名片';
            _loading = false;
          });
        }
        break;
      case 2:
        final group = getIt<GroupStore>().getGroup(widget.msg.id);
        if (mounted) {
          setState(() {
            _title = group?.title.isNotEmpty == true
                ? group!.title
                : widget.msg.typeLabel;
            _avatar = group?.avatar;
            _subtitle = '群名片';
            _loading = false;
          });
        }
        break;
      case 3:
        final cached = getIt<CircleStore>().getCircle(widget.msg.id);
        if (cached != null) {
          if (mounted) {
            setState(() {
              _title = cached.name.isNotEmpty
                  ? cached.name
                  : widget.msg.typeLabel;
              _avatar = cached.avatar;
              _subtitle = cached.description.isNotEmpty
                  ? cached.description
                  : '${cached.memberCount} 位成员';
              _loading = false;
            });
          }
          break;
        }
        final res = await getCircleDetailApi(
          IGetCircleDetailReq(circleId: widget.msg.id),
        );
        if (!mounted) return;
        if (res.code == 0 && res.result != null) {
          final detail = res.result!;
          setState(() {
            _title = detail.name.isNotEmpty ? detail.name : widget.msg.typeLabel;
            _avatar = detail.avatar;
            _subtitle = detail.description.isNotEmpty
                ? detail.description
                : '${detail.memberCount} 位成员';
            _loading = false;
          });
        } else {
          setState(() {
            _title = widget.msg.typeLabel;
            _subtitle = '点击查看';
            _loading = false;
          });
        }
        break;
      default:
        if (mounted) {
          setState(() {
            _loading = false;
            _subtitle = '未知名片';
          });
        }
    }
  }

  void _open(BuildContext context) {
    if (widget.msg.isExpired) {
      BeaverToast.show(context, '名片已过期');
      return;
    }
    if (widget.msg.id.isEmpty && widget.msg.inviteToken.isEmpty) {
      BeaverToast.show(context, '名片信息不完整');
      return;
    }
    showCardPreviewDialog(context, msg: widget.msg);
  }

  @override
  Widget build(BuildContext context) {
    final titleColor =
        widget.isSelf ? AppColors.chatBubbleSelfText : AppColors.chatBubbleOtherText;
    final subColor = widget.isSelf
        ? AppColors.chatBubbleSelfText.withValues(alpha: 0.7)
        : AppColors.chatBubbleOtherSubText;
    final expired = widget.msg.isExpired;

    return GestureDetector(
      onTap: () => _open(context),
      child: Opacity(
        opacity: expired ? 0.55 : 1,
        child: SizedBox(
          width: 220.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BeaverAvatar(avatar: _avatar, size: 44),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _loading ? '加载中...' : _title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                        ),
                        SizedBox(height: 4.w),
                        Text(
                          expired
                              ? '名片已过期'
                              : (_subtitle.isNotEmpty
                                  ? _subtitle
                                  : widget.msg.typeLabel),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.sp, color: subColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.w),
              Divider(height: 1.w, color: Colors.black.withValues(alpha: 0.06)),
              SizedBox(height: 8.w),
              Text(
                widget.msg.typeLabel,
                style: TextStyle(fontSize: 11.sp, color: subColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

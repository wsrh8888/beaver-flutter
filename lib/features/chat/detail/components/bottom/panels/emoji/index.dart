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

import 'package:beaver/features/chat/detail/components/bottom/panels/emoji/emoji.dart';
import 'package:beaver/features/chat/detail/components/bottom/panels/emoji/sticker.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/store/emoji/emoji.dart';
import 'package:beaver/types/business/emoji.dart';
import 'package:beaver/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EmojiPanel extends StatefulWidget {
  final TextEditingController? controller;
  final String conversationId;

  const EmojiPanel({super.key, this.controller, required this.conversationId});
  @override
  State<EmojiPanel> createState() => _EmojiPanelState();
}

class _EmojiPanelState extends State<EmojiPanel> {
  String _activeTab = 'default'; // 'default', 'favorite', or packageId

  @override
  void initState() {
    super.initState();
    context.read<EmojiStore>().init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmojiStore, EmojiStoreState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(child: _buildContent(state)),
            _buildTabs(state),
          ],
        );
      },
    );
  }

  Widget _buildContent(EmojiStoreState state) {
    if (_activeTab == 'default') {
      return EmojiGrid(
        controller: widget.controller,
        conversationId: widget.conversationId,
      );
    } else if (_activeTab == 'favorite') {
      return StickerGrid(conversationId: widget.conversationId);
    } else {
      return EmojiGrid(
        packageId: _activeTab,
        conversationId: widget.conversationId,
      );
    }
  }

  Widget _buildTabs(EmojiStoreState state) {
    return Container(
      height: 48.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFF1F2F6), width: 1.w)),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildTabItem('shop', Icons.store_outlined), // 第一个商店
          _buildTabItem('default', Icons.face_outlined), // 第二个默认
          _buildTabItem('favorite', Icons.favorite_border_rounded), // 第三个收藏
          ...state.packageList.map((p) => _buildPackageTabItem(p)),
        ],
      ),
    );
  }

  Widget _buildTabItem(String id, IconData icon) {
    final isSelected = _activeTab == id;
    return GestureDetector(
      onTap: () {
        if (id == 'shop') {
          // 跳转到表情商店路由
          context.push(AppRoutes.emojiShop);
          return;
        }
        setState(() => _activeTab = id);
      },
      child: Container(
        width: 50.w,
        alignment: Alignment.center,
        color: isSelected ? const Color(0xFFF1F2F6) : Colors.transparent,
        child: Icon(
          icon,
          size: 24.w,
          color: isSelected ? const Color(0xFFFF7D45) : const Color(0xFF99A3AD),
        ),
      ),
    );
  }

  Widget _buildPackageTabItem(EmojiPackageModel package) {
    final isSelected = _activeTab == package.packageId;
    return GestureDetector(
      onTap: () {
        setState(() => _activeTab = package.packageId);
        context.read<EmojiStore>().loadPackageEmojis(package.packageId);
      },
      child: Container(
        width: 50.w,
        padding: EdgeInsets.all(10.w),
        alignment: Alignment.center,
        color: isSelected ? const Color(0xFFF1F2F6) : Colors.transparent,
        child: BeaverCachedImage(
          fileUrl: package.coverFile,
          width: 28.w,
          height: 28.w,
          placeholder: Icon(Icons.image, size: 22.w, color: Colors.grey),
        ),
      ),
    );
  }
}

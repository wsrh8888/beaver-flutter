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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/shared/ui/layout/layout.dart';

class _RepoItem {
  const _RepoItem({
    required this.name,
    required this.desc,
    required this.url,
  });

  final String name;
  final String desc;
  final String url;
}

/// 开源致谢（署名示范页，对齐桌面端 about / 文档站要求）
class OpenSourcePage extends StatelessWidget {
  const OpenSourcePage({super.key});

  static const _serverRepoUrl = 'https://github.com/wsrh8888/beaver-server';
  static const _licenseDocUrl =
      'https://wsrh8888.github.io/beaver-docs/community/license.html';
  static const _communityDocUrl =
      'https://wsrh8888.github.io/beaver-docs/community/';
  static const _mailUrl = 'mailto:751135385@qq.com';

  static const _repos = <_RepoItem>[
    _RepoItem(
      name: 'beaver-server',
      desc: '服务端微服务',
      url: 'https://github.com/wsrh8888/beaver-server',
    ),
    _RepoItem(
      name: 'beaver-desktop',
      desc: '桌面端 Electron',
      url: 'https://github.com/wsrh8888/beaver-desktop',
    ),
    _RepoItem(
      name: 'beaver-flutter',
      desc: '移动端 Flutter',
      url: 'https://github.com/wsrh8888/beaver-flutter',
    ),
    _RepoItem(
      name: 'beaver-manager',
      desc: '后台管理系统',
      url: 'https://github.com/wsrh8888/beaver-manager',
    ),
    _RepoItem(
      name: 'beaver-open',
      desc: '开放平台',
      url: 'https://github.com/wsrh8888/beaver-open',
    ),
    _RepoItem(
      name: 'beaver-oauth',
      desc: 'OAuth 授权登录',
      url: 'https://github.com/wsrh8888/beaver-oauth',
    ),
    _RepoItem(
      name: 'beaver-docs',
      desc: '官方文档站',
      url: 'https://github.com/wsrh8888/beaver-docs',
    ),
  ];

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '开源致谢',
      showBack: true,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 40.w),
        child: Column(
          children: [
            _buildHero(),
            SizedBox(height: 16.w),
            _buildTip(),
            SizedBox(height: 16.w),
            _buildRepoBlock(),
            SizedBox(height: 16.w),
            _buildLicenseBlock(),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 28.w, 20.w, 28.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFF7D45).withOpacity(0.12),
            const Color(0xFFFF7D45).withOpacity(0.03),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFFF7D45).withOpacity(0.22),
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 72.w,
            height: 72.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 14.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7D45).withOpacity(0.15),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '署名示范',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFF7D45),
              ),
            ),
          ),
          SizedBox(height: 12.w),
          Text(
            '本项目使用了开源项目',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF636E72),
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            '海狸 IM (Beaver IM)',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFFF7D45),
            ),
          ),
          SizedBox(height: 10.w),
          Text(
            '当前移动端版本 ${AppConfig.version}',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFFB2BEC3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F4),
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(
          color: const Color(0xFFFF7D45).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '给二次开发者的说明',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFF7D45),
            ),
          ),
          SizedBox(height: 6.w),
          Text(
            '上线部署时，请在前端「开源致谢 / 海狸署名」等独立署名页保留与下方同等显著的内容：写明「本项目使用了开源项目 海狸 IM (Beaver IM)」，并列出所用仓库地址。本页即为官方示范，请勿仅把版权藏在代码注释里。',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF636E72),
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepoBlock() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFEBEEF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '本项目使用的开源项目',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            '以下仓库均属于海狸 IM 开源体系，点击可在浏览器打开：',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF636E72),
              height: 1.6,
            ),
          ),
          SizedBox(height: 14.w),
          ..._repos.map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.w),
              child: _buildRepoItem(item),
            );
          }),
          SizedBox(height: 6.w),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '主仓库推荐标注：',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF636E72),
                ),
              ),
              GestureDetector(
                onTap: () => _openUrl(_serverRepoUrl),
                child: Text(
                  _serverRepoUrl,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFFFF7D45),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepoItem(_RepoItem item) {
    return GestureDetector(
      onTap: () => _openUrl(item.url),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(color: const Color(0xFFEBEEF5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                  SizedBox(height: 2.w),
                  Text(
                    item.desc,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF636E72),
                    ),
                  ),
                  SizedBox(height: 2.w),
                  Text(
                    item.url,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFFB2BEC3),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              '打开',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFFFF7D45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenseBlock() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFEBEEF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '版权与商业授权',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 10.w),
          _buildBullet('开源协议：MIT（仓库根目录 LICENSE 不得删除）'),
          _buildBullet('闭源自用 / 二次开源：免费，须保留本页类署名'),
          _buildBullet('去署名、闭源交付第三方、对外 SaaS：需采购商业授权'),
          SizedBox(height: 16.w),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.w,
            children: [
              _buildActionButton(
                label: '查看版权与商业授权说明',
                primary: true,
                onTap: () => _openUrl(_licenseDocUrl),
              ),
              _buildActionButton(
                label: '打开文档站社区页',
                primary: false,
                onTap: () => _openUrl(_communityDocUrl),
              ),
            ],
          ),
          SizedBox(height: 16.w),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '商业授权联系：',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF636E72),
                ),
              ),
              GestureDetector(
                onTap: () => _openUrl(_mailUrl),
                child: Text(
                  '751135385@qq.com',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFFFF7D45),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•  ',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF636E72),
              height: 1.8,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF636E72),
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required bool primary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.w),
        decoration: BoxDecoration(
          color: primary ? const Color(0xFFFF7D45) : Colors.white,
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(
            color: primary ? const Color(0xFFFF7D45) : const Color(0xFFEBEEF5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: primary ? Colors.white : const Color(0xFF2D3436),
          ),
        ),
      ),
    );
  }
}

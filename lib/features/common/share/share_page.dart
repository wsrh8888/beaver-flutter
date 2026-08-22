import 'dart:ui' as ui;

import 'package:beaver/features/common/share/share_args.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/shared/utils/invite/invite.dart';
import 'package:beaver/shared/utils/media_util.dart';
import 'package:beaver/types/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';

enum _ShareTab { card, link, qr }

/// 全屏实体分享页（对齐 PC ShareUi：名片 / 链接 / 二维码）
class EntitySharePage extends StatefulWidget {
  final EntityShareArgs args;

  const EntitySharePage({super.key, required this.args});

  @override
  State<EntitySharePage> createState() => _EntitySharePageState();
}

class _EntitySharePageState extends State<EntitySharePage> {
  _ShareTab _tab = _ShareTab.card;
  final GlobalKey _qrKey = GlobalKey();
  bool _saving = false;

  EntityShareArgs get args => widget.args;

  String get _inviteCode => parseInviteCode(args.inviteUrl) ?? '';

  Future<void> _shareCard() async {
    await context.push(
      AppRoutes.selectConversation,
      extra: {
        'title': '选择会话',
        'payload': {
          'mode': 'card',
          'cardType': args.cardType,
          'id': args.id,
          'inviteToken': _inviteCode,
          'expireAt': 0,
        },
      },
    );
  }

  Future<void> _shareLink() async {
    await context.push(
      AppRoutes.selectConversation,
      extra: {
        'title': '选择会话',
        'payload': {
          'mode': 'text',
          'content': args.inviteUrl,
        },
      },
    );
  }

  Future<void> _copyLink() async {
    await Clipboard.setData(ClipboardData(text: args.inviteUrl));
    if (!mounted) return;
    BeaverToast.show(context, '邀请链接已复制');
  }

  Future<void> _saveQr() async {
    if (_saving) return;
    setState(() => _saving = true);

    final ok = await requestGallerySavePermission(context);
    if (!ok) {
      if (mounted) setState(() => _saving = false);
      return;
    }

    final boundary =
        _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      if (mounted) {
        BeaverToast.show(context, '保存失败，请重试');
        setState(() => _saving = false);
      }
      return;
    }

    try {
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        if (mounted) BeaverToast.show(context, '保存失败，请重试');
        return;
      }
      final result = await ImageGallerySaverPlus.saveImage(
        byteData.buffer.asUint8List(),
        quality: 100,
        name:
            '${args.isGroup ? 'group' : 'circle'}-qr-${_inviteCode.isNotEmpty ? _inviteCode : args.id}',
      );
      if (!mounted) return;
      if (result != null && result['isSuccess'] == true) {
        BeaverToast.show(context, '已保存到相册');
      } else {
        BeaverToast.show(context, '保存失败，请重试');
      }
    } catch (_) {
      if (mounted) BeaverToast.show(context, '保存失败，请重试');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: args.title,
      showBack: true,
      isScrollable: false,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 0),
            child: _buildTabs(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 20.w, 16.w, 16.w),
              child: switch (_tab) {
                _ShareTab.card => _buildCardPanel(),
                _ShareTab.link => _buildLinkPanel(),
                _ShareTab.qr => _buildQrPanel(),
              },
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final items = [
      (_ShareTab.card, args.cardTabLabel),
      (_ShareTab.link, '获取链接'),
      (_ShareTab.qr, args.qrTabLabel),
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _tab = item.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 34.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _tab == item.$1 ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                  child: Text(
                    item.$2,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: _tab == item.$1
                          ? const Color(0xFFFF7D45)
                          : const Color(0xFF636E72),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardPanel() {
    final name = args.name.isNotEmpty ? args.name : '未命名';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.w),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 18.w, 16.w, 14.w),
            child: Row(
              children: [
                _buildAvatar(),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.w,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7D45).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child: Text(
                          args.cardTabLabel,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFE86835),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.w),
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3436),
                        ),
                      ),
                      SizedBox(height: 6.w),
                      Text(
                        args.cardHint,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF95A5A6),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
            color: const Color(0xFFFAFBFC),
            child: Text(
              '预览效果 · 发送到会话',
              style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xFFB2BEC3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final avatar = args.avatar?.trim() ?? '';
    if (avatar.isNotEmpty) {
      return BeaverCachedImage(
        fileUrl: avatar,
        type: CacheType.avatar,
        width: 60.w,
        height: 60.w,
        borderRadius: 14.w,
      );
    }
    final text = args.name.isNotEmpty ? args.name.characters.first : '?';
    return Container(
      width: 60.w,
      height: 60.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1EB),
        borderRadius: BorderRadius.circular(14.w),
        border: Border.all(
          color: const Color(0xFFFF7D45).withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFFF7D45),
        ),
      ),
    );
  }

  Widget _buildLinkPanel() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFEBEEF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '邀请链接',
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF95A5A6)),
          ),
          SizedBox(height: 8.w),
          SelectableText(
            args.inviteUrl,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF2D3436),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrPanel() {
    return Column(
      children: [
        RepaintBoundary(
          key: _qrKey,
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.w),
              border: Border.all(color: const Color(0xFFEBEEF5)),
            ),
            child: QrImageView(
              data: args.inviteUrl,
              size: 180.w,
              backgroundColor: Colors.white,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
            ),
          ),
        ),
        SizedBox(height: 12.w),
        Text(
          '扫码即可加入「${args.name}」',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF636E72)),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 12.w),
        child: switch (_tab) {
          _ShareTab.card => _primaryButton('分享', _shareCard),
          _ShareTab.link => _primaryButton('复制', _copyLink),
          _ShareTab.qr => Row(
              children: [
                Expanded(
                  child: _outlineButton(
                    _saving ? '保存中...' : '保存图片',
                    _saving ? null : _saveQr,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _primaryButton('分享链接', _shareLink),
                ),
              ],
            ),
        },
      ),
    );
  }

  Widget _outlineButton(String text, VoidCallback? onTap) {
    return SizedBox(
      height: 44.w,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF2D3436),
          side: const BorderSide(color: Color(0xFFEBEEF5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.w),
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: 15.sp)),
      ),
    );
  }

  Widget _primaryButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 44.w,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF7D45),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.w),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

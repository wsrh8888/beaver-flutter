import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/shared/utils/qrcode/handlers/join_circle/index.dart';
import 'package:beaver/shared/utils/qrcode/handlers/join_group/index.dart';

/// 通用实体分享：名片 / 链接 / 二维码
/// cardType: 1=个人 2=群 3=圈子
Future<void> showCardShareSheet({
  required BuildContext context,
  required int cardType,
  required String id,
  required String name,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.w)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBEEF5),
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              SizedBox(height: 16.w),
              Text(
                '分享「$name」',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 6.w),
              Text(
                '选择分享方式',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF636E72),
                ),
              ),
              SizedBox(height: 20.w),
              Row(
                children: [
                  Expanded(
                    child: _ShareAction(
                      icon: Icons.badge_outlined,
                      label: '名片',
                      onTap: () {
                        Navigator.of(context).pop();
                        context.push(
                          AppRoutes.chatShareConversation,
                          extra: {
                            'mode': 'card',
                            'cardType': cardType,
                            'id': id,
                            'expireAt': 0,
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _ShareAction(
                      icon: Icons.link,
                      label: '链接',
                      onTap: () async {
                        final link = _buildLink(cardType, id);
                        await Clipboard.setData(ClipboardData(text: link));
                        if (context.mounted) {
                          BeaverToast.show(context, '邀请链接已复制');
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _ShareAction(
                      icon: Icons.qr_code_2,
                      label: '二维码',
                      onTap: () {
                        Navigator.of(context).pop();
                        showCardQrDialog(
                          context: context,
                          cardType: cardType,
                          id: id,
                          name: name,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showCircleInviteSheet({
  required BuildContext context,
  required String circleId,
  required String circleName,
}) {
  return showCardShareSheet(
    context: context,
    cardType: 3,
    id: circleId,
    name: circleName,
  );
}

Future<void> showGroupInviteSheet({
  required BuildContext context,
  required String groupId,
  required String groupName,
}) {
  return showCardShareSheet(
    context: context,
    cardType: 2,
    id: groupId,
    name: groupName,
  );
}

Future<void> showCardQrDialog({
  required BuildContext context,
  required int cardType,
  required String id,
  required String name,
}) {
  final link = _buildLink(cardType, id);
  final qrValue = _buildQr(cardType, id);
  final label = switch (cardType) {
    2 => '群聊',
    3 => '圈子',
    _ => '名片',
  };

  return showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '「$name」$label二维码',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 16.w),
              QrImageView(
                data: qrValue,
                size: 180.w,
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 12.w),
              Text(
                '扫码即可加入$label',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF636E72),
                ),
              ),
              SizedBox(height: 16.w),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: link));
                    if (context.mounted) {
                      BeaverToast.show(context, '邀请链接已复制');
                    }
                  },
                  child: const Text('复制链接'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('关闭'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

String _buildLink(int cardType, String id) {
  if (cardType == 2) return buildGroupShareLink(id);
  if (cardType == 3) return buildCircleShareLink(id);
  return id;
}

String _buildQr(int cardType, String id) {
  if (cardType == 2) return buildGroupInviteQrValue(id);
  if (cardType == 3) return buildCircleInviteQrValue(id);
  return id;
}

class _ShareAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShareAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(color: const Color(0xFFEBEEF5)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28.w, color: const Color(0xFFFF7D45)),
            SizedBox(height: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF2D3436),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

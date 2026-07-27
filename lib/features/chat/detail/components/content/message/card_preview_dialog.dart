import 'package:beaver/api/circle.dart';
import 'package:beaver/api/group.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/store/friend/friend.dart';
import 'package:beaver/store/group/group.dart';
import 'package:beaver/types/api/circle.dart';
import 'package:beaver/types/api/group.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

Future<void> showCardPreviewDialog(
  BuildContext context, {
  required CardMsg msg,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => _CardPreviewDialog(msg: msg),
  );
}

class _CardPreviewDialog extends StatefulWidget {
  final CardMsg msg;

  const _CardPreviewDialog({required this.msg});

  @override
  State<_CardPreviewDialog> createState() => _CardPreviewDialogState();
}

class _CardPreviewDialogState extends State<_CardPreviewDialog> {
  bool _loading = true;
  bool _joining = false;
  String? _error;
  String _name = '';
  String? _avatar;
  String _desc = '';
  bool _alreadyJoined = false;
  bool _isFriend = false;

  String get _typeLabel {
    switch (widget.msg.cardType) {
      case 1:
        return '个人名片';
      case 2:
        return '群名片';
      case 3:
        return '圈子名片';
      default:
        return '名片';
    }
  }

  String get _primaryText {
    switch (widget.msg.cardType) {
      case 1:
        return _isFriend ? '发消息' : '查看资料';
      case 2:
        return _alreadyJoined ? '进入群聊' : '加入';
      case 3:
        return _alreadyJoined ? '进入圈子' : '加入';
      default:
        return '关闭';
    }
  }

  String get _groupId {
    final id = widget.msg.id;
    return id.startsWith('group_') ? id.substring('group_'.length) : id;
  }

  String get _conversationId => 'group_$_groupId';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      switch (widget.msg.cardType) {
        case 1:
          final user = getIt<ContactStore>().getContact(widget.msg.id);
          final isFriend = getIt<FriendStore>()
              .state
              .friends
              .any((f) => f.userId == widget.msg.id);
          setState(() {
            _name = user?.nickname.isNotEmpty == true
                ? user!.nickname
                : '用户';
            _avatar = user?.avatar;
            _desc = '个人名片';
            _isFriend = isFriend;
            _loading = false;
          });
          break;
        case 2:
          final cached = getIt<GroupStore>().getGroup(widget.msg.id);
          if (cached != null) {
            _name = cached.title.isNotEmpty ? cached.title : '群聊';
            _avatar = cached.avatar;
            _desc = '群名片';
            _alreadyJoined = true;
          }
          final res = await getGroupInfoApi(IGroupInfoReq(groupId: _groupId));
          if (!mounted) return;
          if (res.code == 0 && res.result != null) {
            final info = res.result!;
            setState(() {
              _name = info.title.isNotEmpty ? info.title : (_name.isNotEmpty ? _name : '群聊');
              _avatar = info.avatar.isNotEmpty ? info.avatar : _avatar;
              _desc = info.notice.isNotEmpty
                  ? info.notice
                  : (info.memberCount > 0 ? '${info.memberCount} 位成员' : '群名片');
              _alreadyJoined =
                  getIt<GroupStore>().getGroup(_conversationId) != null;
              _loading = false;
            });
          } else if (!_alreadyJoined) {
            setState(() {
              _error = res.msg.isNotEmpty ? res.msg : '获取群信息失败';
              _loading = false;
            });
          } else {
            setState(() => _loading = false);
          }
          break;
        case 3:
          final res = await getCircleDetailApi(
            IGetCircleDetailReq(circleId: widget.msg.id),
          );
          if (!mounted) return;
          if (res.code != 0 || res.result == null) {
            setState(() {
              _error = res.msg.isNotEmpty ? res.msg : '获取圈子信息失败';
              _loading = false;
            });
            return;
          }
          final detail = res.result!;
          setState(() {
            _name = detail.name.isNotEmpty ? detail.name : '圈子';
            _avatar = detail.avatar;
            _desc = detail.description.isNotEmpty
                ? detail.description
                : '${detail.memberCount} 位成员';
            _alreadyJoined = detail.role > 0;
            _loading = false;
          });
          break;
        default:
          setState(() {
            _error = '暂不支持该名片类型';
            _loading = false;
          });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = '加载失败';
        _loading = false;
      });
    }
  }

  Future<void> _onPrimary() async {
    if (_joining || widget.msg.isExpired) return;

    if (widget.msg.cardType == 1) {
      Navigator.of(context).pop();
      if (!mounted) return;
      context.push(
        AppRoutes.contactDetail.replaceFirst(':userId', widget.msg.id),
      );
      return;
    }

    if (_alreadyJoined) {
      Navigator.of(context).pop();
      if (!mounted) return;
      if (widget.msg.cardType == 2) {
        context.push('${AppRoutes.chatDetail}?id=$_conversationId&type=group');
      } else if (widget.msg.cardType == 3) {
        final uri = Uri(
          path: AppRoutes.circleJoin,
          queryParameters: {'circleId': widget.msg.id},
        );
        context.push(uri.toString());
      }
      return;
    }

    setState(() => _joining = true);
    try {
      if (widget.msg.cardType == 2) {
        final res = await joinGroupApi(IGroupJoinReq(groupId: _groupId));
        if (!mounted) return;
        if (res.code == 0) {
          BeaverToast.show(context, '已加入群聊');
          await getIt<GroupStore>().init();
          Navigator.of(context).pop();
          if (!mounted) return;
          context.push('${AppRoutes.chatDetail}?id=$_conversationId&type=group');
        } else {
          BeaverToast.show(
            context,
            res.msg.isNotEmpty ? res.msg : '加入失败',
          );
        }
      } else if (widget.msg.cardType == 3) {
        final res = await joinCircleApi(
          IJoinCircleReq(circleId: widget.msg.id),
        );
        if (!mounted) return;
        if (res.code == 0) {
          final status = res.result?.status ?? 1;
          if (status == 0) {
            BeaverToast.show(context, '申请已提交，等待圈主审批');
            Navigator.of(context).pop();
          } else {
            BeaverToast.show(context, '已加入圈子');
            Navigator.of(context).pop();
            if (!mounted) return;
            final uri = Uri(
              path: AppRoutes.circleJoin,
              queryParameters: {'circleId': widget.msg.id},
            );
            context.push(uri.toString());
          }
        } else {
          BeaverToast.show(
            context,
            res.msg.isNotEmpty ? res.msg : '加入失败',
          );
        }
      }
    } catch (_) {
      if (!mounted) return;
      BeaverToast.show(context, '加入失败');
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expired = widget.msg.isExpired;

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
              _typeLabel,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436),
              ),
            ),
            SizedBox(height: 20.w),
            if (_loading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 36.w),
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            else if (_error != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 36.w),
                child: Text(
                  _error!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFFF44336),
                  ),
                ),
              )
            else ...[
              BeaverAvatar(avatar: _avatar, size: 72),
              SizedBox(height: 14.w),
              Text(
                _name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3436),
                ),
              ),
              if (_desc.isNotEmpty) ...[
                SizedBox(height: 8.w),
                Text(
                  _desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF636E72),
                    height: 1.4,
                  ),
                ),
              ],
              if (expired) ...[
                SizedBox(height: 8.w),
                Text(
                  '名片已过期',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFFF44336),
                  ),
                ),
              ],
            ],
            SizedBox(height: 20.w),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('关闭'),
                  ),
                ),
                if (!_loading && _error == null && !expired) ...[
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _joining ? null : _onPrimary,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7D45),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        disabledBackgroundColor: const Color(0xFFE0E0E0),
                      ),
                      child: _joining
                          ? SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(_primaryText),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

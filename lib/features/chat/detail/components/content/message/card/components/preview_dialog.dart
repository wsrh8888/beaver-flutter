import 'package:beaver/api/circle.dart';
import 'package:beaver/api/group.dart';
import 'package:beaver/core/business/circle/circle.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/dialog/index.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/store/circle/circle.dart';
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
    barrierColor: Colors.transparent,
    builder: (dialogContext) => Stack(
      fit: StackFit.expand,
      children: [
        _CardPreviewDialog(msg: msg),
      ],
    ),
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
  String _resolvedId = '';

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

  String get _inviteToken => widget.msg.inviteToken.trim();

  String get _entityId {
    if (_resolvedId.isNotEmpty) return _resolvedId;
    return widget.msg.id;
  }

  String get _groupId {
    final id = _entityId;
    return id.startsWith('group_') ? id.substring('group_'.length) : id;
  }

  String get _conversationId => 'group_$_groupId';

  @override
  void initState() {
    super.initState();
    _resolvedId = widget.msg.id;
    _load();
  }

  Future<void> _loadByInviteToken() async {
    if (widget.msg.cardType == 2) {
      final res = await resolveGroupInviteApi(
        IResolveGroupInviteReq(code: _inviteToken),
      );
      if (!mounted) return;
      if (res.code != 0 ||
          res.result == null ||
          (!res.result!.valid && !res.result!.alreadyJoined)) {
        setState(() {
          _error = res.msg.isNotEmpty ? res.msg : '邀请无效或已失效';
          _loading = false;
        });
        return;
      }
      final data = res.result!;
      setState(() {
        _resolvedId = data.groupId;
        _name = data.title.isNotEmpty ? data.title : '群聊';
        _avatar = data.avatar;
        _desc = data.notice.isNotEmpty
            ? data.notice
            : '${data.memberCount} 位成员';
        _alreadyJoined = data.alreadyJoined ||
            getIt<GroupStore>().getGroup('group_${data.groupId}') != null;
        _loading = false;
      });
      return;
    }

    if (widget.msg.cardType == 3) {
      final res = await resolveCircleInviteApi(
        IResolveCircleInviteReq(code: _inviteToken),
      );
      if (!mounted) return;
      if (res.code != 0 ||
          res.result == null ||
          (!res.result!.valid && !res.result!.alreadyJoined)) {
        setState(() {
          _error = res.msg.isNotEmpty ? res.msg : '邀请无效或已失效';
          _loading = false;
        });
        return;
      }
      final data = res.result!;
      setState(() {
        _resolvedId = data.circleId;
        _name = data.name.isNotEmpty ? data.name : '圈子';
        _avatar = data.avatar;
        _desc = data.description.isNotEmpty
            ? data.description
            : '${data.memberCount} 位成员';
        _alreadyJoined = data.alreadyJoined;
        _loading = false;
      });
      if (data.alreadyJoined) {
        await getIt<CircleBusiness>().upsertFromDetail(
          IGetCircleDetailRes(
            circleId: data.circleId,
            name: data.name,
            description: data.description,
            avatar: data.avatar,
            joinType: data.joinType,
            creatorId: '',
            memberCount: data.memberCount,
            postCount: 0,
            role: 3,
            createdAt: '',
          ),
        );
      }
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // 仅有邀请码、无实体 id：走 resolve
      if (_inviteToken.isNotEmpty &&
          widget.msg.id.isEmpty &&
          (widget.msg.cardType == 2 || widget.msg.cardType == 3)) {
        await _loadByInviteToken();
        return;
      }

      if (widget.msg.id.isEmpty && _inviteToken.isEmpty) {
        setState(() {
          _error = '名片信息不完整';
          _loading = false;
        });
        return;
      }

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
              _resolvedId = info.groupId.isNotEmpty ? info.groupId : _groupId;
              _name = info.title.isNotEmpty
                  ? info.title
                  : (_name.isNotEmpty ? _name : '群聊');
              _avatar = info.avatar.isNotEmpty ? info.avatar : _avatar;
              _desc = info.notice.isNotEmpty
                  ? info.notice
                  : (info.memberCount > 0
                      ? '${info.memberCount} 位成员'
                      : '群名片');
              _alreadyJoined =
                  getIt<GroupStore>().getGroup(_conversationId) != null;
              _loading = false;
            });
          } else if (_inviteToken.isNotEmpty) {
            await _loadByInviteToken();
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
          final cached = getIt<CircleStore>().getCircle(widget.msg.id);
          if (cached != null) {
            _name = cached.name.isNotEmpty ? cached.name : '圈子';
            _avatar = cached.avatar;
            _desc = cached.description.isNotEmpty
                ? cached.description
                : '${cached.memberCount} 位成员';
            _alreadyJoined = cached.role > 0;
          }
          final res = await getCircleDetailApi(
            IGetCircleDetailReq(circleId: widget.msg.id),
          );
          if (!mounted) return;
          if (res.code == 0 && res.result != null) {
            final detail = res.result!;
            if (detail.role > 0) {
              await getIt<CircleBusiness>().upsertFromDetail(detail);
            }
            setState(() {
              _resolvedId = detail.circleId;
              _name = detail.name.isNotEmpty ? detail.name : '圈子';
              _avatar = detail.avatar;
              _desc = detail.description.isNotEmpty
                  ? detail.description
                  : '${detail.memberCount} 位成员';
              _alreadyJoined = detail.role > 0 ||
                  getIt<CircleStore>().getCircle(detail.circleId) != null;
              _loading = false;
            });
          } else if (_inviteToken.isNotEmpty) {
            await _loadByInviteToken();
          } else if (!_alreadyJoined) {
            setState(() {
              _error = res.msg.isNotEmpty ? res.msg : '获取圈子信息失败';
              _loading = false;
            });
          } else {
            setState(() => _loading = false);
          }
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
        final id = _entityId;
        final uri = Uri(
          path: AppRoutes.circleJoin,
          queryParameters: {'circleId': id},
        );
        context.push(uri.toString());
      }
      return;
    }

    setState(() => _joining = true);
    try {
      if (widget.msg.cardType == 2) {
        final res = await joinGroupApi(
          IGroupJoinReq(
            groupId: _groupId.isNotEmpty ? _groupId : null,
            inviteCode: _inviteToken.isNotEmpty ? _inviteToken : null,
          ),
        );
        if (!mounted) return;
        if (res.code == 0) {
          final status = res.result?.status ?? 1;
          if (status == 0) {
            BeaverToast.show(context, '申请已提交，等待管理员审批');
            Navigator.of(context).pop();
            return;
          }
          final joinedId = res.result?.groupId?.isNotEmpty == true
              ? res.result!.groupId!
              : _groupId;
          BeaverToast.show(context, '已加入群聊');
          await getIt<GroupStore>().init();
          Navigator.of(context).pop();
          if (!mounted) return;
          final conversationId =
              joinedId.startsWith('group_') ? joinedId : 'group_$joinedId';
          context.push('${AppRoutes.chatDetail}?id=$conversationId&type=group');
        } else {
          BeaverToast.show(
            context,
            res.msg.isNotEmpty ? res.msg : '加入失败',
          );
        }
      } else if (widget.msg.cardType == 3) {
        final res = await joinCircleApi(
          IJoinCircleReq(
            circleId: _entityId.isNotEmpty ? _entityId : null,
            inviteCode: _inviteToken.isNotEmpty ? _inviteToken : null,
          ),
        );
        if (!mounted) return;
        if (res.code == 0) {
          final status = res.result?.status ?? 1;
          if (status == 0) {
            BeaverToast.show(context, '申请已提交，等待圈主审批');
            Navigator.of(context).pop();
          } else {
            final circleId = res.result?.circleId?.isNotEmpty == true
                ? res.result!.circleId!
                : _entityId;
            BeaverToast.show(context, '已加入圈子');
            // 刷新本地圈资料
            final detailRes = await getCircleDetailApi(
              IGetCircleDetailReq(circleId: circleId),
            );
            if (detailRes.code == 0 && detailRes.result != null) {
              await getIt<CircleBusiness>().upsertFromDetail(detailRes.result!);
            }
            Navigator.of(context).pop();
            if (!mounted) return;
            final uri = Uri(
              path: AppRoutes.circleJoin,
              queryParameters: {'circleId': circleId},
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
    final showPrimary = !_loading && _error == null && !expired;

    return BeaverDialog(
      title: _typeLabel,
      showCancel: showPrimary,
      cancelText: '关闭',
      confirmText: showPrimary
          ? (_joining ? '处理中...' : _primaryText)
          : '关闭',
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: showPrimary
          ? _onPrimary
          : () => Navigator.of(context).pop(),
      child: _buildBody(expired: expired),
    );
  }

  Widget _buildBody({required bool expired}) {
    if (_loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.w),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_error != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.w),
        child: Text(
          _error!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFFF44336),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BeaverAvatar(avatar: _avatar, size: 72),
        SizedBox(height: 14.w),
        Text(
          _name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3436),
          ),
        ),
        if (_desc.isNotEmpty) ...[
          SizedBox(height: 8.w),
          Text(
            _desc,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF636E72),
              height: 1.4,
            ),
          ),
        ],
        if (expired) ...[
          SizedBox(height: 10.w),
          Text(
            '名片已过期',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFFF44336),
            ),
          ),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/api/group.dart';
import 'package:beaver/core/datasync/group/group.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/store/chat/chat.dart';
import 'package:beaver/store/group/group.dart';
import 'package:beaver/store/group/group_member.dart';
import 'package:beaver/types/api/group.dart';

class GroupJoinPage extends StatefulWidget {
  final String groupId;
  final String inviteCode;

  const GroupJoinPage({
    super.key,
    this.groupId = '',
    this.inviteCode = '',
  });

  @override
  State<GroupJoinPage> createState() => _GroupJoinPageState();
}

class _GroupJoinPageState extends State<GroupJoinPage> {
  String _title = '';
  String _avatar = '';
  String _desc = '';
  bool _loading = true;
  bool _joining = false;
  String? _error;
  String _groupId = '';
  late final String _inviteCode;

  String get _conversationId =>
      'group_${_normalizeGroupId(_groupId)}';

  @override
  void initState() {
    super.initState();
    _groupId = _normalizeGroupId(widget.groupId.trim());
    _inviteCode = widget.inviteCode.trim();
    _bootstrap();
  }

  String _normalizeGroupId(String id) {
    return id.startsWith('group_') ? id.substring('group_'.length) : id;
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    if (_groupId.isEmpty && _inviteCode.isNotEmpty) {
      final res = await resolveGroupInviteApi(
        IResolveGroupInviteReq(code: _inviteCode),
      );
      if (!mounted) return;
      if (res.code != 0 ||
          res.result == null ||
          (!res.result!.valid && !res.result!.alreadyJoined)) {
        setState(() {
          _loading = false;
          _error = res.msg.isNotEmpty ? res.msg : '邀请无效或已失效';
        });
        return;
      }
      final data = res.result!;
      _groupId = _normalizeGroupId(data.groupId);
      if (data.alreadyJoined ||
          getIt<GroupStore>().getGroup(_conversationId) != null) {
        _goChat();
        return;
      }
      setState(() {
        _loading = false;
        _title = data.title;
        _avatar = data.avatar;
        _desc = data.notice.isNotEmpty
            ? data.notice
            : '${data.memberCount} 位成员';
      });
      return;
    }

    if (_groupId.isEmpty) {
      setState(() {
        _loading = false;
        _error = '群信息不完整';
      });
      return;
    }

    await _loadDetail();
  }

  Future<void> _loadDetail() async {
    if (getIt<GroupStore>().getGroup(_conversationId) != null) {
      _goChat();
      return;
    }

    final res = await getGroupInfoApi(IGroupInfoReq(groupId: _groupId));
    if (!mounted) return;

    if (res.code != 0 || res.result == null) {
      if (_inviteCode.isNotEmpty) {
        final resolve = await resolveGroupInviteApi(
          IResolveGroupInviteReq(code: _inviteCode),
        );
        if (!mounted) return;
        if (resolve.code == 0 &&
            resolve.result != null &&
            (resolve.result!.valid || resolve.result!.alreadyJoined)) {
          final data = resolve.result!;
          _groupId = _normalizeGroupId(data.groupId);
          if (data.alreadyJoined ||
              getIt<GroupStore>().getGroup(_conversationId) != null) {
            _goChat();
            return;
          }
          setState(() {
            _loading = false;
            _title = data.title;
            _avatar = data.avatar;
            _desc = data.notice.isNotEmpty
                ? data.notice
                : '${data.memberCount} 位成员';
          });
          return;
        }
      }
      setState(() {
        _loading = false;
        _error = res.msg.isNotEmpty ? res.msg : '获取群信息失败';
      });
      return;
    }

    final info = res.result!;
    if (getIt<GroupStore>().getGroup(_conversationId) != null) {
      _goChat();
      return;
    }

    setState(() {
      _loading = false;
      _groupId = _normalizeGroupId(
        info.groupId.isNotEmpty ? info.groupId : _groupId,
      );
      _title = info.title;
      _avatar = info.avatar;
      _desc = info.notice.isNotEmpty
          ? info.notice
          : '${info.memberCount} 位成员';
    });
  }

  void _goChat([String? groupId]) {
    if (!mounted) return;
    final id = _normalizeGroupId(groupId ?? _groupId);
    final conversationId = 'group_$id';
    context.replace(
      '${AppRoutes.chatDetail}?id=$conversationId&type=group',
    );
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.root);
  }

  Future<void> _join() async {
    if (_joining || _groupId.isEmpty) return;

    setState(() => _joining = true);
    final res = await joinGroupApi(
      IGroupJoinReq(
        groupId: _groupId.isNotEmpty ? _groupId : null,
        inviteCode: _inviteCode.isNotEmpty ? _inviteCode : null,
      ),
    );
    if (!mounted) return;
    setState(() => _joining = false);

    if (res.code != 0) {
      BeaverToast.show(context, res.msg.isNotEmpty ? res.msg : '加入失败');
      return;
    }

    final status = res.result?.status ?? 1;
    if (status == 0) {
      BeaverToast.show(context, '申请已提交，等待管理员审批');
      return;
    }

    BeaverToast.show(context, '已加入群聊');
    await groupDatasync.checkAndSync();
    await getIt<GroupStore>().init();
    await getIt<ChatStore>().init();

    final joinedId = res.result?.groupId?.isNotEmpty == true
        ? res.result!.groupId!
        : _groupId;
    await getIt<GroupMemberStore>().updateMembersByGroupIds([joinedId]);
    if (!mounted) return;

    _goChat(joinedId);
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '加入群聊',
      showBack: true,
      onBack: _handleBack,
      isScrollable: false,
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF636E72),
                ),
              ),
              SizedBox(height: 16.w),
              TextButton(
                onPressed: _bootstrap,
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

    if (_title.isEmpty && _groupId.isEmpty) {
      return Center(
        child: TextButton(
          onPressed: _bootstrap,
          child: const Text('加载群信息'),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 32.w, 24.w, 24.w),
      child: Column(
        children: [
          BeaverAvatar(avatar: _avatar, size: 88),
          SizedBox(height: 16.w),
          Text(
            _title.isNotEmpty ? _title : '群聊',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            _desc.isNotEmpty ? _desc : '邀请你加入群聊',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF636E72),
              height: 1.4,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 44.w,
            child: ElevatedButton(
              onPressed: _joining ? null : _join,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7D45),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.w),
                ),
              ),
              child: Text(_joining ? '加入中...' : '加入群聊'),
            ),
          ),
        ],
      ),
    );
  }
}

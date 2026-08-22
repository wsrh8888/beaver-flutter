import 'package:beaver/api/circle.dart';
import 'package:beaver/core/business/chat/conversation.dart';
import 'package:beaver/core/business/circle/circle.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/common/select_friend/open_select_friend.dart';
import 'package:beaver/features/common/share/open_share.dart';
import 'package:beaver/features/circle/setting/components/circle_setting_panel.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/dialog/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/store/chat/chat.dart';
import 'package:beaver/store/circle/circle.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/types/api/circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CircleSettingPage extends StatefulWidget {
  final String circleId;

  const CircleSettingPage({super.key, required this.circleId});

  @override
  State<CircleSettingPage> createState() => _CircleSettingPageState();
}

class _CircleSettingPageState extends State<CircleSettingPage> {
  bool _busy = false;
  String? _error;
  IGetCircleDetailRes? _detail;
  List<ICircleMemberItem> _members = const [];
  bool _showQuitDialog = false;

  String get _conversationId => 'circle_${widget.circleId}';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _error = null;
    });

    final detailRes = await getCircleDetailApi(
      IGetCircleDetailReq(circleId: widget.circleId),
    );
    final membersRes = await getCircleMembersApi(
      IGetCircleMembersReq(circleId: widget.circleId, page: 1, limit: 200),
    );

    if (!mounted) return;

    if (detailRes.code != 0 || detailRes.result == null) {
      setState(() {
        _error = detailRes.msg.isNotEmpty ? detailRes.msg : '获取圈子信息失败';
      });
      return;
    }

    final detail = detailRes.result!;
    if (detail.role > 0) {
      await getIt<CircleBusiness>().upsertFromDetail(detail);
    }

    setState(() {
      _detail = detail;
      _members = membersRes.code == 0 && membersRes.result != null
          ? membersRes.result!.list
          : const [];
    });
  }

  Future<void> _share() async {
    final detail = _detail;
    if (detail == null) return;
    var inviteUrl = detail.inviteUrl.trim();
    if (inviteUrl.isEmpty) {
      final res = await getCircleDetailApi(
        IGetCircleDetailReq(circleId: widget.circleId),
      );
      if (!mounted) return;
      inviteUrl = res.result?.inviteUrl.trim() ?? '';
      if (inviteUrl.isEmpty) {
        BeaverToast.show(context, '暂无可用邀请链接');
        return;
      }
      if (res.result != null) {
        setState(() => _detail = res.result);
      }
    }
    await openCircleShare(
      context,
      circleId: widget.circleId,
      circleName: detail.name,
      inviteUrl: inviteUrl,
      avatar: detail.avatar,
    );
  }

  Future<void> _addMembers() async {
    final disabled = _members.map((m) => m.userId).toList();
    final selected = await openSelectFriend(
      context,
      title: '添加圈成员',
      disabledUserIds: disabled,
    );
    if (selected == null || selected.isEmpty || !mounted) return;

    setState(() => _busy = true);
    final res = await inviteCircleMembersApi(
      IInviteCircleMembersReq(
        circleId: widget.circleId,
        userIds: selected.map((e) => e.userId).toList(),
      ),
    );
    if (!mounted) return;
    setState(() => _busy = false);

    if (res.code != 0) {
      BeaverToast.show(context, res.msg.isNotEmpty ? res.msg : '邀请失败');
      return;
    }
    BeaverToast.show(context, '已邀请');
    await _load();
  }

  Future<void> _removeMember(String userId) async {
    setState(() => _busy = true);
    final res = await removeCircleMembersApi(
      IRemoveCircleMembersReq(circleId: widget.circleId, userIds: [userId]),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (res.code != 0) {
      BeaverToast.show(context, res.msg.isNotEmpty ? res.msg : '移除失败');
      return;
    }
    BeaverToast.show(context, '已移除');
    await _load();
  }

  Future<void> _toggleTop() async {
    final chat = getIt<ChatStore>()
        .state
        .conversations
        .where((c) => c.conversationId == _conversationId)
        .firstOrNull;
    final next = !(chat?.isTop ?? false);
    await getIt<ChatStore>().togglePinChat(_conversationId, next);
    if (mounted) setState(() {});
  }

  Future<void> _toggleMute() async {
    final chat = getIt<ChatStore>()
        .state
        .conversations
        .where((c) => c.conversationId == _conversationId)
        .firstOrNull;
    final next = !(chat?.isMuted ?? false);
    await getIt<ConversationBusiness>().toggleMuteChat(_conversationId, next);
    await getIt<ChatStore>().init();
    if (mounted) setState(() {});
  }

  Future<void> _quitOrDelete() async {
    final isOwner = (_detail?.role ?? 0) == 1;
    setState(() => _busy = true);

    final res = isOwner
        ? await deleteCircleApi(IDeleteCircleReq(circleId: widget.circleId))
        : await quitCircleApi(IQuitCircleReq(circleId: widget.circleId));

    if (!mounted) return;
    setState(() {
      _busy = false;
      _showQuitDialog = false;
    });

    if (res.code != 0) {
      BeaverToast.show(
        context,
        res.msg.isNotEmpty ? res.msg : (isOwner ? '解散失败' : '退出失败'),
      );
      return;
    }

    await getIt<CircleBusiness>().removeCircle(widget.circleId);
    getIt<CircleStore>().removeCircle(widget.circleId);
    await getIt<ChatStore>().deleteChat(_conversationId);

    if (!mounted) return;
    BeaverToast.show(context, isOwner ? '已解散圈子' : '已退出圈子');
    context.go(AppRoutes.chatList);
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '圈子详情',
      showBack: true,
      isScrollable: true,
      overlay: _buildOverlay(),
      child: _buildBody(),
    );
  }

  Widget? _buildOverlay() {
    if (!_showQuitDialog && !_busy) return null;
    final isOwner = (_detail?.role ?? 0) == 1;
    return Stack(
      children: [
        if (_showQuitDialog)
          BeaverDialog(
            title: isOwner ? '解散圈子' : '退出圈子',
            contentText: isOwner
                ? '确定解散该圈子吗？此操作不可撤销。'
                : '确定退出该圈子吗？',
            confirmText: '确定',
            confirmColor: const Color(0xFFF44336),
            cancelText: '取消',
            maskClosable: false,
            onCancel: () => setState(() => _showQuitDialog = false),
            onConfirm: _quitOrDelete,
          ),
        if (_busy)
          Container(
            color: Colors.black.withValues(alpha: 0.08),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF636E72)),
            ),
            TextButton(onPressed: _load, child: const Text('重试')),
          ],
        ),
      );
    }
    if (_detail == null) {
      return const SizedBox.shrink();
    }

    final detail = _detail!;
    final chat = context
        .watch<ChatStore>()
        .state
        .conversations
        .where((c) => c.conversationId == _conversationId)
        .firstOrNull;
    final role = detail.role;
    final canManage = role == 1 || role == 2;

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.w, 12.w, 24.w),
      child: CircleSettingPanel(
        circleId: detail.circleId,
        name: detail.name,
        avatar: detail.avatar,
        description: detail.description,
        members: _members,
        isOwner: role == 1,
        canManage: canManage,
        isTop: chat?.isTop ?? false,
        isMuted: chat?.isMuted ?? false,
        contactStore: context.watch<ContactStore>(),
        onAddMember: _addMembers,
        onShare: _share,
        onToggleTop: _toggleTop,
        onToggleMute: _toggleMute,
        onQuitOrDelete: () => setState(() => _showQuitDialog = true),
        onRemoveMember: _removeMember,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/api/circle.dart';
import 'package:beaver/core/business/circle/circle.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/types/api/circle.dart';

class CircleJoinPage extends StatefulWidget {
  final String circleId;
  final String inviteCode;

  const CircleJoinPage({
    super.key,
    this.circleId = '',
    this.inviteCode = '',
  });

  @override
  State<CircleJoinPage> createState() => _CircleJoinPageState();
}

class _CircleJoinPageState extends State<CircleJoinPage> {
  IGetCircleDetailRes? _detail;
  bool _loading = true;
  bool _joining = false;
  String? _error;
  String _circleId = '';
  late final String _inviteCode;

  @override
  void initState() {
    super.initState();
    _circleId = widget.circleId.trim();
    _inviteCode = widget.inviteCode.trim();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    // 仅有邀请码：先 resolve 拿到圈子资料与加入状态
    if (_circleId.isEmpty && _inviteCode.isNotEmpty) {
      final res = await resolveCircleInviteApi(
        IResolveCircleInviteReq(code: _inviteCode),
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
      _circleId = data.circleId;
      if (data.alreadyJoined) {
        _goFeedFromResolve(data);
        return;
      }
      setState(() {
        _loading = false;
        _detail = IGetCircleDetailRes(
          circleId: data.circleId,
          name: data.name,
          description: data.description,
          avatar: data.avatar,
          joinType: data.joinType,
          creatorId: '',
          memberCount: data.memberCount,
          postCount: 0,
          role: 0,
          createdAt: '',
        );
      });
      return;
    }

    if (_circleId.isEmpty) {
      setState(() {
        _loading = false;
        _error = '圈子信息不完整';
      });
      return;
    }

    await _loadDetail();
  }

  Future<void> _loadDetail() async {
    final res = await getCircleDetailApi(
      IGetCircleDetailReq(circleId: _circleId),
    );

    if (!mounted) return;

    if (res.code != 0 || res.result == null) {
      // 详情失败但有邀请码：回落 resolve
      if (_inviteCode.isNotEmpty) {
        final resolve = await resolveCircleInviteApi(
          IResolveCircleInviteReq(code: _inviteCode),
        );
        if (!mounted) return;
        if (resolve.code == 0 &&
            resolve.result != null &&
            (resolve.result!.valid || resolve.result!.alreadyJoined)) {
          final data = resolve.result!;
          _circleId = data.circleId;
          if (data.alreadyJoined) {
            _goFeedFromResolve(data);
            return;
          }
          setState(() {
            _loading = false;
            _detail = IGetCircleDetailRes(
              circleId: data.circleId,
              name: data.name,
              description: data.description,
              avatar: data.avatar,
              joinType: data.joinType,
              creatorId: '',
              memberCount: data.memberCount,
              postCount: 0,
              role: 0,
              createdAt: '',
            );
          });
          return;
        }
      }
      setState(() {
        _loading = false;
        _error = res.msg.isNotEmpty ? res.msg : '获取圈子信息失败';
      });
      return;
    }

    final detail = res.result!;
    if (detail.role > 0) {
      await getIt<CircleBusiness>().upsertFromDetail(detail);
      if (!mounted) return;
      _goFeed(detail);
      return;
    }

    setState(() {
      _loading = false;
      _detail = detail;
    });
  }

  void _goFeedFromResolve(IResolveCircleInviteRes data) {
    if (!mounted) return;
    final uri = Uri(
      path: AppRoutes.circleFeed,
      queryParameters: {
        'circleId': data.circleId,
        'name': data.name,
        'memberCount': '${data.memberCount}',
        'role': '1',
        if (data.avatar.isNotEmpty) 'avatar': data.avatar,
        if (data.description.isNotEmpty) 'desc': data.description,
      },
    );
    context.go(uri.toString());
  }

  void _goFeed(IGetCircleDetailRes detail) {
    if (!mounted) return;
    final uri = Uri(
      path: AppRoutes.circleFeed,
      queryParameters: {
        'circleId': detail.circleId,
        'name': detail.name,
        'memberCount': '${detail.memberCount}',
        'role': '${detail.role}',
        if (detail.avatar.isNotEmpty) 'avatar': detail.avatar,
        if (detail.description.isNotEmpty) 'desc': detail.description,
      },
    );
    context.go(uri.toString());
  }

  Future<void> _join() async {
    if (_joining || _detail == null) return;

    setState(() => _joining = true);
    final res = await joinCircleApi(
      IJoinCircleReq(
        circleId: _circleId.isNotEmpty ? _circleId : null,
        inviteCode: _inviteCode.isNotEmpty ? _inviteCode : null,
      ),
    );
    if (!mounted) return;
    setState(() => _joining = false);

    if (res.code != 0) {
      BeaverToast.show(context, res.msg.isNotEmpty ? res.msg : '加入失败');
      return;
    }

    final status = res.result?.status ?? 0;
    if (status == 0) {
      BeaverToast.show(context, '申请已提交，等待圈主审批');
      return;
    }

    BeaverToast.show(context, '已加入圈子');
    final circleId = res.result?.circleId?.isNotEmpty == true
        ? res.result!.circleId!
        : _circleId;
    final detailRes = await getCircleDetailApi(
      IGetCircleDetailReq(circleId: circleId),
    );
    if (detailRes.code == 0 && detailRes.result != null) {
      await getIt<CircleBusiness>().upsertFromDetail(detailRes.result!);
      if (!mounted) return;
      _goFeed(detailRes.result!);
      return;
    }
    if (!mounted) return;
    if (_detail != null) {
      _goFeed(_detail!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '加入圈子',
      showBack: true,
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

    final detail = _detail;
    if (detail == null) {
      return Center(
        child: TextButton(
          onPressed: _bootstrap,
          child: const Text('加载圈子信息'),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 32.w, 24.w, 24.w),
      child: Column(
        children: [
          BeaverAvatar(avatar: detail.avatar, size: 88),
          SizedBox(height: 16.w),
          Text(
            detail.name.isNotEmpty ? detail.name : '圈子',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            detail.description.isNotEmpty
                ? detail.description
                : '${detail.memberCount} 位成员',
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
              child: Text(_joining ? '加入中...' : '加入圈子'),
            ),
          ),
        ],
      ),
    );
  }
}

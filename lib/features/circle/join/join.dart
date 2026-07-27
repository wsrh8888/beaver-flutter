import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/api/circle.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/types/api/circle.dart';

class CircleJoinPage extends StatefulWidget {
  final String circleId;

  const CircleJoinPage({super.key, required this.circleId});

  @override
  State<CircleJoinPage> createState() => _CircleJoinPageState();
}

class _CircleJoinPageState extends State<CircleJoinPage> {
  IGetCircleDetailRes? _detail;
  bool _loading = true;
  bool _joining = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final res = await getCircleDetailApi(
      IGetCircleDetailReq(circleId: widget.circleId),
    );

    if (!mounted) return;

    if (res.code != 0 || res.result == null) {
      setState(() {
        _loading = false;
        _error = res.msg.isNotEmpty ? res.msg : '获取圈子信息失败';
      });
      return;
    }

    final detail = res.result!;
    if (detail.role > 0) {
      _goFeed(detail);
      return;
    }

    setState(() {
      _loading = false;
      _detail = detail;
    });
  }

  void _goFeed(IGetCircleDetailRes detail) {
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
    context.replace(uri.toString());
  }

  Future<void> _join() async {
    if (_joining || _detail == null) return;

    setState(() => _joining = true);
    final res = await joinCircleApi(
      IJoinCircleReq(circleId: widget.circleId),
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
    await _loadDetail();
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '加入圈子',
      isScrollable: false,
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF636E72)),
            ),
            SizedBox(height: 12.w),
            TextButton(
              onPressed: _loadDetail,
              child: Text(
                '重试',
                style: TextStyle(fontSize: 14.sp, color: const Color(0xFFFF7D45)),
              ),
            ),
          ],
        ),
      );
    }

    final detail = _detail!;
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          SizedBox(height: 24.w),
          BeaverAvatar(avatar: detail.avatar, size: 72),
          SizedBox(height: 16.w),
          Text(
            detail.name,
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
                : '${detail.memberCount} 位成员 · ${detail.postCount} 帖子',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF636E72),
            ),
          ),
          if (detail.description.isNotEmpty) ...[
            SizedBox(height: 8.w),
            Text(
              '${detail.memberCount} 位成员 · ${detail.postCount} 帖子',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFFB2BEC3),
              ),
            ),
          ],
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _joining ? null : _join,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7D45),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFE0E0E0),
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 14.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.w),
                ),
              ),
              child: _joining
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      detail.joinType == 1 ? '申请加入' : '加入圈子',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 12.w),
          Text(
            detail.joinType == 1 ? '该圈子需圈主审批后才能加入' : '加入后即可查看圈子动态',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFFB2BEC3),
            ),
          ),
        ],
      ),
    );
  }
}

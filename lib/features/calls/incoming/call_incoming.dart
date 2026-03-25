import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/calls/incoming/bloc/bloc.dart';
import 'package:beaver/features/calls/incoming/bloc/event.dart';
import 'package:beaver/features/calls/incoming/bloc/state.dart';
import 'package:beaver/features/calls/incoming/data/repositories/repository.dart';
import 'package:beaver/features/calls/call/call_page.dart';
import 'package:beaver/types/call.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/shared/ui/layout/layout.dart';

class CallInvitationPage extends StatefulWidget {
  final String conversationId;

  const CallInvitationPage({super.key, required this.conversationId});

  @override
  State<CallInvitationPage> createState() => _CallInvitationPageState();
}

class _CallInvitationPageState extends State<CallInvitationPage> {
  late CallIncomingBloc _callIncomingBloc;
  int _countdown = 30;
  bool _isCountdownRunning = true;

  @override
  void initState() {
    super.initState();
    _callIncomingBloc = CallIncomingBloc(CallIncomingRepository())
      ..add(LoadCallInfoEvent(widget.conversationId));
    _startCountdown();
  }

  @override
  void dispose() {
    _callIncomingBloc.close();
    super.dispose();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isCountdownRunning && _countdown > 0) {
        if (mounted) {
          setState(() {
            _countdown--;
          });
        }
        _startCountdown();
      } else if (_countdown == 0) {
        _handleReject();
      }
    });
  }

  void _handleAccept() {
    _isCountdownRunning = false;
    _callIncomingBloc.add(const AcceptCallEvent());
  }

  void _handleReject() {
    _isCountdownRunning = false;
    _callIncomingBloc.add(const RejectCallEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _callIncomingBloc,
      child: BlocConsumer<CallIncomingBloc, CallIncomingState>(
        listener: (context, state) {
          if (state.status == CallStatus.connected) {
            // 跳转到通话中页面
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CallPage(
                  conversationId: widget.conversationId,
                  roomToken: state.callInfo!.roomToken,
                  liveKitUrl: state.callInfo!.liveKitUrl,
                ),
              ),
            );
          } else if (state.status == CallStatus.ended) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final isIncoming = state.callInfo?.isIncoming ?? true;
          final callInfo = state.callInfo;

          return BeaverLayout(
            showHeader: false,
            showBackground: false,
            isScrollable: false,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFF1C1C1E),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   // 通话提示
                  Text(
                    isIncoming ? '邀请你进行视频通话' : '正在申请通话...',
                    style: TextStyle(
                      fontSize: 16.w, 
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 48.w),

                  // 头像
                  BeaverCachedImage(
                    fileKey: callInfo?.callerAvatar,
                    type: CacheType.avatar,
                    width: 120.w,
                    height: 120.w,
                    borderRadius: 60.w,
                  ),
                  SizedBox(height: 24.w),

                  // 姓名
                  Text(
                    callInfo?.callerName ?? '未知用户',
                    style: TextStyle(
                      fontSize: 32.w,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.w),

                  // 通话状态
                  Text(
                    state.status == CallStatus.ringing
                        ? (isIncoming ? '等待接通...' : '正在呼叫对方...')
                        : state.status == CallStatus.loading
                        ? '处理中...'
                        : '',
                    style: TextStyle(fontSize: 16.w, color: Colors.white54),
                  ),
                  SizedBox(height: 8.w),

                  // 倒计时
                  if (state.status == CallStatus.ringing)
                    Text(
                      '${_countdown}s',
                      style: TextStyle(fontSize: 14.w, color: Colors.white38),
                    ),
                  
                  const Spacer(),

                  // 控制按钮
                  Padding(
                    padding: EdgeInsets.only(bottom: 80.w),
                    child: isIncoming 
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              onTap: _handleReject,
                              icon: Icons.call_end,
                              label: '拒绝',
                              color: Colors.redAccent,
                            ),
                            _buildActionButton(
                              onTap: _handleAccept,
                              icon: callInfo?.callType == CallType.video 
                                ? Icons.videocam : Icons.call,
                              label: '接听',
                              color: Colors.greenAccent[400]!,
                            ),
                          ],
                        )
                      : _buildActionButton(
                          onTap: _handleReject,
                          icon: Icons.call_end,
                          label: '取消',
                          color: Colors.redAccent,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, size: 32.w, color: Colors.white),
          ),
        ),
        SizedBox(height: 12.w),
        Text(
          label,
          style: TextStyle(fontSize: 14.w, color: Colors.white),
        ),
      ],
    );
  }
}

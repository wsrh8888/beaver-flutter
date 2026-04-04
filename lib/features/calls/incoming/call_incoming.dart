import 'dart:ui';
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
  final String roomId;

  const CallInvitationPage({
    super.key, 
    required this.conversationId, 
    required this.roomId,
  });

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
      ..add(LoadCallInfoEvent(widget.conversationId, widget.roomId));
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CallPage(
                  conversationId: widget.conversationId,
                  roomToken: state.callInfo!.roomToken,
                  liveKitUrl: state.callInfo!.liveKitUrl,
                  callType: state.callInfo?.callType ?? CallType.audio,
                ),
              ),
            );
          } else if (state.status == CallStatus.ended) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final callInfo = state.callInfo;
          final isIncoming = callInfo?.isIncoming ?? true;

          return BeaverLayout(
            showHeader: false,
            showBackground: false,
            isScrollable: false,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: Stack(
                children: [
                  // 模糊背景
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        image: (callInfo?.callerAvatar != null)
                            ? DecorationImage(
                                image: NetworkImage(callInfo!.callerAvatar), // TODO: 使用缓存层
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: const Color(0xFF1C1C1E),
                      ),
                      child: BackdropFilter(
                        filter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ),
                  
                  SafeArea(
                    child: Column(
                      children: [
                        SizedBox(height: 60.w),
                        // 顶部提示
                        Text(
                          isIncoming 
                            ? '邀请你进行${callInfo?.callType == CallType.video ? "视频" : "语音"}通话' 
                            : '正在发送通话请求...',
                          style: TextStyle(
                            fontSize: 18.sp, 
                            color: Colors.white, 
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // 用户信息
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white12, width: 2.w),
                              ),
                              child: BeaverCachedImage(
                                fileKey: callInfo?.callerAvatar,
                                type: CacheType.avatar,
                                width: 120.w,
                                height: 120.w,
                                borderRadius: 60.w,
                              ),
                            ),
                            SizedBox(height: 24.w),
                            Text(
                              callInfo?.callerName ?? '未知用户',
                              style: TextStyle(
                                fontSize: 32.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        
                        const Spacer(flex: 2),
                        
                        // 通话状态提示
                        if (state.status == CallStatus.ringing)
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.w),
                            child: Text(
                              isIncoming ? '等待接通...' : '等待对方接听...',
                              style: TextStyle(fontSize: 14.sp, color: Colors.white60),
                            ),
                          ),
                          
                        // 控制按钮
                        Padding(
                          padding: EdgeInsets.only(bottom: 60.w, left: 30.w, right: 30.w),
                          child: isIncoming 
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    color: Colors.greenAccent[700]!,
                                  ),
                                ],
                              )
                            : Center(
                                child: _buildActionButton(
                                  onTap: _handleReject,
                                  icon: Icons.call_end,
                                  label: '取消',
                                  color: Colors.redAccent,
                                ),
                              ),
                        ),
                      ],
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

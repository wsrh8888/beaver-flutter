import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/calls/incoming/bloc/bloc.dart';
import 'package:beaver/features/calls/incoming/bloc/event.dart';
import 'package:beaver/features/calls/incoming/bloc/state.dart';
import 'package:beaver/features/calls/incoming/data/repositories/repository.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/toast.dart';

class CallIncomingPage extends StatefulWidget {
  final String conversationId;

  const CallIncomingPage({super.key, required this.conversationId});

  @override
  State<CallIncomingPage> createState() => _CallIncomingPageState();
}

class _CallIncomingPageState extends State<CallIncomingPage> {
  late CallIncomingBloc _callIncomingBloc;
  int _countdown = 30;
  bool _isCountdownRunning = true;

  @override
  void initState() {
    super.initState();
    _callIncomingBloc = CallIncomingBloc(CallIncomingRepository())..add(LoadCallInfoEvent(widget.conversationId));
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
        setState(() {
          _countdown--;
        });
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
          if (state.status == CallStatus.error) {
            BeaverToast.show(state.errorMessage ?? '发生错误');
          } else if (state.status == CallStatus.connected) {
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
          return BeaverLayout(
            showHeader: false,
            showBackground: false,
            isScrollable: false,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 通话类型
                  if (state.callInfo?.callType == CallType.video)
                    const Icon(
                      Icons.video_call,
                      size: 48,
                      color: Colors.white,
                    )
                  else
                    const Icon(
                      Icons.call,
                      size: 48,
                      color: Colors.white,
                    ),
                  SizedBox(height: 32.w),
                  
                  // 来电者头像
                  BeaverAvatar(
                    url: state.callInfo?.callerAvatar,
                    size: 120.w,
                    borderWidth: 4,
                    borderColor: Colors.white,
                  ),
                  SizedBox(height: 24.w),
                  
                  // 来电者姓名
                  Text(
                    state.callInfo?.callerName ?? '未知来电',
                    style: TextStyle(
                      fontSize: 28.w,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.w),
                  
                  // 通话状态
                  Text(
                    state.status == CallStatus.ringing
                        ? '正在呼叫...'
                        : state.status == CallStatus.loading
                            ? '处理中...'
                            : '',
                    style: TextStyle(
                      fontSize: 16.w,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 8.w),
                  
                  // 倒计时
                  if (state.status == CallStatus.ringing)
                    Text(
                      '${_countdown}s',
                      style: TextStyle(
                        fontSize: 14.w,
                        color: Colors.white54,
                      ),
                    ),
                  SizedBox(height: 120.w),
                  
                  // 控制按钮
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 拒绝按钮
                      GestureDetector(
                        onTap: _handleReject,
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          margin: EdgeInsets.only(right: 60.w),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(40.w),
                          ),
                          child: Icon(
                            Icons.call_end,
                            size: 32.w,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      // 接听按钮
                      GestureDetector(
                        onTap: _handleAccept,
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(40.w),
                          ),
                          child: Icon(
                            state.callInfo?.callType == CallType.video
                                ? Icons.video_call
                                : Icons.call,
                            size: 32.w,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// 通话中页面（临时引用，实际应该在call_page.dart中实现）
class CallPage extends StatelessWidget {
  final String conversationId;
  final String roomToken;
  final String liveKitUrl;

  const CallPage({super.key, required this.conversationId, required this.roomToken, required this.liveKitUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('通话中页面'),
      ),
    );
  }
}

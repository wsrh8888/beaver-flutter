import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/calls/calls_page/bloc/bloc.dart';
import 'package:beaver/features/calls/calls_page/bloc/event.dart';
import 'package:beaver/features/calls/calls_page/bloc/state.dart';
import 'package:beaver/features/calls/calls_page/data/repositories/repository.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';

class CallsPage extends StatefulWidget {
  final String conversationId;

  const CallsPage({super.key, required this.conversationId});

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  late CallBloc _callBloc;
  bool _isLocalVideoFullScreen = false;

  @override
  void initState() {
    super.initState();
    _callBloc = CallBloc(CallRepository())..add(LoadCallInfoEvent(widget.conversationId));
  }

  @override
  void dispose() {
    _callBloc.close();
    super.dispose();
  }

  void _startCall() {
    _callBloc.add(StartCallEvent(widget.conversationId));
  }

  void _endCall() {
    _callBloc.add(EndCallEvent());
    Navigator.of(context).pop();
  }

  void _changeStyle(String type) {
    setState(() {
      _isLocalVideoFullScreen = !_isLocalVideoFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: _callBloc,
        child: BlocConsumer<CallBloc, CallState>(
          listener: (context, state) {
            if (state.status == CallStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? '发生错误')),
              );
            }
          },
          builder: (context, state) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: Stack(
                children: [
                  // 远程视频
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Visibility(
                      visible: !_isLocalVideoFullScreen,
                      child: Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: Text(
                            '远程视频',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 本地视频
                  Positioned(
                    top: 40.w,
                    right: 20.w,
                    width: 120.w,
                    height: 180.w,
                    child: Visibility(
                      visible: !_isLocalVideoFullScreen,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.w),
                          border: Border.all(color: Colors.white, width: 2.w),
                        ),
                        child: Container(
                          color: Colors.grey[700],
                          child: const Center(
                            child: Text(
                              '本地视频',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 本地视频全屏
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Visibility(
                      visible: _isLocalVideoFullScreen,
                      child: Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: Text(
                            '本地视频',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 通话信息
                  if (state.callInfo != null)
                    Positioned(
                      top: 100.w,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          BeaverAvatar(
                            url: state.callInfo!.callerAvatar,
                            size: 120.w,
                          ),
                          SizedBox(height: 20.w),
                          Text(
                            state.callInfo!.callerName,
                            style: TextStyle(
                              fontSize: 24.w,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12.w),
                          Text(
                            state.status == CallStatus.connected
                                ? '通话中'
                                : '正在呼叫...',
                            style: TextStyle(
                              fontSize: 16.w,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // 控制按钮
                  Positioned(
                    bottom: 60.w,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 开始按钮
                        GestureDetector(
                          onTap: _startCall,
                          child: Container(
                            width: 60.w,
                            height: 60.w,
                            margin: EdgeInsets.only(right: 40.w),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(30.w),
                            ),
                            child: Icon(
                              Icons.call,
                              size: 30.w,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // 结束按钮
                        GestureDetector(
                          onTap: _endCall,
                          child: Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30.w),
                            ),
                            child: Icon(
                              Icons.call_end,
                              size: 30.w,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/calls/call/bloc/bloc.dart';
import 'package:beaver/features/calls/call/bloc/event.dart';
import 'package:beaver/features/calls/call/bloc/state.dart';
import 'package:beaver/features/calls/data/models/call.dart';
import 'package:beaver/features/calls/core/call_manager.dart';
import 'package:beaver/features/calls/core/pip_service.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class CallPage extends StatefulWidget {
  final String conversationId;
  final String roomToken;
  final String liveKitUrl;

  const CallPage({super.key, required this.conversationId, required this.roomToken, required this.liveKitUrl});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late CallPageBloc _callPageBloc;
  late PiPService _pipService;
  bool _isLocalVideoFullScreen = false;
  bool _isInPiPMode = false;
  int _callDuration = 0;
  bool _isDurationRunning = false;

  @override
  void initState() {
    super.initState();
    _callPageBloc = CallPageBloc();
    _pipService = PiPService();
    _pipService.initialize();
    _pipService.setPiPStateListener((isInPiP) {
      setState(() {
        _isInPiPMode = isInPiP;
      });
    });
    _callPageBloc.add(StartCallEvent(widget.conversationId, widget.roomToken, widget.liveKitUrl));
    _startCallDuration();
  }

  @override
  void dispose() {
    _callPageBloc.close();
    _isDurationRunning = false;
    if (_isInPiPMode) {
      _pipService.exitPiPMode();
    }
    super.dispose();
  }

  void _startCallDuration() {
    _isDurationRunning = true;
    Future.delayed(const Duration(seconds: 1), () {
      if (_isDurationRunning) {
        setState(() {
          _callDuration++;
        });
        _startCallDuration();
      }
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _handleEndCall() {
    _isDurationRunning = false;
    _callPageBloc.add(const EndCallEvent());
  }

  void _handleToggleMute() {
    _callPageBloc.add(const ToggleMuteEvent());
  }

  void _handleToggleCamera() {
    _callPageBloc.add(const ToggleCameraEvent());
  }

  void _handleToggleSpeaker() {
    _callPageBloc.add(const ToggleSpeakerEvent());
  }

  void _handleSwitchVideoView() {
    setState(() {
      _isLocalVideoFullScreen = !_isLocalVideoFullScreen;
    });
  }

  void _handleTogglePiP() async {
    if (_isInPiPMode) {
      await _pipService.exitPiPMode();
    } else {
      final isSupported = await _pipService.isPiPSupported();
      if (isSupported) {
        await _pipService.enterPiPMode();
      } else {
        BeaverToast.show(context, '当前设备不支持画中画功能');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _callPageBloc,
      child: BlocConsumer<CallPageBloc, CallPageState>(
        listener: (context, state) {
          if (state.status == CallStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? '发生错误');
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
              child: Stack(
                children: [
                  // 远程视频
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Visibility(
                      visible: !_isLocalVideoFullScreen && state.participants.length > 1,
                      child: Container(
                        color: Colors.grey[900],
                        child: state.participants.length > 1
                            ? GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: state.participants.length <= 4 ? 2 : 3,
                                  childAspectRatio: 9/16,
                                ),
                                itemCount: state.participants.length - 1, // 排除本地参与者
                                itemBuilder: (context, index) {
                                  final participant = state.participants[index + 1];
                                  return _buildParticipantView(participant);
                                },
                              )
                            : const Center(
                                child: Text(
                                  '等待对方加入...',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      ),
                    ),
                  ),
                  
                  // 本地视频小窗口
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
                        child: _buildLocalVideoView(state),
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
                      child: _buildLocalVideoView(state),
                    ),
                  ),
                  
                  // 通话信息
                  Positioned(
                    top: 100.w,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          '通话中',
                          style: TextStyle(
                            fontSize: 18.w,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8.w),
                        Text(
                          _formatDuration(_callDuration),
                          style: TextStyle(
                            fontSize: 14.w,
                            color: Colors.white70,
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
                    child: Column(
                      children: [
                        // 顶部控制按钮
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 扬声器
                            GestureDetector(
                              onTap: _handleToggleSpeaker,
                              child: Container(
                                width: 56.w,
                                height: 56.w,
                                margin: EdgeInsets.only(right: 32.w),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(28.w),
                                ),
                                child: Icon(
                                  state.isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                                  size: 24.w,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            
                            // 切换视图
                            GestureDetector(
                              onTap: _handleSwitchVideoView,
                              child: Container(
                                width: 56.w,
                                height: 56.w,
                                margin: EdgeInsets.only(right: 32.w),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(28.w),
                                ),
                                child: Icon(
                                  Icons.switch_camera,
                                  size: 24.w,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            
                            // 画中画
                            GestureDetector(
                              onTap: _handleTogglePiP,
                              child: Container(
                                width: 56.w,
                                height: 56.w,
                                decoration: BoxDecoration(
                                  color: _isInPiPMode ? Colors.blue : Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(28.w),
                                ),
                                child: Icon(
                                  _isInPiPMode ? Icons.fullscreen : Icons.picture_in_picture,
                                  size: 24.w,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.w),
                        
                        // 底部控制按钮
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 静音
                            GestureDetector(
                              onTap: _handleToggleMute,
                              child: Container(
                                width: 64.w,
                                height: 64.w,
                                margin: EdgeInsets.only(right: 40.w),
                                decoration: BoxDecoration(
                                  color: state.isMuted ? Colors.blue : Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(32.w),
                                ),
                                child: Icon(
                                  state.isMuted ? Icons.mic_off : Icons.mic,
                                  size: 28.w,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            
                            // 结束按钮
                            GestureDetector(
                              onTap: _handleEndCall,
                              child: Container(
                                width: 64.w,
                                height: 64.w,
                                margin: EdgeInsets.only(right: 40.w),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(32.w),
                                ),
                                child: Icon(
                                  Icons.call_end,
                                  size: 28.w,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            
                            // 摄像头
                            GestureDetector(
                              onTap: _handleToggleCamera,
                              child: Container(
                                width: 64.w,
                                height: 64.w,
                                decoration: BoxDecoration(
                                  color: state.isCameraOff ? Colors.blue : Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(32.w),
                                ),
                                child: Icon(
                                  state.isCameraOff ? Icons.videocam_off : Icons.videocam,
                                  size: 28.w,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildParticipantView(CallParticipant participant) {
    return Container(
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.w),
      ),
      child: Stack(
        children: [
          // 视频流（占位）
          Container(
            color: Colors.grey[800],
            child: Center(
              child: participant.isCameraOff
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BeaverCachedImage(
                          fileKey: participant.avatarUrl,
                          type: CacheType.avatar,
                          width: 60.w,
                          height: 60.w,
                          borderRadius: 30.w,
                        ),
                        SizedBox(height: 8.w),
                        Text(
                          participant.name,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        '视频流',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ),
          
          // 静音状态
          if (participant.isMuted)
            Positioned(
              top: 8.w,
              right: 8.w,
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: Icon(
                  Icons.mic_off,
                  size: 12.w,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocalVideoView(CallPageState state) {
    final localParticipant = state.participants.firstWhere(
      (p) => p.userId == CallManager().localParticipant?.userId,
      orElse: () => CallParticipant(
        userId: 'local',
        name: '我',
        isMuted: state.isMuted,
        isCameraOff: state.isCameraOff,
        status: CallParticipantStatus.joined,
      ),
    );

    return Container(
      color: Colors.grey[800],
      child: Center(
        child: localParticipant.isCameraOff
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BeaverCachedImage(
                    fileKey: localParticipant.avatarUrl,
                    type: CacheType.avatar,
                    width: 80.w,
                    height: 80.w,
                    borderRadius: 40.w,
                  ),
                  SizedBox(height: 12.w),
                  Text(
                    localParticipant.name,
                    style: TextStyle(color: Colors.white, fontSize: 16.w),
                  ),
                ],
              )
            : const Center(
                child: Text(
                  '本地视频',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:beaver/features/calls/call/bloc/bloc.dart';
import 'package:beaver/features/calls/call/bloc/event.dart';
import 'package:beaver/features/calls/call/bloc/state.dart';
import 'package:beaver/types/call.dart';
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
      if (mounted) {
        setState(() {
          _isInPiPMode = isInPiP;
        });
      }
    });
    _callPageBloc.add(InitializeCallEvent(widget.conversationId, widget.roomToken, widget.liveKitUrl));
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
    _tick();
  }

  void _tick() {
    if (!_isDurationRunning || !mounted) return;
    Future.delayed(const Duration(seconds: 1), () {
      if (_isDurationRunning && mounted) {
        setState(() {
          _callDuration++;
        });
        _tick();
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
                   // 远程视频/等待视图
                  _buildMainContentView(state),
                  
                  // 本地视频预览
                  _buildLocalPreview(state),
                  
                  // 通话时长信息
                  _buildCallDurationInfo(),
                  
                  // 底部控制按钮
                  _buildControls(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContentView(CallPageState state) {
    return Positioned.fill(
      child: Visibility(
        visible: !_isLocalVideoFullScreen && state.participants.length > 1,
        child: Container(
          color: Colors.grey[900],
          child: state.participants.length > 1
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: state.participants.length <= 2 ? 1 : 2,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: state.participants.length - 1,
                  itemBuilder: (context, index) {
                    final participant = state.participants[index + 1];
                    return _buildParticipantView(participant);
                  },
                )
              : _buildWaitingView(),
        ),
      ),
    );
  }

  Widget _buildWaitingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: Colors.white30, size: 50.w),
          ),
          SizedBox(height: 24.w),
          Text(
            '正在等待对方加入...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.w,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalPreview(CallPageState state) {
     if (_isLocalVideoFullScreen) {
        return Positioned.fill(child: _buildLocalVideoView(state));
     }

     return Positioned(
      top: 40.w,
      right: 20.w,
      width: 120.w,
      height: 180.w,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.w),
          border: Border.all(color: Colors.white24, width: 1.w),
          boxShadow: [
            BoxShadow(color: Colors.black54, blurRadius: 10, spreadRadius: 0),
          ]
        ),
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          onTap: _handleSwitchVideoView,
          child: _buildLocalVideoView(state),
        ),
      ),
    );
  }

  Widget _buildCallDurationInfo() {
    return Positioned(
      top: 60.w,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            '通话进行中',
            style: TextStyle(fontSize: 14.w, color: Colors.white60),
          ),
          SizedBox(height: 4.w),
          Text(
            _formatDuration(_callDuration),
            style: TextStyle(
              fontSize: 20.w, 
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(CallPageState state) {
    return Positioned(
      bottom: 50.w,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSecondaryButton(
                onTap: _handleToggleSpeaker,
                icon: state.isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                label: '扬声器',
                isActive: state.isSpeakerOn,
              ),
              SizedBox(width: 24.w),
              _buildSecondaryButton(
                onTap: _handleTogglePiP,
                icon: _isInPiPMode ? Icons.fullscreen : Icons.picture_in_picture,
                label: '画中画',
                isActive: _isInPiPMode,
              ),
            ],
          ),
          SizedBox(height: 40.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMainButton(
                onTap: _handleToggleMute,
                icon: state.isMuted ? Icons.mic_off : Icons.mic,
                label: '静音',
                color: state.isMuted ? Colors.white24 : Colors.grey[800]!,
              ),
              _buildMainButton(
                onTap: _handleEndCall,
                icon: Icons.call_end,
                label: '结束',
                color: Colors.redAccent,
              ),
              _buildMainButton(
                onTap: _handleToggleCamera,
                icon: state.isCameraOff ? Icons.videocam_off : Icons.videocam,
                label: '摄像头',
                color: state.isCameraOff ? Colors.white24 : Colors.grey[800]!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton({required VoidCallback onTap, required IconData icon, required String label, bool isActive = false}) {
     return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white10,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: isActive ? Colors.black : Colors.white, size: 22.w),
        ),
     );
  }

  Widget _buildMainButton({required VoidCallback onTap, required IconData icon, required String label, required Color color}) {
     return Column(
       children: [
         GestureDetector(
           onTap: onTap,
           child: Container(
             width: 70.w,
             height: 70.w,
             decoration: BoxDecoration(
               color: color,
               shape: BoxShape.circle,
             ),
             child: Icon(icon, color: Colors.white, size: 30.w),
           ),
         ),
         SizedBox(height: 8.w),
         Text(label, style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
       ],
     );
  }

  Widget _buildParticipantView(CallParticipant participant) {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.w),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (participant.videoTrack != null && !participant.isCameraOff)
            VideoTrackRenderer(
              participant.videoTrack!,
              fit: VideoViewFit.cover,
            )
          else
            Center(
              child: BeaverCachedImage(
                fileKey: participant.avatarUrl,
                type: CacheType.avatar,
                width: 80.w,
                height: 80.w,
                borderRadius: 40.w,
              ),
            ),
          Positioned(
            bottom: 8.w,
            left: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Text(
                participant.name,
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalVideoView(CallPageState state) {
    final localParticipant = _callPageBloc.localParticipant;
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          if (localParticipant?.videoTrack != null && !state.isCameraOff)
            VideoTrackRenderer(
              localParticipant!.videoTrack!,
              fit: VideoViewFit.cover,
            )
          else
            Center(
              child: BeaverCachedImage(
                fileKey: localParticipant?.avatarUrl,
                type: CacheType.avatar,
                width: 60.w,
                height: 60.w,
                borderRadius: 30.w,
              ),
            ),
        ],
      ),
    );
  }
}

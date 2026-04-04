import 'dart:ui';
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
  final CallType callType;

  const CallPage({
    super.key, 
    required this.conversationId, 
    required this.roomToken, 
    required this.liveKitUrl,
    required this.callType,
  });

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
    _callPageBloc.add(InitializeCallEvent(widget.conversationId, widget.roomToken, widget.liveKitUrl, widget.callType));
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
              child: state.callType == CallType.video
                  ? _buildVideoCallView(state)
                  : _buildAudioCallView(state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAudioCallView(CallPageState state) {
    final participants = state.participants;
    final remoteParticipants = participants.where((p) => p.userId != (_callPageBloc.localParticipant?.userId ?? 'me')).toList();
    
    // 如果是群聊且有多个人，使用网格布局
    if (participants.length > 2) {
      return _buildMultiAudioView(state);
    }

    final otherParticipant = remoteParticipants.isNotEmpty ? remoteParticipants[0] : const CallParticipant(userId: '', name: '未知');

    return Stack(
      children: [
        // 模糊背景
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              image: otherParticipant.avatarUrl != null
                  ? DecorationImage(
                      image: NetworkImage(otherParticipant.avatarUrl!), 
                      fit: BoxFit.cover,
                    )
                  : null,
              color: const Color(0xFF1C1C1E),
            ),
            child: BackdropFilter(
              filter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        
        SafeArea(
          child: Column(
            children: [
              SizedBox(height: 60.w),
              // 昵称
              Text(
                otherParticipant.name,
                style: TextStyle(fontSize: 28.sp, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.w),
              _buildCallDurationInfo(),
              
              const Spacer(),
              
              // 中间大头像
              Container(
                width: 140.w,
                height: 140.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white12, width: 2.w),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 20, spreadRadius: 5),
                  ]
                ),
                child: BeaverCachedImage(
                  fileKey: otherParticipant.avatarUrl,
                  width: 140.w,
                  height: 140.w,
                  borderRadius: 70.w,
                  type: CacheType.avatar,
                ),
              ),
              
              const Spacer(flex: 2),
              
              _buildAudioControls(state),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMultiAudioView(CallPageState state) {
    final participants = state.participants;
    
    return Stack(
      children: [
        // 背景色
        Positioned.fill(child: Container(color: const Color(0xFF1C1C1E))),
        
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.w),
                child: _buildCallDurationInfo(),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(20.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 30.w,
                    crossAxisSpacing: 20.w,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    final p = participants[index];
                    return Column(
                      children: [
                        BeaverCachedImage(
                          fileKey: p.avatarUrl,
                          width: 80.w,
                          height: 80.w,
                          borderRadius: 12.w,
                          type: CacheType.avatar,
                        ),
                        SizedBox(height: 8.w),
                        Text(
                          p.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 12.sp),
                        ),
                      ],
                    );
                  },
                ),
              ),
              _buildAudioControls(state),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAudioControls(CallPageState state) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCallButton(
            onTap: _handleToggleMute,
            icon: state.isMuted ? Icons.mic_off : Icons.mic,
            label: '静音',
            isActive: state.isMuted,
          ),
          _buildCallButton(
            onTap: _handleEndCall,
            icon: Icons.call_end,
            label: '',
            color: Colors.redAccent,
            size: 72.w,
          ),
          _buildCallButton(
            onTap: _handleToggleSpeaker,
            icon: state.isSpeakerOn ? Icons.volume_up : Icons.volume_off,
            label: '扬声器',
            isActive: state.isSpeakerOn,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCallView(CallPageState state) {
    final participants = state.participants;
    final remoteParticipants = participants.where((p) => p.userId != (_callPageBloc.localParticipant?.userId ?? 'me')).toList();

    // 如果是群聊且有多个人，使用网格布局
    if (participants.length > 2) {
      return _buildMultiVideoView(state);
    }

    final remoteParticipant = remoteParticipants.isNotEmpty ? remoteParticipants[0] : null;

    return Stack(
      children: [
        // 远程视频
        Positioned.fill(
          child: remoteParticipant?.videoTrack != null && !remoteParticipant!.isCameraOff
              ? VideoTrackRenderer(remoteParticipant.videoTrack!, fit: VideoViewFit.cover)
              : Container(
                  color: const Color(0xFF1C1C1E),
                  child: Center(
                    child: BeaverCachedImage(
                      fileKey: remoteParticipant?.avatarUrl, 
                      width: 100.w, 
                      height: 100.w,
                      borderRadius: 50.w,
                      type: CacheType.avatar,
                    ),
                  ),
                ),
        ),
        
        // 本地视频 (小窗口)
        if (state.isLocalVideoSmall)
          Positioned(
            top: 50.w,
            right: 20.w,
            child: GestureDetector(
              onTap: _handleSwitchVideoView,
              child: Container(
                width: 110.w,
                height: 160.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.w),
                  border: Border.all(color: Colors.white24, width: 1.w),
                  boxShadow: [
                    BoxShadow(color: Colors.black54, blurRadius: 10),
                  ]
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildLocalVideoView(state),
              ),
            ),
          ),
          
        _buildControlsOverlay(state),
      ],
    );
  }

  Widget _buildMultiVideoView(CallPageState state) {
    final participants = state.participants;
    int crossAxisCount = 2;
    if (participants.length > 4) crossAxisCount = 3;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 80.w, bottom: 200.w),
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 2.w,
              crossAxisSpacing: 2.w,
              childAspectRatio: 0.75,
            ),
            itemCount: participants.length,
            itemBuilder: (context, index) {
              return _buildParticipantGridItem(participants[index], state);
            },
          ),
        ),
        _buildControlsOverlay(state),
      ],
    );
  }

  Widget _buildParticipantGridItem(CallParticipant p, CallPageState state) {
    final isLocal = p.userId == (_callPageBloc.localParticipant?.userId ?? 'me');
    final isCameraOff = isLocal ? state.isCameraOff : p.isCameraOff;
    final videoTrack = p.videoTrack;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(4.w),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (videoTrack != null && !isCameraOff)
             VideoTrackRenderer(videoTrack, fit: VideoViewFit.cover)
          else
            Center(
              child: BeaverCachedImage(
                fileKey: p.avatarUrl,
                width: 60.w,
                height: 60.w,
                borderRadius: 30.w,
                type: CacheType.avatar,
              ),
            ),
          Positioned(
            bottom: 8.w,
            left: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
              color: Colors.black54,
              child: Text(
                p.name + (isLocal ? ' (我)' : ''),
                style: TextStyle(color: Colors.white, fontSize: 10.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsOverlay(CallPageState state) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32.w),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                _buildCallDurationInfo(),
                _buildCallButton(
                  onTap: _handleTogglePiP,
                  icon: Icons.picture_in_picture,
                  label: '',
                  size: 40.w,
                  color: Colors.white10,
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 40.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCallButton(
                  onTap: _handleToggleSpeaker,
                  icon: state.isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                  label: '扬声器',
                  color: Colors.white10,
                  size: 56.w,
                ),
                _buildCallButton(
                  onTap: _handleToggleMute,
                  icon: state.isMuted ? Icons.mic_off : Icons.mic,
                  label: '静音',
                  color: Colors.white10,
                  size: 56.w,
                  isActive: state.isMuted,
                ),
                _buildCallButton(
                  onTap: _handleToggleCamera,
                  icon: Icons.repeat,
                  label: '翻转',
                  color: Colors.white10,
                  size: 56.w,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40.w),
            child: _buildCallButton(
              onTap: _handleEndCall,
              icon: Icons.call_end,
              label: '',
              color: Colors.redAccent,
              size: 72.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallDurationInfo() {
    return Text(
      _formatDuration(_callDuration),
      style: TextStyle(
        fontSize: 16.sp, 
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontFamily: 'monospace',
      ),
    );
  }

  Widget _buildCallButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    Color? color,
    double? size,
    bool isActive = false,
  }) {
    final buttonSize = size ?? 64.w;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: color ?? (isActive ? Colors.white : Colors.white10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isActive && color == null ? Colors.black : Colors.white, size: (buttonSize * 0.45)),
          ),
        ),
        if (label.isNotEmpty) ...[
          SizedBox(height: 8.w),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 13.sp)),
        ],
      ],
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

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
import 'package:beaver/features/contact/selector/contact_selector_page.dart';
import 'package:beaver/types/business/contact.dart';

class CallPage extends StatefulWidget {
  final String conversationId;
  final String roomToken;
  final String liveKitUrl;
  final CallType callType;
  final bool isGroup;

  const CallPage({
    super.key,
    required this.conversationId,
    required this.roomToken,
    required this.liveKitUrl,
    required this.callType,
    required this.isGroup,
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
    _callPageBloc.add(
      InitializeCallEvent(
        widget.conversationId,
        widget.roomToken,
        widget.liveKitUrl,
        widget.callType,
        isGroup: widget.isGroup,
      ),
    );
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
          if (_isInPiPMode) {
            return _buildPiPView(state);
          }

          return PopScope(
            canPop: true,
            child: BeaverLayout(
              showHeader: false,
              showBackground: false,
              isScrollable: false,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color(0xFF000000),
                child: state.isGroup
                    ? _buildGroupCallView(state)
                    : _buildPrivateCallView(state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrivateCallView(CallPageState state) {
    if (state.callType == CallType.video) {
      return _buildPrivateVideoView(state);
    }
    return _buildPrivateAudioView(state);
  }

  Widget _buildGroupCallView(CallPageState state) {
    if (state.callType == CallType.video) {
      return _buildGroupVideoView(state);
    }
    return _buildGroupAudioView(state);
  }

  Widget _buildPrivateAudioView(CallPageState state) {
    final participants = state.participants;
    final remoteParticipants = participants
        .where(
          (p) => p.userId != (_callPageBloc.localParticipant?.userId ?? 'me'),
        )
        .toList();
    final otherParticipant = remoteParticipants.isNotEmpty
        ? remoteParticipants[0]
        : const CallParticipant(userId: '', name: '未知');

    return Stack(
      children: [
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
              filter: ColorFilter.mode(
                Colors.black.withOpacity(0.6),
                BlendMode.darken,
              ),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),

        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.picture_in_picture_alt,
                        color: Colors.white,
                        size: 28.w,
                      ),
                      onPressed: () => _pipService.enterPiPMode(),
                    ),
                    _buildCallDurationInfo(),
                    IconButton(
                      icon: Icon(
                        Icons.person_add_alt_1,
                        color: Colors.white,
                        size: 24.w,
                      ),
                      onPressed: _handleAddParticipant,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.w),
              Text(
                otherParticipant.name,
                style: TextStyle(
                  fontSize: 28.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.w),
              const Text(
                '正在语音通话...',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),

              const Spacer(),

              Container(
                width: 140.w,
                height: 140.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white12, width: 2.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: BeaverCachedImage(
                  fileUrl: otherParticipant.avatarUrl,
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

  Widget _buildAudioControls(CallPageState state) {
    return Padding(
      padding: EdgeInsets.only(bottom: 60.w),
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

  Widget _buildPrivateVideoView(CallPageState state) {
    final participants = state.participants;
    final remoteParticipants = participants
        .where(
          (p) => p.userId != (_callPageBloc.localParticipant?.userId ?? 'me'),
        )
        .toList();
    final remoteParticipant = remoteParticipants.isNotEmpty
        ? remoteParticipants[0]
        : null;

    return Stack(
      children: [
        Positioned.fill(
          child:
              remoteParticipant?.videoTrack != null &&
                  !remoteParticipant!.isCameraOff
              ? VideoTrackRenderer(
                  remoteParticipant.videoTrack!,
                  fit: VideoViewFit.cover,
                )
              : Container(
                  color: const Color(0xFF1C1C1E),
                  child: Center(
                    child: BeaverCachedImage(
                      fileUrl: remoteParticipant?.avatarUrl,
                      width: 100.w,
                      height: 100.w,
                      borderRadius: 50.w,
                      type: CacheType.avatar,
                    ),
                  ),
                ),
        ),

        if (state.isLocalVideoSmall)
          Positioned(
            top: 60.w,
            right: 20.w,
            child: GestureDetector(
              onTap: _handleSwitchVideoView,
              child: Container(
                width: 110.w,
                height: 160.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.w),
                  border: Border.all(color: Colors.white24, width: 1.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildLocalVideoView(state),
              ),
            ),
          ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _pipService.enterPiPMode(),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.2),
                      ),
                      child: Icon(
                        Icons.picture_in_picture_alt,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    ),
                  ),
                  _buildCallDurationInfo(),
                  GestureDetector(
                    onTap: _handleAddParticipant,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.2),
                      ),
                      child: Icon(
                        Icons.person_add_alt_1,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        _buildControlsOverlay(state),
      ],
    );
  }

  Widget _buildGroupVideoView(CallPageState state) {
    final participants = state.participants;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _pipService.enterPiPMode(),
                    child: Icon(
                      Icons.picture_in_picture_alt,
                      color: Colors.white,
                      size: 28.w,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    '群视频通话 (${participants.length}人)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  _buildCallDurationInfo(),
                ],
              ),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 80.w, bottom: 200.w),
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: participants.length <= 4 ? 2 : 3,
              mainAxisSpacing: 8.w,
              crossAxisSpacing: 8.w,
              childAspectRatio: 1.0,
            ),
            itemCount: participants.length + 1,
            itemBuilder: (context, index) {
              if (index < participants.length) {
                return _buildParticipantGridItem(participants[index], state);
              } else {
                return _buildAddParticipantGridItem();
              }
            },
          ),
        ),
        _buildControlsOverlay(state),
      ],
    );
  }

  Widget _buildGroupAudioView(CallPageState state) {
    final participants = state.participants;

    return Stack(
      children: [
        Positioned.fill(child: Container(color: const Color(0xFF1C1C1E))),

        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _pipService.enterPiPMode(),
                      child: Icon(
                        Icons.picture_in_picture_alt,
                        color: Colors.white,
                        size: 28.w,
                      ),
                    ),
                    const Spacer(),
                    _buildCallDurationInfo(),
                    const Spacer(),
                    SizedBox(width: 32.w),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(24.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 24.w,
                    crossAxisSpacing: 20.w,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: participants.length + 1,
                  itemBuilder: (context, index) {
                    if (index < participants.length) {
                      final p = participants[index];
                      return Column(
                        children: [
                          BeaverCachedImage(
                            fileUrl: p.avatarUrl,
                            width: 60.w,
                            height: 60.w,
                            borderRadius: 12.w,
                            type: CacheType.avatar,
                          ),
                          SizedBox(height: 8.w),
                          Text(
                            p.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return _buildAddParticipantGridItem(isAudio: true);
                    }
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

  Widget _buildAddParticipantGridItem({bool isAudio = false}) {
    return GestureDetector(
      onTap: _handleAddParticipant,
      child: Column(
        children: [
          Container(
            width: isAudio ? 60.w : double.infinity,
            height: isAudio ? 60.w : double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(isAudio ? 12.w : 8.w),
              border: Border.all(color: Colors.white12, width: 1.w),
            ),
            child: Icon(Icons.add, color: Colors.white38, size: 30.w),
          ),
          if (isAudio) ...[
            SizedBox(height: 8.w),
            Text(
              '添加',
              style: TextStyle(color: Colors.white38, fontSize: 11.sp),
            ),
          ],
        ],
      ),
    );
  }

  void _handleAddParticipant() async {
    final state = _callPageBloc.state;
    final currentParticipantIds = state.participants
        .map((p) => p.userId)
        .toList();

    final List<ContactModel>? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactSelectorPage(
          title: '邀请成员',
          disabledUserIds: currentParticipantIds,
        ),
      ),
    );

    if (result != null && result.isNotEmpty) {
      final userIds = result.map((c) => c.userId).toList();
      _callPageBloc.add(InviteParticipantsEvent(userIds));
      BeaverToast.show(context, '已发送邀请');
    }
  }

  Widget _buildParticipantGridItem(CallParticipant p, CallPageState state) {
    final isLocal =
        p.userId == (_callPageBloc.localParticipant?.userId ?? 'me');
    final isCameraOff = isLocal ? state.isCameraOff : p.isCameraOff;
    final videoTrack = p.videoTrack;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(8.w),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (videoTrack != null && !isCameraOff)
            VideoTrackRenderer(videoTrack, fit: VideoViewFit.cover)
          else
            Center(
              child: BeaverCachedImage(
                fileUrl: p.avatarUrl,
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
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Text(
                p.name + (isLocal ? ' (我)' : ''),
                style: TextStyle(color: Colors.white, fontSize: 10.sp),
              ),
            ),
          ),
          if (isLocal ? state.isMuted : p.isMuted)
            Positioned(
              top: 8.w,
              right: 8.w,
              child: Icon(Icons.mic_off, color: Colors.redAccent, size: 14.w),
            ),
        ],
      ),
    );
  }

  Widget _buildControlsOverlay(CallPageState state) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(bottom: 40.w, top: 40.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCallButton(
                  onTap: _handleToggleSpeaker,
                  icon: state.isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                  label: '扬声器',
                  isActive: state.isSpeakerOn,
                ),
                _buildCallButton(
                  onTap: _handleToggleMute,
                  icon: state.isMuted ? Icons.mic_off : Icons.mic,
                  label: '静音',
                  isActive: state.isMuted,
                ),
                _buildCallButton(
                  onTap: _handleToggleCamera,
                  icon: Icons.repeat,
                  label: '翻转',
                ),
              ],
            ),
            SizedBox(height: 40.w),
            _buildCallButton(
              onTap: _handleEndCall,
              icon: Icons.call_end,
              label: '',
              color: Colors.redAccent,
              size: 72.w,
            ),
          ],
        ),
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
            child: Icon(
              icon,
              color: isActive && color == null ? Colors.black : Colors.white,
              size: (buttonSize * 0.45),
            ),
          ),
        ),
        if (label.isNotEmpty) ...[
          SizedBox(height: 8.w),
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 13.sp),
          ),
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
                fileUrl: localParticipant?.avatarUrl,
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

  Widget _buildPiPView(CallPageState state) {
    if (state.isGroup) {
      return Container(
        color: const Color(0xFF1C1C1E),
        child: Center(
          child: Icon(
            state.callType == CallType.video ? Icons.videocam : Icons.call,
            color: Colors.white24,
            size: 40.w,
          ),
        ),
      );
    }

    final participants = state.participants;
    final remoteParticipants = participants
        .where(
          (p) => p.userId != (_callPageBloc.localParticipant?.userId ?? 'me'),
        )
        .toList();
    final otherParticipant = remoteParticipants.isNotEmpty
        ? remoteParticipants[0]
        : const CallParticipant(userId: '', name: '未知');

    if (state.callType == CallType.video && 
        otherParticipant.videoTrack != null && 
        !otherParticipant.isCameraOff) {
      return VideoTrackRenderer(otherParticipant.videoTrack!, fit: VideoViewFit.cover);
    }

    return Container(
      color: const Color(0xFF1C1C1E),
      child: Center(
        child: BeaverCachedImage(
          fileUrl: otherParticipant.avatarUrl,
          width: 60.w,
          height: 60.w,
          borderRadius: 30.w,
          type: CacheType.avatar,
        ),
      ),
    );
  }
}

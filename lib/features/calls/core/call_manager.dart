import 'package:livekit_client/livekit_client.dart';
import 'package:flutter/foundation.dart';
import 'package:beaver/features/calls/data/models/call.dart';

class CallManager {
  static final CallManager _instance = CallManager._private();
  factory CallManager() => _instance;
  
  CallManager._private();
  
  Room? _room;
  bool _isInitialized = false;
  
  final List<CallParticipant> _participants = [];
  final List<CallManagerListener> _listeners = [];
  
  // 初始化LiveKit房间
  Future<void> initialize(String roomToken, String liveKitUrl) async {
    if (_isInitialized) return;
    
    try {
      _room = Room(
        adaptiveStream: true,
        dynacast: true,
        videoCaptureDefaults: const VideoCaptureOptions(
          resolution: VideoResolution.h720,
        ),
      );
      
      _setupRoomListeners();
      
      await _room?.connect(liveKitUrl, roomToken);
      _isInitialized = true;
      
      for (var listener in _listeners) {
        listener.onConnected();
      }
    } catch (e) {
      debugPrint('LiveKit连接失败: $e');
      for (var listener in _listeners) {
        listener.onError(e.toString());
      }
    }
  }
  
  // 断开连接
  Future<void> disconnect() async {
    await _room?.disconnect();
    _isInitialized = false;
    _participants.clear();
    
    for (var listener in _listeners) {
      listener.onDisconnected();
    }
  }
  
  // 开始通话
  Future<void> startCall() async {
    if (_room?.state != RoomState.connected) return;
    
    try {
      // 发布本地音视频轨道
      await _room?.localParticipant?.setCameraEnabled(true);
      await _room?.localParticipant?.setMicrophoneEnabled(true);
    } catch (e) {
      debugPrint('开始通话失败: $e');
    }
  }
  
  // 结束通话
  Future<void> endCall() async {
    await disconnect();
  }
  
  // 切换静音
  Future<void> toggleMute() async {
    if (_room?.state != RoomState.connected) return;
    
    final isMuted = _room?.localParticipant?.isMicrophoneEnabled ?? false;
    await _room?.localParticipant?.setMicrophoneEnabled(!isMuted);
  }
  
  // 切换摄像头
  Future<void> toggleCamera() async {
    if (_room?.state != RoomState.connected) return;
    
    final isCameraOn = _room?.localParticipant?.isCameraEnabled ?? false;
    await _room?.localParticipant?.setCameraEnabled(!isCameraOn);
  }
  
  // 切换扬声器
  Future<void> toggleSpeaker() async {
    // 实现扬声器切换逻辑
  }
  
  // 获取参与者列表
  List<CallParticipant> get participants => _participants;
  
  // 获取本地参与者
  CallParticipant? get localParticipant {
    if (_room?.localParticipant == null) return null;
    
    return _participants.firstWhere(
      (p) => p.userId == _room?.localParticipant?.identity,
      orElse: () {
        final participant = CallParticipant(
          userId: _room!.localParticipant!.identity,
          name: _room!.localParticipant!.name,
          isMuted: !(_room!.localParticipant!.isMicrophoneEnabled),
          isCameraOff: !(_room!.localParticipant!.isCameraEnabled),
          status: CallParticipantStatus.joined,
        );
        _participants.add(participant);
        return participant;
      },
    );
  }
  
  // 添加监听器
  void addListener(CallManagerListener listener) {
    _listeners.add(listener);
  }
  
  // 移除监听器
  void removeListener(CallManagerListener listener) {
    _listeners.remove(listener);
  }
  
  // 设置房间监听器
  void _setupRoomListeners() {
    if (_room == null) return;
    
    _room!
      ..onConnected = () {
        debugPrint('LiveKit房间连接成功');
      }
      ..onDisconnected = () {
        debugPrint('LiveKit房间断开连接');
        _isInitialized = false;
      }
      ..onParticipantConnected = (participant) {
        debugPrint('参与者加入: ${participant.identity}');
        
        final newParticipant = CallParticipant(
          userId: participant.identity,
          name: participant.name,
          isMuted: false,
          isCameraOff: true,
          status: CallParticipantStatus.joined,
        );
        
        _participants.add(newParticipant);
        
        for (var listener in _listeners) {
          listener.onParticipantJoined(newParticipant);
        }
      }
      ..onParticipantDisconnected = (participant) {
        debugPrint('参与者离开: ${participant.identity}');
        
        final index = _participants.indexWhere((p) => p.userId == participant.identity);
        if (index != -1) {
          final removedParticipant = _participants.removeAt(index);
          for (var listener in _listeners) {
            listener.onParticipantLeft(removedParticipant);
          }
        }
      }
      ..onTrackSubscribed = (track, publication, participant) {
        debugPrint('轨道订阅: ${track.kind}');
        
        final index = _participants.indexWhere((p) => p.userId == participant.identity);
        if (index != -1) {
          final updatedParticipant = _participants[index].copyWith(
            isCameraOff: track.kind != TrackType.video,
            isMuted: track.kind != TrackType.audio,
          );
          _participants[index] = updatedParticipant;
          
          for (var listener in _listeners) {
            listener.onParticipantUpdated(updatedParticipant);
          }
        }
      }
      ..onTrackMuted = (publication, participant) {
        debugPrint('轨道静音: ${publication.kind}');
        
        final index = _participants.indexWhere((p) => p.userId == participant?.identity);
        if (index != -1) {
          final updatedParticipant = _participants[index].copyWith(
            isMuted: publication.kind == TrackType.audio,
            isCameraOff: publication.kind == TrackType.video,
          );
          _participants[index] = updatedParticipant;
          
          for (var listener in _listeners) {
            listener.onParticipantUpdated(updatedParticipant);
          }
        }
      }
      ..onTrackUnmuted = (publication, participant) {
        debugPrint('轨道取消静音: ${publication.kind}');
        
        final index = _participants.indexWhere((p) => p.userId == participant?.identity);
        if (index != -1) {
          final updatedParticipant = _participants[index].copyWith(
            isMuted: publication.kind != TrackType.audio,
            isCameraOff: publication.kind != TrackType.video,
          );
          _participants[index] = updatedParticipant;
          
          for (var listener in _listeners) {
            listener.onParticipantUpdated(updatedParticipant);
          }
        }
      };
  }
}

// 通话参与者状态
enum CallParticipantStatus {
  joined,
  left,
  pending,
}

// 通话参与者模型
class CallParticipant {
  final String userId;
  final String name;
  final bool isMuted;
  final bool isCameraOff;
  final CallParticipantStatus status;
  final String? avatarUrl;
  
  CallParticipant({
    required this.userId,
    required this.name,
    required this.isMuted,
    required this.isCameraOff,
    required this.status,
    this.avatarUrl,
  });
  
  CallParticipant copyWith({
    String? userId,
    String? name,
    bool? isMuted,
    bool? isCameraOff,
    CallParticipantStatus? status,
    String? avatarUrl,
  }) {
    return CallParticipant(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      isMuted: isMuted ?? this.isMuted,
      isCameraOff: isCameraOff ?? this.isCameraOff,
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

// 通话管理器监听器
abstract class CallManagerListener {
  void onConnected();
  void onDisconnected();
  void onError(String error);
  void onParticipantJoined(CallParticipant participant);
  void onParticipantLeft(CallParticipant participant);
  void onParticipantUpdated(CallParticipant participant);
}

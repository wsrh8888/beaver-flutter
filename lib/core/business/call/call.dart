import 'package:livekit_client/livekit_client.dart';
import 'package:flutter/foundation.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/call/call.dart';
import 'package:beaver/types/call.dart';

abstract class CallRepositoryInterface {
}

class CallBusiness implements CallRepositoryInterface {
  final Room _room = Room();
  bool _isInitialized = false;
  
  CallStore get _store => getIt<CallStore>();
  
  CallBusiness() {
    _setupRoomListeners();
  }
  
  // 初始化LiveKit房间
  Future<void> initialize(String roomToken, String liveKitUrl) async {
    if (_isInitialized && _room.connectionState == ConnectionState.connected) return;
    
    try {
      debugPrint('开始连接 LiveKit 房间: $liveKitUrl');
      await _room.connect(liveKitUrl, roomToken);
      _isInitialized = true;
      
      // 同步本地参与者
      final local = _room.localParticipant;
      if (local != null) {
        _store.upsertMember(local.identity, 
          status: CallParticipantStatus.joined,
          nickName: '我', // 实际应用中可以从用户信息中获取
        );
      }
      
      // 同步存量远程参与者
      for (var p in _room.remoteParticipants.values) {
        _store.upsertMember(p.identity, status: CallParticipantStatus.joined, nickName: p.name);
        // 订阅存量轨道
        for (var pub in p.trackPublications.values) {
          final track = pub.track;
          if (pub.subscribed && track != null) {
            _onTrackSubscribed(track, pub, p);
          }
        }
      }
    } catch (e) {
      debugPrint('LiveKit连接失败: $e');
      rethrow;
    }
  }
  
  // 断开连接
  Future<void> disconnect() async {
    await _room.disconnect();
    _isInitialized = false;
    _store.clear();
  }
  
  // 开始通话
  Future<void> startCall() async {
    if (!_isInitialized) return;
    
    try {
      // 发布本地音视频轨道
      await _room.localParticipant?.setCameraEnabled(true);
      await _room.localParticipant?.setMicrophoneEnabled(true);
    } catch (e) {
      debugPrint('开始通话发布轨道失败: $e');
    }
  }
  
  // 结束通话
  Future<void> endCall() async {
    await disconnect();
  }
  
  // 切换静音
  Future<void> toggleMute() async {
    final localParticipant = _room.localParticipant;
    if (localParticipant == null) return;
    
    final isMuted = !localParticipant.isMicrophoneEnabled();
    await localParticipant.setMicrophoneEnabled(isMuted);
    
    _store.upsertMember(localParticipant.identity, isMuted: !isMuted);
  }
  
  // 切换摄像头
  Future<void> toggleCamera() async {
    final localParticipant = _room.localParticipant;
    if (localParticipant == null) return;
    
    final isCameraOff = !localParticipant.isCameraEnabled();
    await localParticipant.setCameraEnabled(isCameraOff);
    
    _store.upsertMember(localParticipant.identity, isCameraOff: !isCameraOff);
  }
  
  // 切换扬声器
  Future<void> toggleSpeaker() async {
    // 移动端通常在这里处理硬件控制
  }
  
  void _setupRoomListeners() {
    final listener = _room.createListener();
    listener
      ..on<ParticipantConnectedEvent>((event) {
        debugPrint('参与者加入: ${event.participant.identity}');
        _store.upsertMember(event.participant.identity, 
          status: CallParticipantStatus.joined,
          nickName: event.participant.name);
      })
      ..on<ParticipantDisconnectedEvent>((event) {
        debugPrint('参与者离开: ${event.participant.identity}');
        _store.upsertMember(event.participant.identity, status: CallParticipantStatus.left);
      })
      ..on<TrackSubscribedEvent>((event) {
        _onTrackSubscribed(event.track, event.publication, event.participant);
      })
      ..on<TrackUnsubscribedEvent>((event) {
        _onTrackUnsubscribed(event.track, event.publication, event.participant);
      })
      ..on<TrackMutedEvent>((event) {
         _onTrackMuteChanged(event.participant, event.publication, true);
      })
      ..on<TrackUnmutedEvent>((event) {
         _onTrackMuteChanged(event.participant, event.publication, false);
      })
      ..on<LocalTrackPublishedEvent>((event) {
        final identity = _room.localParticipant?.identity;
        if (identity == null) return;
        if (event.publication.kind == TrackType.VIDEO) {
          _store.upsertMember(identity, videoTrack: event.publication.track as VideoTrack?);
        } else if (event.publication.kind == TrackType.AUDIO) {
          _store.upsertMember(identity, audioTrack: event.publication.track as AudioTrack?);
        }
      })
      ..on<RoomDisconnectedEvent>((event) {
        disconnect();
      });
  }

  void _onTrackSubscribed(Track track, RemoteTrackPublication publication, RemoteParticipant participant) {
    if (track is VideoTrack) {
      _store.upsertMember(participant.identity, 
        videoTrack: track, 
        isCameraOff: false,
        sid: track.sid
      );
    } else if (track is AudioTrack) {
      _store.upsertMember(participant.identity, 
        audioTrack: track, 
        isMuted: false,
        sid: track.sid
      );
    }
  }

  void _onTrackUnsubscribed(Track track, RemoteTrackPublication publication, RemoteParticipant participant) {
    if (track is VideoTrack) {
      _store.upsertMember(participant.identity, videoTrack: null, isCameraOff: true);
    } else if (track is AudioTrack) {
      _store.upsertMember(participant.identity, audioTrack: null, isMuted: true);
    }
  }

  void _onTrackMuteChanged(Participant participant, TrackPublication publication, bool isMuted) {
    if (publication.kind == TrackType.VIDEO) {
       _store.upsertMember(participant.identity, isCameraOff: isMuted);
    } else if (publication.kind == TrackType.AUDIO) {
       _store.upsertMember(participant.identity, isMuted: isMuted);
    }
  }

  Room get room => _room;
}

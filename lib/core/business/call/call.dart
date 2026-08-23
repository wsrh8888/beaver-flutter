/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

import 'package:livekit_client/livekit_client.dart';
import 'package:flutter/foundation.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/call/call.dart';
import 'package:beaver/types/call.dart';
import 'package:beaver/api/call.dart';
import 'package:beaver/types/api/call.dart' as api;
import 'package:beaver/store/contact/contact.dart';
import 'package:flutter/material.dart' hide ConnectionState;

abstract class CallRepositoryInterface {
}

class CallBusiness implements CallRepositoryInterface {
  final Room _room = Room();
  bool _isInitialized = false;
  String? _currentRoomId;
  
  CallStore get _store => getIt<CallStore>();
  
  CallBusiness() {
    _setupRoomListeners();
  }

  // 发起通话
  Future<api.CallInfoRes?> makeCall(String conversationId, int callType, int callMode) async {
    final response = await startCallApi(api.StartCallReq(
      conversationId: conversationId,
      callType: callType,
      callMode: callMode,
    ));
    
    if (response.code == 0 && response.result != null) {
      return response.result;
    }
    return null;
  }

  // 内部辅助方法：更新成员，自动补全头像和昵称
  void _upsertMember(String userId, {
    String? nickName,
    String? avatar,
    CallParticipantStatus? status,
    bool? isMuted,
    bool? isCameraOff,
    dynamic videoTrack,
    dynamic audioTrack,
    String? sid,
  }) {
    var finalNickName = nickName;
    var finalAvatar = avatar;
    
    if (finalNickName == null || finalAvatar == null || finalNickName == userId) {
      final contact = getIt<ContactStore>().getContact(userId);
      if (contact != null) {
        finalNickName = (finalNickName == null || finalNickName == userId) ? contact.nickname : finalNickName;
        finalAvatar ??= contact.avatar;
      }
    }
    
    _store.upsertMember(userId,
      nickName: finalNickName,
      avatar: finalAvatar,
      status: status,
      isMuted: isMuted,
      isCameraOff: isCameraOff,
      videoTrack: videoTrack,
      audioTrack: audioTrack,
      sid: sid,
    );
  }
  
  // 初始化LiveKit房间
  Future<void> initialize(String roomId, String roomToken, String liveKitUrl) async {
    _currentRoomId = roomId;
    if (_isInitialized && _room.connectionState == ConnectionState.connected) return;
    
    try {
      debugPrint('开始连接 LiveKit 房间: $liveKitUrl');
      await _room.connect(liveKitUrl, roomToken);
      _isInitialized = true;
      
      // 同步本地参与者
      final local = _room.localParticipant;
      if (local != null) {
        _upsertMember(local.identity, 
          status: CallParticipantStatus.joined,
        );
      }
      
      // 同步存量远程参与者
      for (var p in _room.remoteParticipants.values) {
        _upsertMember(p.identity, status: CallParticipantStatus.joined, nickName: p.name);
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
  
  // 邀请参与者
  Future<void> inviteParticipants(List<String> userIds) async {
    if (_currentRoomId == null) return;
    await inviteParticipantsApi(api.InviteParticipantsReq(
      roomId: _currentRoomId!,
      userIds: userIds,
    ));
    
    // 预填入参会者列表（待加入状态）
    for (var userId in userIds) {
      _upsertMember(userId, status: CallParticipantStatus.pending);
    }
  }
  
  // 断开连接
  Future<void> disconnect() async {
    await _room.disconnect();
    _isInitialized = false;
    _currentRoomId = null;
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
    
    _upsertMember(localParticipant.identity, isMuted: !isMuted);
  }
  
  // 切换摄像头
  Future<void> toggleCamera() async {
    final localParticipant = _room.localParticipant;
    if (localParticipant == null) return;
    
    final isCameraOff = !localParticipant.isCameraEnabled();
    await localParticipant.setCameraEnabled(isCameraOff);
    
    _upsertMember(localParticipant.identity, isCameraOff: !isCameraOff);
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
        _upsertMember(event.participant.identity, 
          status: CallParticipantStatus.joined,
          nickName: event.participant.name);
      })
      ..on<ParticipantDisconnectedEvent>((event) {
        debugPrint('参与者离开: ${event.participant.identity}');
        _upsertMember(event.participant.identity, status: CallParticipantStatus.left);
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
          _upsertMember(identity, videoTrack: event.publication.track as VideoTrack?);
        } else if (event.publication.kind == TrackType.AUDIO) {
          _upsertMember(identity, audioTrack: event.publication.track as AudioTrack?);
        }
      })
      ..on<RoomDisconnectedEvent>((event) {
        disconnect();
      });
  }

  void _onTrackSubscribed(Track track, RemoteTrackPublication publication, RemoteParticipant participant) {
    if (track is VideoTrack) {
      _upsertMember(participant.identity, 
        videoTrack: track, 
        isCameraOff: false,
        sid: track.sid
      );
    } else if (track is AudioTrack) {
      _upsertMember(participant.identity, 
        audioTrack: track, 
        isMuted: false,
        sid: track.sid
      );
    }
  }

  void _onTrackUnsubscribed(Track track, RemoteTrackPublication publication, RemoteParticipant participant) {
    if (track is VideoTrack) {
      _upsertMember(participant.identity, videoTrack: null, isCameraOff: true);
    } else if (track is AudioTrack) {
      _upsertMember(participant.identity, audioTrack: null, isMuted: true);
    }
  }

  void _onTrackMuteChanged(Participant participant, TrackPublication publication, bool isMuted) {
    if (publication.kind == TrackType.VIDEO) {
       _upsertMember(participant.identity, isCameraOff: isMuted);
    } else if (publication.kind == TrackType.AUDIO) {
       _upsertMember(participant.identity, isMuted: isMuted);
    }
  }

  Room get room => _room;
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/call/call.dart';
import 'package:beaver/types/call.dart';

// 基础信息
class CallBaseInfo extends Equatable {
  final String callMode; // 'audio' | 'video' | ''
  final String callerId;
  final String conversationId;
  final String callType; // 'private' | 'group' | ''
  final String role; // 'caller' | 'callee' | ''
  final String roomName;

  const CallBaseInfo({
    this.callMode = '',
    this.callerId = '',
    this.conversationId = '',
    this.callType = '',
    this.role = '',
    this.roomName = '',
  });

  @override
  List<Object?> get props => [callMode, callerId, conversationId, callType, role, roomName];

  CallBaseInfo copyWith({
    String? callMode,
    String? callerId,
    String? conversationId,
    String? callType,
    String? role,
    String? roomName,
  }) {
    return CallBaseInfo(
      callMode: callMode ?? this.callMode,
      callerId: callerId ?? this.callerId,
      conversationId: conversationId ?? this.conversationId,
      callType: callType ?? this.callType,
      role: role ?? this.role,
      roomName: roomName ?? this.roomName,
    );
  }
}

// 房间信息
class CallRoomInfo extends Equatable {
  final String roomId;
  final String roomToken;
  final String liveKitUrl;
  final String creatorId;

  const CallRoomInfo({
    this.roomId = '',
    this.roomToken = '',
    this.liveKitUrl = '',
    this.creatorId = '',
  });

  @override
  List<Object?> get props => [roomId, roomToken, liveKitUrl, creatorId];

  CallRoomInfo copyWith({
    String? roomId,
    String? roomToken,
    String? liveKitUrl,
    String? creatorId,
  }) {
    return CallRoomInfo(
      roomId: roomId ?? this.roomId,
      roomToken: roomToken ?? this.roomToken,
      liveKitUrl: liveKitUrl ?? this.liveKitUrl,
      creatorId: creatorId ?? this.creatorId,
    );
  }
}

class CallStoreState extends Equatable {
  final CallBaseInfo baseInfo;
  final CallRoomInfo roomInfo;
  final List<CallParticipant> members;

  const CallStoreState({
    this.baseInfo = const CallBaseInfo(),
    this.roomInfo = const CallRoomInfo(),
    this.members = const [],
  });

  @override
  List<Object?> get props => [baseInfo, roomInfo, members];

  CallStoreState copyWith({
    CallBaseInfo? baseInfo,
    CallRoomInfo? roomInfo,
    List<CallParticipant>? members,
  }) {
    return CallStoreState(
      baseInfo: baseInfo ?? this.baseInfo,
      roomInfo: roomInfo ?? this.roomInfo,
      members: members ?? this.members,
    );
  }
}

class CallStore extends Cubit<CallStoreState> {
  final CallBusiness _callBusiness;
  
  CallStore({CallBusiness? callBusiness}) 
    : _callBusiness = callBusiness ?? getIt<CallBusiness>(),
      super(const CallStoreState());

  Future<void> init() async {}

  // 更新或新增成员
  void upsertMember(String userId, {
    String? nickName,
    String? avatar,
    CallParticipantStatus? status,
    bool? isMuted,
    bool? isCameraOff,
    dynamic videoTrack,
    dynamic audioTrack,
    String? sid,
  }) {
    final members = List<CallParticipant>.from(state.members);
    final index = members.indexWhere((m) => m.userId == userId);
    
    if (index >= 0) {
      members[index] = members[index].copyWith(
        name: nickName,
        avatarUrl: avatar,
        status: status,
        isMuted: isMuted,
        isCameraOff: isCameraOff,
        videoTrack: videoTrack,
        audioTrack: audioTrack,
        sid: sid,
      );
    } else {
      members.add(CallParticipant(
        userId: userId,
        name: nickName ?? userId,
        avatarUrl: avatar,
        status: status ?? CallParticipantStatus.pending,
        isMuted: isMuted ?? false,
        isCameraOff: isCameraOff ?? false,
        videoTrack: videoTrack,
        audioTrack: audioTrack,
        sid: sid,
      ));
    }
    
    emit(state.copyWith(members: members));
  }

  // 通过 SID 更新远程轨道信息
  void updateMemberBySid(String sid, {
    bool? isMuted,
    bool? isCameraOff,
    dynamic videoTrack,
    dynamic audioTrack,
  }) {
    final members = List<CallParticipant>.from(state.members);
    final index = members.indexWhere((m) => m.sid == sid);
    
    if (index >= 0) {
      members[index] = members[index].copyWith(
        isMuted: isMuted,
        isCameraOff: isCameraOff,
        videoTrack: videoTrack,
        audioTrack: audioTrack,
      );
      emit(state.copyWith(members: members));
    }
  }

  void setBaseInfo(CallBaseInfo baseInfo) {
    emit(state.copyWith(baseInfo: baseInfo));
  }

  void setRoomInfo(CallRoomInfo roomInfo) {
    emit(state.copyWith(roomInfo: roomInfo));
  }

  void clear() {
    emit(const CallStoreState());
  }

  // 暴露业务层
  CallBusiness get business => _callBusiness;

  CallParticipant? get me {
      // 通过业务层的本地身份标识
      return null; // TODO: 实现获取自己的逻辑
  }
}

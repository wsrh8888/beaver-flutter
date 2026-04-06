import 'package:equatable/equatable.dart';
import 'package:livekit_client/livekit_client.dart';

// 通话状态
enum CallStatus {
  initial,
  loading,
  calling,
  ringing,
  connected,
  ended,
  error,
}

// 通话参与者状态
enum CallParticipantStatus {
  joined,
  left,
  pending,
}

// 通话类型
enum CallType {
  audio,
  video,
}

// 通话信息模型
class CallInfo extends Equatable {
  final String conversationId;
  final String callerName;
  final String callerAvatar;
  final bool isIncoming;
  final bool isGroup;
  final CallType callType;
  final String roomId;
  final String roomToken;
  final String liveKitUrl;
  
  const CallInfo({
    required this.conversationId,
    required this.callerName,
    required this.callerAvatar,
    required this.isIncoming,
    this.isGroup = false,
    this.callType = CallType.video,
    this.roomId = '',
    this.roomToken = '',
    this.liveKitUrl = '',
  });
  
  @override
  List<Object?> get props => [
    conversationId,
    callerName,
    callerAvatar,
    isIncoming,
    isGroup,
    callType,
    roomId,
    roomToken,
    liveKitUrl,
  ];
  
  CallInfo copyWith({
    String? conversationId,
    String? callerName,
    String? callerAvatar,
    bool? isIncoming,
    bool? isGroup,
    CallType? callType,
    String? roomId,
    String? roomToken,
    String? liveKitUrl,
  }) {
    return CallInfo(
      conversationId: conversationId ?? this.conversationId,
      callerName: callerName ?? this.callerName,
      callerAvatar: callerAvatar ?? this.callerAvatar,
      isIncoming: isIncoming ?? this.isIncoming,
      isGroup: isGroup ?? this.isGroup,
      callType: callType ?? this.callType,
      roomId: roomId ?? this.roomId,
      roomToken: roomToken ?? this.roomToken,
      liveKitUrl: liveKitUrl ?? this.liveKitUrl,
    );
  }
  
  factory CallInfo.fromJson(Map<String, dynamic> json) {
    return CallInfo(
      conversationId: json['conversationId'] ?? '',
      callerName: json['callerName'] ?? '',
      callerAvatar: json['callerAvatar'] ?? '',
      isIncoming: json['isIncoming'] ?? false,
      isGroup: json['isGroup'] ?? false,
      callType: json['callType'] == 'video' ? CallType.video : CallType.audio,
      roomId: json['roomId'] ?? '',
      roomToken: json['roomToken'] ?? '',
      liveKitUrl: json['liveKitUrl'] ?? '',
    );
  }
}

// 通话参与者模型
class CallParticipant extends Equatable {
  final String userId;
  final String name;
  final bool isMuted;
  final bool isCameraOff;
  final CallParticipantStatus status;
  final String? avatarUrl;
  final VideoTrack? videoTrack;
  final AudioTrack? audioTrack;
  final String? sid;

  const CallParticipant({
    required this.userId,
    required this.name,
    this.isMuted = false,
    this.isCameraOff = false,
    this.status = CallParticipantStatus.pending,
    this.avatarUrl,
    this.videoTrack,
    this.audioTrack,
    this.sid,
  });

  @override
  List<Object?> get props => [
    userId,
    name,
    isMuted,
    isCameraOff,
    status,
    avatarUrl,
    videoTrack,
    audioTrack,
    sid,
  ];

  CallParticipant copyWith({
    String? userId,
    String? name,
    bool? isMuted,
    bool? isCameraOff,
    CallParticipantStatus? status,
    String? avatarUrl,
    VideoTrack? videoTrack,
    AudioTrack? audioTrack,
    String? sid,
  }) {
    return CallParticipant(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      isMuted: isMuted ?? this.isMuted,
      isCameraOff: isCameraOff ?? this.isCameraOff,
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      videoTrack: videoTrack ?? this.videoTrack,
      audioTrack: audioTrack ?? this.audioTrack,
      sid: sid ?? this.sid,
    );
  }
}

// 通话历史记录模型
class CallHistory extends Equatable {
  final String id;
  final String conversationId;
  final String callerId;
  final String callerName;
  final String callerAvatar;
  final String receiverId;
  final String receiverName;
  final String receiverAvatar;
  final CallType callType;
  final bool isIncoming;
  final bool isMissed;
  final DateTime startTime;
  final DateTime? endTime;
  final int? duration;
  
  const CallHistory({
    required this.id,
    required this.conversationId,
    required this.callerId,
    required this.callerName,
    required this.callerAvatar,
    required this.receiverId,
    required this.receiverName,
    required this.receiverAvatar,
    required this.callType,
    required this.isIncoming,
    required this.isMissed,
    required this.startTime,
    this.endTime,
    this.duration,
  });
  
  @override
  List<Object?> get props => [
    id,
    conversationId,
    callerId,
    callerName,
    callerAvatar,
    receiverId,
    receiverName,
    receiverAvatar,
    callType,
    isIncoming,
    isMissed,
    startTime,
    endTime,
    duration,
  ];
  
  factory CallHistory.fromJson(Map<String, dynamic> json) {
    return CallHistory(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      callerId: json['callerId'] ?? '',
      callerName: json['callerName'] ?? '',
      callerAvatar: json['callerAvatar'] ?? '',
      receiverId: json['receiverId'] ?? '',
      receiverName: json['receiverName'] ?? '',
      receiverAvatar: json['receiverAvatar'] ?? '',
      callType: json['callType'] == 'video' ? CallType.video : CallType.audio,
      isIncoming: json['isIncoming'] ?? false,
      isMissed: json['isMissed'] ?? false,
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      duration: json['duration'] ?? 0,
    );
  }
}

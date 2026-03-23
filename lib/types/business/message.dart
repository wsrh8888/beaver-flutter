import 'chat.dart';

/// 消息类型枚举 (对应桌面端 IMessageMsg.type)
enum MessageType {
  text, // 1
  image, // 2
  video, // 3
  audio, // 8 (AudioFile)
  voice, // 5 (Recording)
  file, // 4
  emoji, // 6
  notification, // 7
  call, // 9
  recalled, // 10
  reply, // 11
  mergedForward, // 12
  system,
}

/// 消息状态枚举
enum MessageStatus { sending, sent, delivered, read, failed }

/// 消息仓库接口
abstract class MessageRepositoryInterface {
  Future<List<MessageModel>> getMessages(
    String conversationId, {
    int limit = 50,
    int offset = 0,
  });
  Future<MessageModel> sendMessage(ChatMessageSendBody data);
  Future<void> updateMessageStatus(String messageId, MessageStatus status);
  Future<ChatModel?> getConversation(String conversationId);
  Stream<List<MessageModel>> watchMessages(String conversationId);
}

/// 基础内容模型
class MessageContentModel {
  final MessageType type;
  final TextMsg? textMsg;
  final ImageMsg? imageMsg;
  final VideoMsg? videoMsg;
  final FileMsg? fileMsg;
  final VoiceMsg? voiceMsg;
  final EmojiMsg? emojiMsg;
  final AudioFileMsg? audioFileMsg;
  final ReplyMsg? replyMsg;
  final ForwardMsg? forwardMsg;

  MessageContentModel({
    required this.type,
    this.textMsg,
    this.imageMsg,
    this.videoMsg,
    this.fileMsg,
    this.voiceMsg,
    this.emojiMsg,
    this.audioFileMsg,
    this.replyMsg,
    this.forwardMsg,
  });

  factory MessageContentModel.fromJson(Map<String, dynamic> json) {
    final typeInt = json['type'] as int;
    final type = _mapIntToType(typeInt);
    return MessageContentModel(
      type: type,
      textMsg: json['textMsg'] != null
          ? TextMsg.fromJson(json['textMsg'])
          : null,
      imageMsg: json['imageMsg'] != null
          ? ImageMsg.fromJson(json['imageMsg'])
          : null,
      videoMsg: json['videoMsg'] != null
          ? VideoMsg.fromJson(json['videoMsg'])
          : null,
      fileMsg: json['fileMsg'] != null
          ? FileMsg.fromJson(json['fileMsg'])
          : null,
      voiceMsg: json['voiceMsg'] != null
          ? VoiceMsg.fromJson(json['voiceMsg'])
          : null,
      emojiMsg: json['emojiMsg'] != null
          ? EmojiMsg.fromJson(json['emojiMsg'])
          : null,
      audioFileMsg: json['audioFileMsg'] != null
          ? AudioFileMsg.fromJson(json['audioFileMsg'])
          : null,
      replyMsg: json['replyMsg'] != null
          ? ReplyMsg.fromJson(json['replyMsg'])
          : null,
      forwardMsg: json['forwardMsg'] != null
          ? ForwardMsg.fromJson(json['forwardMsg'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': _mapTypeToInt(type),
      'textMsg': textMsg?.toJson(),
      'imageMsg': imageMsg?.toJson(),
      'videoMsg': videoMsg?.toJson(),
      'fileMsg': fileMsg?.toJson(),
      'voiceMsg': voiceMsg?.toJson(),
      'emojiMsg': emojiMsg?.toJson(),
      'audioFileMsg': audioFileMsg?.toJson(),
      'replyMsg': replyMsg?.toJson(),
      'forwardMsg': forwardMsg?.toJson(),
    };
  }

  static int _mapTypeToInt(MessageType type) {
    switch (type) {
      case MessageType.text:
        return 1;
      case MessageType.image:
        return 2;
      case MessageType.video:
        return 3;
      case MessageType.file:
        return 4;
      case MessageType.voice:
        return 5;
      case MessageType.emoji:
        return 6;
      case MessageType.notification:
        return 7;
      case MessageType.audio:
        return 8;
      case MessageType.call:
        return 9;
      case MessageType.recalled:
        return 10;
      case MessageType.reply:
        return 11;
      case MessageType.mergedForward:
        return 12;
      default:
        return 1;
    }
  }

  static MessageType _mapIntToType(int type) {
    switch (type) {
      case 1:
        return MessageType.text;
      case 2:
        return MessageType.image;
      case 3:
        return MessageType.video;
      case 4:
        return MessageType.file;
      case 5:
        return MessageType.voice;
      case 6:
        return MessageType.emoji;
      case 7:
        return MessageType.notification;
      case 8:
        return MessageType.audio;
      case 9:
        return MessageType.call;
      case 10:
        return MessageType.recalled;
      case 11:
        return MessageType.reply;
      case 12:
        return MessageType.mergedForward;
      default:
        return MessageType.text;
    }
  }
}

class TextMsg {
  final String content;
  TextMsg({required this.content});
  factory TextMsg.fromJson(Map<String, dynamic> json) =>
      TextMsg(content: json['content'] ?? '');
  Map<String, dynamic> toJson() => {'content': content};
}

class ImageMsg {
  final String fileKey;
  final double? width;
  final double? height;
  final int? size;
  ImageMsg({required this.fileKey, this.width, this.height, this.size});
  factory ImageMsg.fromJson(Map<String, dynamic> json) => ImageMsg(
    fileKey: json['fileKey'] ?? '',
    width: (json['width'] as num?)?.toDouble(),
    height: (json['height'] as num?)?.toDouble(),
    size: json['size'],
  );
  Map<String, dynamic> toJson() => {
    'fileKey': fileKey,
    'width': width,
    'height': height,
    'size': size,
  };
}

class VideoMsg {
  final String fileKey;
  final String? thumbnailKey;
  final double? width;
  final double? height;
  final int? duration;
  VideoMsg({
    required this.fileKey,
    this.thumbnailKey,
    this.width,
    this.height,
    this.duration,
  });
  factory VideoMsg.fromJson(Map<String, dynamic> json) => VideoMsg(
    fileKey: json['fileKey'] ?? '',
    thumbnailKey: json['thumbnailKey'],
    width: (json['width'] as num?)?.toDouble(),
    height: (json['height'] as num?)?.toDouble(),
    duration: json['duration'],
  );
  Map<String, dynamic> toJson() => {
    'fileKey': fileKey,
    'thumbnailKey': thumbnailKey,
    'width': width,
    'height': height,
    'duration': duration,
  };
}

class FileMsg {
  final String fileKey;
  final String? fileName;
  final int? size;
  FileMsg({required this.fileKey, this.fileName, this.size});
  factory FileMsg.fromJson(Map<String, dynamic> json) => FileMsg(
    fileKey: json['fileKey'] ?? '',
    fileName: json['fileName'],
    size: json['size'],
  );
  Map<String, dynamic> toJson() => {
    'fileKey': fileKey,
    'fileName': fileName,
    'size': size,
  };
}

class VoiceMsg {
  final String fileKey;
  final int? duration;
  VoiceMsg({required this.fileKey, this.duration});
  factory VoiceMsg.fromJson(Map<String, dynamic> json) =>
      VoiceMsg(fileKey: json['fileKey'] ?? '', duration: json['duration']);
  Map<String, dynamic> toJson() => {'fileKey': fileKey, 'duration': duration};
}

class EmojiMsg {
  final String fileKey;
  final String emojiId;
  final String packageId;
  final int? width;
  final int? height;
  EmojiMsg({
    required this.fileKey,
    required this.emojiId,
    required this.packageId,
    this.width,
    this.height,
  });
  factory EmojiMsg.fromJson(Map<String, dynamic> json) => EmojiMsg(
    fileKey: json['fileKey'] ?? '',
    emojiId: json['emojiId'] ?? '',
    packageId: json['packageId'] ?? '',
    width: json['width'],
    height: json['height'],
  );
  Map<String, dynamic> toJson() => {
    'fileKey': fileKey,
    'emojiId': emojiId,
    'packageId': packageId,
    if (width != null) 'width': width,
    if (height != null) 'height': height,
  };
}

class AudioFileMsg {
  final String fileKey;
  final String? fileName;
  final int? size;
  AudioFileMsg({required this.fileKey, this.fileName, this.size});
  factory AudioFileMsg.fromJson(Map<String, dynamic> json) => AudioFileMsg(
    fileKey: json['fileKey'] ?? '',
    fileName: json['fileName'],
    size: json['size'],
  );
  Map<String, dynamic> toJson() => {
    'fileKey': fileKey,
    'fileName': fileName,
    'size': size,
  };
}

class ReplyMsg {
  final String originMsgId;
  final MessageContentModel? replyMsg;
  ReplyMsg({required this.originMsgId, this.replyMsg});
  factory ReplyMsg.fromJson(Map<String, dynamic> json) => ReplyMsg(
    originMsgId: json['originMsgId'] ?? '',
    replyMsg: json['replyMsg'] != null
        ? MessageContentModel.fromJson(json['replyMsg'])
        : null,
  );
  Map<String, dynamic> toJson() => {
    'originMsgId': originMsgId,
    'replyMsg': replyMsg?.toJson(),
  };
}

class ForwardMsg {
  final String title;
  final String recordId;
  final int count;
  ForwardMsg({
    required this.title,
    required this.recordId,
    required this.count,
  });
  factory ForwardMsg.fromJson(Map<String, dynamic> json) => ForwardMsg(
    title: json['title'] ?? '',
    recordId: json['recordId'] ?? '',
    count: json['count'] ?? 0,
  );
  Map<String, dynamic> toJson() => {
    'title': title,
    'recordId': recordId,
    'count': count,
  };
}

class ChatMessageSendBody {
  final String conversationId;
  final String messageId;
  final MessageContentModel msg;
  final String chatType; // 'private' | 'group'

  ChatMessageSendBody({
    required this.conversationId,
    required this.messageId,
    required this.msg,
    required this.chatType,
  });

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'messageId': messageId,
      'msg': msg.toJson(),
      'chatType': chatType,
    };
  }
}

/// 消息模型 (UI格式)
class MessageModel {
  final String id;
  final String conversationId;
  final String userId;
  final String? nickname;
  final String? avatar;
  final MessageContentModel msg;
  final MessageType type;
  final MessageStatus status;
  final DateTime createdAt;
  final bool isSent;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.userId,
    this.nickname,
    this.avatar,
    required this.msg,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.isSent,
  });

  // For compatibility during transition, we keep content getter if needed
  String get content {
    if (type == MessageType.text) return msg.textMsg?.content ?? '';
    return '[Type: ${type.name}]';
  }

  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? userId,
    String? nickname,
    String? avatar,
    MessageContentModel? msg,
    MessageType? type,
    MessageStatus? status,
    DateTime? createdAt,
    bool? isSent,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      msg: msg ?? this.msg,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isSent: isSent ?? this.isSent,
    );
  }
}

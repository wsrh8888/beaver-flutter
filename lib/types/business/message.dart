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
  markdown, // 13
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
  Future<void> clearHistory(String conversationId);
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
  final NotificationMsg? notificationMsg;
  final MarkdownMsg? markdownMsg;

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
    this.notificationMsg,
    this.markdownMsg,
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
      notificationMsg: json['notificationMsg'] != null
          ? NotificationMsg.fromJson(json['notificationMsg'])
          : null,
      markdownMsg: json['markdownMsg'] != null
          ? MarkdownMsg.fromJson(json['markdownMsg'])
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
      'notificationMsg': notificationMsg?.toJson(),
      'markdownMsg': markdownMsg?.toJson(),
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
      case MessageType.markdown:
        return 13;
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
      case 13:
        return MessageType.markdown;
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
  final String fileUrl;
  final double? width;
  final double? height;
  final int? size;
  ImageMsg({required this.fileUrl, this.width, this.height, this.size});
  factory ImageMsg.fromJson(Map<String, dynamic> json) => ImageMsg(
    fileUrl: json['fileUrl']?.toString() ?? '',
    width: (json['width'] as num?)?.toDouble(),
    height: (json['height'] as num?)?.toDouble(),
    size: json['size'],
  );
  Map<String, dynamic> toJson() => {
    'fileUrl': fileUrl,
    if (width != null) 'width': width,
    if (height != null) 'height': height,
    if (size != null) 'size': size,
  };
}

class VideoMsg {
  final String fileUrl;
  final String? thumbnailUrl;
  final double? width;
  final double? height;
  final int? duration;
  VideoMsg({
    required this.fileUrl,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.duration,
  });
  factory VideoMsg.fromJson(Map<String, dynamic> json) => VideoMsg(
    fileUrl: json['fileUrl']?.toString() ?? '',
    thumbnailUrl: json['thumbnailUrl']?.toString(),
    width: (json['width'] as num?)?.toDouble(),
    height: (json['height'] as num?)?.toDouble(),
    duration: json['duration'],
  );
  Map<String, dynamic> toJson() => {
    'fileUrl': fileUrl,
    if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
    if (width != null) 'width': width,
    if (height != null) 'height': height,
    if (duration != null) 'duration': duration,
  };
}

class FileMsg {
  final String fileUrl;
  final String? fileName;
  final int? size;
  FileMsg({required this.fileUrl, this.fileName, this.size});
  factory FileMsg.fromJson(Map<String, dynamic> json) => FileMsg(
    fileUrl: json['fileUrl']?.toString() ?? '',
    fileName: json['fileName'],
    size: json['size'],
  );
  Map<String, dynamic> toJson() => {
    'fileUrl': fileUrl,
    if (fileName != null) 'fileName': fileName,
    if (size != null) 'size': size,
  };
}

class VoiceMsg {
  final String fileUrl;
  final int? duration;
  VoiceMsg({required this.fileUrl, this.duration});
  factory VoiceMsg.fromJson(Map<String, dynamic> json) => VoiceMsg(
    fileUrl: json['fileUrl']?.toString() ?? '',
    duration: json['duration'],
  );
  Map<String, dynamic> toJson() => {
        'fileUrl': fileUrl,
        if (duration != null) 'duration': duration,
      };
}

class EmojiMsg {
  final String fileUrl;
  final String emojiId;
  final String packageId;
  final int? width;
  final int? height;
  EmojiMsg({
    required this.fileUrl,
    required this.emojiId,
    required this.packageId,
    this.width,
    this.height,
  });
  factory EmojiMsg.fromJson(Map<String, dynamic> json) => EmojiMsg(
    fileUrl: json['fileUrl']?.toString() ?? '',
    emojiId: json['emojiId'] ?? '',
    packageId: json['packageId'] ?? '',
    width: json['width'],
    height: json['height'],
  );
  Map<String, dynamic> toJson() => {
    'fileUrl': fileUrl,
    'emojiId': emojiId,
    'packageId': packageId,
    if (width != null) 'width': width,
    if (height != null) 'height': height,
  };
}

class AudioFileMsg {
  final String fileUrl;
  final String? fileName;
  final int? size;
  AudioFileMsg({required this.fileUrl, this.fileName, this.size});
  factory AudioFileMsg.fromJson(Map<String, dynamic> json) => AudioFileMsg(
    fileUrl: json['fileUrl']?.toString() ?? '',
    fileName: json['fileName'],
    size: json['size'],
  );
  Map<String, dynamic> toJson() => {
    'fileUrl': fileUrl,
    if (fileName != null) 'fileName': fileName,
    if (size != null) 'size': size,
  };
}

class ReplyMsg {
  final String originMsgId;
  final MessageContentModel? originMsg;
  final MessageContentModel? replyMsg;
  ReplyMsg({
    required this.originMsgId,
    this.originMsg,
    this.replyMsg,
  });
  factory ReplyMsg.fromJson(Map<String, dynamic> json) => ReplyMsg(
    originMsgId: json['originMsgId'] ?? '',
    originMsg: json['originMsg'] != null
        ? MessageContentModel.fromJson(json['originMsg'])
        : null,
    replyMsg: json['replyMsg'] != null
        ? MessageContentModel.fromJson(json['replyMsg'])
        : null,
  );
  Map<String, dynamic> toJson() => {
    'originMsgId': originMsgId,
    if (originMsg != null) 'originMsg': originMsg!.toJson(),
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

class NotificationMsg {
  final int type;
  final List<String> actors;
  NotificationMsg({required this.type, required this.actors});
  factory NotificationMsg.fromJson(Map<String, dynamic> json) =>
      NotificationMsg(
        type: json['type'] ?? 0,
        actors: List<String>.from(json['actors'] ?? []),
      );
  Map<String, dynamic> toJson() => {'type': type, 'actors': actors};
}

class MarkdownMsg {
  final String content;
  final String? title;

  MarkdownMsg({required this.content, this.title});

  factory MarkdownMsg.fromJson(Map<String, dynamic> json) => MarkdownMsg(
        content: json['content'] ?? '',
        title: json['title'],
      );

  Map<String, dynamic> toJson() => {
        'content': content,
        if (title != null) 'title': title,
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
  final bool isEdited;

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
    this.isEdited = false,
  });

  // For compatibility during transition, we keep content getter if needed
  String get content {
    if (type == MessageType.text) return msg.textMsg?.content ?? '';
    if (type == MessageType.markdown) return msg.markdownMsg?.content ?? '';
    if (type == MessageType.reply) {
      return msg.replyMsg?.replyMsg?.textMsg?.content ?? '[回复]';
    }
    return '[Type: ${type.name}]';
  }

  /// 消息预览文案（引用条等场景）
  String get previewText {
    switch (type) {
      case MessageType.text:
        return msg.textMsg?.content ?? '[文本]';
      case MessageType.markdown:
        return msg.markdownMsg?.content ?? '[Markdown]';
      case MessageType.image:
        return '[图片]';
      case MessageType.video:
        return '[视频]';
      case MessageType.file:
        return msg.fileMsg?.fileName ?? '[文件]';
      case MessageType.voice:
        return '[语音]';
      case MessageType.audio:
        return msg.audioFileMsg?.fileName ?? '[音频]';
      case MessageType.emoji:
        return '[表情]';
      case MessageType.reply:
        return msg.replyMsg?.replyMsg?.textMsg?.content ??
            msg.replyMsg?.originMsg?.textMsg?.content ??
            '[回复]';
      default:
        return content;
    }
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
    bool? isEdited,
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
      isEdited: isEdited ?? this.isEdited,
    );
  }
}

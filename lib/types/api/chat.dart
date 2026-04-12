/// 同步聊天消息请求
class IChatSyncReq {
  final String conversationId;
  final int fromSeq;
  final int toSeq;
  final int limit;

  IChatSyncReq({
    required this.conversationId,
    required this.fromSeq,
    required this.toSeq,
    required this.limit,
  });

  Map<String, dynamic> toJson() => {
    'conversationId': conversationId,
    'fromSeq': fromSeq,
    'toSeq': toSeq,
    'limit': limit,
  };
}

/// 消息发送者简要信息
class IMessageSender {
  final String nickName;
  final String? avatar;

  IMessageSender({required this.nickName, this.avatar});

  factory IMessageSender.fromJson(Map<String, dynamic> json) => IMessageSender(
        nickName: json['nickName'] ?? (json['nickname'] ?? '用户'),
        avatar: json['avatar'],
      );
}

/// 消息项
class IChatMessageItem {
  final String messageId;
  final String conversationId;
  final int conversationType;
  final String sendUserId;
  final int msgType;
  final String? targetMessageId;
  final String msgPreview;
  final String msg;
  final int seq;
  final int createdAt;
  final IMessageSender sender; // 新增发送者信息

  IChatMessageItem({
    required this.messageId,
    required this.conversationId,
    required this.conversationType,
    required this.sendUserId,
    required this.msgType,
    this.targetMessageId,
    required this.msgPreview,
    required this.msg,
    required this.seq,
    required this.createdAt,
    required this.sender,
  });

  factory IChatMessageItem.fromJson(Map<String, dynamic> json) =>
      IChatMessageItem(
        messageId: json['messageId'] ?? '',
        conversationId: json['conversationId'] ?? '',
        conversationType: json['conversationType'] ?? 0,
        sendUserId: json['sendUserId'] ?? '',
        msgType: json['msgType'] ?? 0,
        targetMessageId: json['targetMessageId'],
        msgPreview: json['msgPreview'] ?? '',
        msg: json['msg'] ?? '',
        seq: json['seq'] ?? 0,
        createdAt: json['createdAt'] ?? 0,
        sender: IMessageSender.fromJson(json['sender'] ?? {}),
      );
}

/// 同步聊天消息响应
class IChatSyncRes {
  final List<IChatMessageItem> messages;

  IChatSyncRes({required this.messages});

  factory IChatSyncRes.fromJson(Map<String, dynamic> json) => IChatSyncRes(
    messages:
        (json['messages'] as List?)
            ?.map((e) => IChatMessageItem.fromJson(e))
            .toList() ??
        [],
  );
}

/// 会话元数据项
class IConversationItem {
  final String conversationId;
  final int conversationType;
  final String? title;
  final String? avatar;
  final int maxSeq;
  final String? lastMessage;
  final int version;
  final int createdAt;
  final int updatedAt;

  IConversationItem({
    required this.conversationId,
    required this.conversationType,
    this.title,
    this.avatar,
    required this.maxSeq,
    this.lastMessage,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IConversationItem.fromJson(Map<String, dynamic> json) =>
      IConversationItem(
        conversationId: json['conversationId'] ?? '',
        conversationType: json['conversationType'] ?? (json['type'] ?? 0),
        title: json['title'],
        avatar: json['avatar'],
        maxSeq: json['maxSeq'] ?? 0,
        lastMessage: json['lastMessage'],
        version: json['version'] ?? 0,
        createdAt: json['createdAt'] ?? 0,
        updatedAt: json['updatedAt'] ?? 0,
      );
}

/// 批量获取会话请求
class IGetConversationsListByIdsReq {
  final List<String> conversationIds;

  IGetConversationsListByIdsReq({required this.conversationIds});

  Map<String, dynamic> toJson() => {'conversationIds': conversationIds};
}

/// 批量获取会话响应
class IGetConversationsListByIdsRes {
  final List<IConversationItem> conversations;

  IGetConversationsListByIdsRes({required this.conversations});

  factory IGetConversationsListByIdsRes.fromJson(Map<String, dynamic> json) =>
      IGetConversationsListByIdsRes(
        conversations:
            (json['conversations'] as List?)
                ?.map((e) => IConversationItem.fromJson(e))
                .toList() ??
            [],
      );
}

/// 用户会话设置项
class IUserConversationSettingItem {
  final String userId;
  final String conversationId;
  final bool isHidden;
  final bool isPinned;
  final bool? isTop; // 兼容字段
  final bool isMuted;
  final int userReadSeq;
  final int version;
  final int createdAt;
  final int updatedAt;

  IUserConversationSettingItem({
    required this.userId,
    required this.conversationId,
    required this.isHidden,
    required this.isPinned,
    this.isTop,
    required this.isMuted,
    required this.userReadSeq,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IUserConversationSettingItem.fromJson(Map<String, dynamic> json) =>
      IUserConversationSettingItem(
        userId: json['userId'] ?? '',
        conversationId: json['conversationId'] ?? '',
        isHidden: json['isHidden'] ?? false,
        isPinned: json['isPinned'] ?? json['isTop'] ?? false,
        isTop: json['isTop'],
        isMuted: json['isMuted'] ?? false,
        userReadSeq: json['userReadSeq'] ?? 0,
        version: json['version'] ?? 0,
        createdAt: json['createdAt'] ?? 0,
        updatedAt: json['updatedAt'] ?? 0,
      );
}

/// 批量获取用户会话设置请求
class IGetUserConversationSettingsListByIdsReq {
  final List<String> conversationIds;

  IGetUserConversationSettingsListByIdsReq({required this.conversationIds});

  Map<String, dynamic> toJson() => {'conversationIds': conversationIds};
}

/// 批量获取用户会话设置响应
class IGetUserConversationSettingsListByIdsRes {
  final List<IUserConversationSettingItem> userConversationSettings;

  IGetUserConversationSettingsListByIdsRes({
    required this.userConversationSettings,
  });

  factory IGetUserConversationSettingsListByIdsRes.fromJson(
    Map<String, dynamic> json,
  ) => IGetUserConversationSettingsListByIdsRes(
    userConversationSettings:
        (json['userConversationSettings'] as List?)
            ?.map((e) => IUserConversationSettingItem.fromJson(e))
            .toList() ??
        [],
  );
}

/// 更新已读序列号请求
class IUpdateReadSeqReq {
  final String conversationId;
  final int readSeq;

  IUpdateReadSeqReq({required this.conversationId, required this.readSeq});

  Map<String, dynamic> toJson() => {
    'conversationId': conversationId,
    'readSeq': readSeq,
  };
}

/// 更新已读序列号响应
class IUpdateReadSeqRes {
  final bool success;

  IUpdateReadSeqRes({required this.success});

  factory IUpdateReadSeqRes.fromJson(Map<String, dynamic> json) =>
      IUpdateReadSeqRes(success: json['success'] ?? (json['code'] == 0));
}

/// 置顶会话请求
class IPinnedChatReq {
  final String conversationId;
  final bool isPinned;

  IPinnedChatReq({required this.conversationId, required this.isPinned});

  Map<String, dynamic> toJson() => {
    'conversationId': conversationId,
    'isPinned': isPinned,
  };
}

/// 置顶会话响应
class IPinnedChatRes {
  final bool success;

  IPinnedChatRes({required this.success});

  factory IPinnedChatRes.fromJson(Map<String, dynamic> json) =>
      IPinnedChatRes(success: json['success'] ?? (json['code'] == 0));
}

/// 获取合并转发详情请求
class IGetForwardDetailsReq {
  final String recordId;

  IGetForwardDetailsReq({required this.recordId});

  Map<String, dynamic> toJson() => {'recordId': recordId};
}

/// 获取合并转发详情响应
class IGetForwardDetailsRes {
  final String title;
  final List<IChatMessageItem> list;

  IGetForwardDetailsRes({required this.title, required this.list});

  factory IGetForwardDetailsRes.fromJson(Map<String, dynamic> json) =>
      IGetForwardDetailsRes(
        title: json['title'] ?? '聊天记录',
        list: (json['list'] as List?)
            ?.map((e) => IChatMessageItem.fromJson(e))
            .toList() ?? [],
      );
}

/// 转发消息请求
class IForwardMessageReq {
  final List<String> messageIds; // 要转发的消息ID列表
  final String targetId; // 目标会话ID
  final int forwardMode; // 1:逐条转发 2:合并转发
  final int forwardType; // 1:单聊 2:群聊

  IForwardMessageReq({
    required this.messageIds,
    required this.targetId,
    required this.forwardMode,
    required this.forwardType,
  });

  Map<String, dynamic> toJson() => {
        'messageIds': messageIds,
        'targetId': targetId,
        'forwardMode': forwardMode,
        'forwardType': forwardType,
      };
}

/// 转发消息响应
class IForwardMessageRes {
  final String? messageId; // 合并转发时返回的新消息ID

  IForwardMessageRes({this.messageId});

  factory IForwardMessageRes.fromJson(Map<String, dynamic> json) =>
      IForwardMessageRes(messageId: json['messageId']);
}

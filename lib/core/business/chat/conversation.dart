import 'dart:async';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/api/chat.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/chat.dart';
import 'package:beaver/core/business/chat/user_conversation.dart';
import 'package:drift/drift.dart';

class ConversationBusiness implements ConversationRepositoryInterface {
  final _conversationService = getIt<ChatConversationService>();
  final _messageService = getIt<ChatMessageService>();
  final _userConversationService = getIt<ChatUserConversationService>();
  final _friendService = getIt<FriendService>();
  final _groupService = getIt<GroupService>();
  final _userService = getIt<UserService>();

  // 响应式数据流 (对标 PC 的 Notification 机制)
  final _conversationUpdateController = StreamController<void>.broadcast();
  Stream<void> get conversationUpdateStream =>
      _conversationUpdateController.stream;

  void notifyConversationUpdate() {
    _conversationUpdateController.add(null);
  }

  @override
  Future<List<ChatModel>> getChatList() async {
    final currentUserId = DatabaseManager.currentUserId ?? '';
    if (currentUserId.isEmpty) {
      return [];
    }

    // 1) user_conversation: filter hidden
    final userConversations = await _userConversationService.getByUserId(
      currentUserId,
    );
    final visibleUserConversations = userConversations
        .where((uc) => uc.isHidden == 0)
        .toList();

    if (visibleUserConversations.isEmpty) {
      return [];
    }

    // 2) conversation metas
    final conversationIds = visibleUserConversations
        .map((uc) => uc.conversationId)
        .toList();
    final conversationMetas = await _conversationService.getConversationsByIds(
      conversationIds,
    );
    final metaMap = {
      for (final meta in conversationMetas) meta.conversationId: meta,
    };

    // 3) merge + sort (isPinned first, then updatedAt desc)
    final merged = <_MergedConversation>[];
    for (final uc in visibleUserConversations) {
      final meta = metaMap[uc.conversationId];
      if (meta == null) {
        continue;
      }
      merged.add(_MergedConversation(meta: meta, setting: uc));
    }

    merged.sort((a, b) {
      if (a.setting.isPinned != b.setting.isPinned) {
        return b.setting.isPinned.compareTo(a.setting.isPinned);
      }
      return (b.meta.updatedAt ?? 0).compareTo(a.meta.updatedAt ?? 0);
    });

    // 4) collect private peer ids + group ids by conversationId
    final privatePeerIds = <String>{};
    final groupIds = <String>{};
    for (final item in merged) {
      if (_isPrivateConversation(item.meta.conversationId)) {
        final peerId = _parsePrivatePeerId(
          item.meta.conversationId,
          currentUserId,
        );
        if (peerId != null && peerId.isNotEmpty) {
          privatePeerIds.add(peerId);
        }
      } else if (_isGroupConversation(item.meta.conversationId)) {
        final groupId = _parseGroupId(item.meta.conversationId);
        if (groupId != null && groupId.isNotEmpty) {
          groupIds.add(groupId);
        }
      }
    }

    // private: friend relation + user basic info
    final friendDetailsMap = <String, _FriendDetail>{};
    if (privatePeerIds.isNotEmpty) {
      final allFriends = await _friendService.getFriends();
      final relatedFriends = allFriends.where((f) {
        final isMine =
            f.sendUserId == currentUserId || f.revUserId == currentUserId;
        if (!isMine) return false;
        final peerId = f.sendUserId == currentUserId
            ? f.revUserId
            : f.sendUserId;
        return privatePeerIds.contains(peerId);
      }).toList();

      final userInfos = await _userService.getUsersBasicInfo(
        privatePeerIds.toList(),
      );
      final userMap = {
        for (final u in userInfos) (u['userId']?.toString() ?? ''): u,
      };

      for (final friend in relatedFriends) {
        final peerId = friend.sendUserId == currentUserId
            ? friend.revUserId
            : friend.sendUserId;
        final notice = friend.sendUserId == currentUserId
            ? (friend.revUserNotice ?? '')
            : (friend.sendUserNotice ?? '');
        final user = userMap[peerId];
        friendDetailsMap[peerId] = _FriendDetail(
          userId: peerId,
          nickname: user?['nickName']?.toString() ?? '',
          avatar: user?['avatar']?.toString() ?? '',
          notice: notice,
        );
      }
    }

    // group details
    final groupMap = <String, Group>{};
    if (groupIds.isNotEmpty) {
      final groups = await _groupService.getGroupsByIds(groupIds.toList());
      for (final group in groups) {
        groupMap[group.groupId] = group;
      }
    }

    // 5) render mapping
    final list = <ChatModel>[];
    for (final item in merged) {
      final conversationId = item.meta.conversationId;
      var avatar = item.meta.avatar ?? '';
      var nickname = item.meta.title ?? '';

      if (_isPrivateConversation(conversationId)) {
        final peerId = _parsePrivatePeerId(conversationId, currentUserId);
        if (peerId != null) {
          final fd = friendDetailsMap[peerId];
          if (fd != null) {
            avatar = fd.avatar;
            nickname = fd.notice.isNotEmpty ? fd.notice : fd.nickname;
          } else if (nickname.isEmpty) {
            nickname = peerId;
          }
        }
      } else if (_isGroupConversation(conversationId)) {
        final groupId = _parseGroupId(conversationId);
        final group = groupId == null ? null : groupMap[groupId];
        if (group != null) {
          avatar = group.avatar;
          nickname = group.title;
        }
      }

      final updatedAt = item.meta.updatedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(item.meta.updatedAt! * 1000);
      final msgPreview = await _resolveLatestPreview(
        conversationId,
        item.meta.lastMessage,
      );
      final unreadCount = _computeUnread(
        item.meta.maxSeq,
        item.setting.userReadSeq,
      );

      list.add(
        ChatModel(
          conversationId: conversationId,
          nickname: nickname,
          avatar: avatar,
          msgPreview: msgPreview,
          updateAt: _formatTime(updatedAt),
          isTop: item.setting.isPinned == 1,
          isMuted: item.setting.isMuted == 1,
          unreadCount: unreadCount,
        ),
      );
    }

    return list;
  }

  @override
  Future<void> markAsRead(String conversationId) async => getIt<UserConversationBusiness>().markAsRead(conversationId);

  @override
  Future<void> togglePinChat(String conversationId, bool isPinned) async => getIt<UserConversationBusiness>().togglePinChat(conversationId, isPinned);

  @override
  Future<void> toggleMuteChat(String conversationId, bool isMuted) async => getIt<UserConversationBusiness>().toggleMuteChat(conversationId, isMuted);

  @override
  Future<void> deleteChat(String conversationId) async {
    await _conversationService.deleteConversation(conversationId);
    await _userConversationService.delete(conversationId);
  }

  Future<String> _resolveLatestPreview(
    String conversationId,
    String? conversationLastMessage,
  ) async {
    if (conversationLastMessage != null && conversationLastMessage.isNotEmpty) {
      return conversationLastMessage;
    }

    final latest = await _messageService.getChatHistory(
      conversationId,
      limit: 1,
    );
    if (latest.isEmpty) {
      return '';
    }
    return latest.first.msgPreview ?? '';
  }

  int _computeUnread(int maxSeq, int userReadSeq) {
    final unread = maxSeq - userReadSeq;
    return unread > 0 ? unread : 0;
  }

  bool _isPrivateConversation(String conversationId) {
    return conversationId.startsWith('private_');
  }

  bool _isGroupConversation(String conversationId) {
    return conversationId.startsWith('group_');
  }

  String? _parsePrivatePeerId(String conversationId, String currentUserId) {
    final parts = conversationId.split('_');
    if (parts.length < 3) return null;
    final userId1 = parts[1];
    final userId2 = parts[2];

    if (userId1 == currentUserId) return userId2;
    if (userId2 == currentUserId) return userId1;
    return userId1;
  }

  String? _parseGroupId(String conversationId) {
    final parts = conversationId.split('_');
    if (parts.length < 2 || parts.first != 'group') return null;
    return parts.sublist(1).join('_');
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (date == today.subtract(const Duration(days: 1))) {
      return '昨天';
    } else if (now.difference(dateTime).inDays < 7) {
      const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
      return weekdays[dateTime.weekday - 1];
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }

  @override
  Future<ChatModel?> getConversation(String conversationId) async {
    final currentUserId = DatabaseManager.currentUserId ?? '';
    if (currentUserId.isEmpty) return null;

    final meta = await _conversationService.getConversationById(conversationId);
    if (meta == null) return null;

    final setting = await _userConversationService.getByConversationId(
      conversationId,
    );

    var avatar = meta.avatar ?? '';
    var nickname = meta.title ?? '';

    if (_isPrivateConversation(conversationId)) {
      final peerId = _parsePrivatePeerId(conversationId, currentUserId);
      if (peerId != null) {
        final friend = await _friendService.getFriendByPeerId(
          currentUserId,
          peerId,
        );
        final userInfos = await _userService.getUsersBasicInfo([peerId]);
        final user = userInfos.isNotEmpty ? userInfos.first : null;

        if (friend != null) {
          final notice = friend.sendUserId == currentUserId
              ? (friend.revUserNotice ?? '')
              : (friend.sendUserNotice ?? '');
          nickname = notice.isNotEmpty
              ? notice
              : (user?['nickName']?.toString() ?? peerId);
        } else {
          nickname = user?['nickName']?.toString() ?? peerId;
        }
        avatar = user?['avatar']?.toString() ?? '';
      }
    } else if (_isGroupConversation(conversationId)) {
      final groupId = _parseGroupId(conversationId);
      final groups = groupId == null
          ? <Group>[]
          : await _groupService.getGroupsByIds([groupId]);
      if (groups.isNotEmpty) {
        avatar = groups.first.avatar.isEmpty
            ? 'assets/images/friend/group.svg'
            : groups.first.avatar;
        nickname = groups.first.title;
      } else {
        avatar = 'assets/images/friend/group.svg';
      }
    }

    final updatedAt = meta.updatedAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(meta.updatedAt! * 1000);
    final unreadCount = _computeUnread(meta.maxSeq, setting?.userReadSeq ?? 0);

    return ChatModel(
      conversationId: conversationId,
      nickname: nickname,
      avatar: avatar,
      msgPreview: meta.lastMessage ?? '',
      updateAt: _formatTime(updatedAt),
      isTop: setting?.isPinned == 1,
      isMuted: setting?.isMuted == 1,
      unreadCount: unreadCount,
    );
  }

  /**
   * 按版本号同步会话元数据 (对标 PC syncConversationByVersion)
   */
  Future<void> syncConversationByVersion(
    String conversationId,
    int version,
  ) async {
    try {
      final response = await getConversationsListByIdsApi(
        IGetConversationsListByIdsReq(conversationIds: [conversationId]),
      );

      if (response.code == 0 && response.result != null) {
        final items = response.result!.conversations;
        for (final item in items) {
          await _conversationService.upsert(
            ChatConversationsCompanion(
              conversationId: Value(item.conversationId),
              type: Value(item.conversationType),
              title: Value(item.title),
              avatar: Value(item.avatar),
              maxSeq: Value(item.maxSeq),
              lastMessage: Value(item.lastMessage),
              version: Value(item.version),
              updatedAt: Value(
                item.updatedAt > 0
                    ? item.updatedAt
                    : DateTime.now().millisecondsSinceEpoch ~/ 1000,
              ),
            ),
          );
        }
        // 同步成功后刷新 UI
        notifyConversationUpdate();
      }
    } catch (e) {
    }
  }

  @override
  Future<void> syncUserConversationByVersion(
    String userId,
    String conversationId,
    int version,
  ) async => getIt<UserConversationBusiness>().syncUserConversationByVersion(userId, conversationId, version);

  @override
  Future<String?> getConversationIdByPeerId(String peerId) async {
    final currentUserId = DatabaseManager.currentUserId ?? '';
    if (currentUserId.isEmpty) return null;

    final userConversations = await _userConversationService.getByUserId(currentUserId);
    for (final uc in userConversations) {
      if (_isPrivateConversation(uc.conversationId)) {
        final pId = _parsePrivatePeerId(uc.conversationId, currentUserId);
        if (pId == peerId) {
          return uc.conversationId;
        }
      }
    }
    
    // Fallback: 按照约定的 private_minId_maxId 格式生成
    // 注意：这里需要根据服务端和 desktop 端的统一规则生成
    // 假设规则是 private_ 拼接排序后的两个 ID
    final ids = [currentUserId, peerId]..sort();
    return 'private_${ids[0]}_${ids[1]}';
  }
}

class _MergedConversation {
  final ChatConversation meta;
  final ChatUserConversation setting;

  const _MergedConversation({required this.meta, required this.setting});
}

class _FriendDetail {
  final String userId;
  final String nickname;
  final String avatar;
  final String notice;

  const _FriendDetail({
    required this.userId,
    required this.nickname,
    required this.avatar,
    required this.notice,
  });
}

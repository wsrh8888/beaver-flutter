import 'package:beaver/api/chat.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/core/business/chat/message.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/shared/utils/storage_util.dart';
import 'package:drift/drift.dart';

/// 消息同步器 - 负责同步聊天消息数据
class MessageSync {
  /// 检查并同步消息数据
  Future<void> checkAndSync() async {
    final userId = StorageUtil.getString('userId');
    if (userId == null || userId.isEmpty) return;

    try {
      final datasyncService = getIt<DatasyncService>();
      final syncStatusService = getIt<ChatSyncStatusService>();

      // 获取本地最后同步时间
      final localCursor = await datasyncService.get('chat_messages');
      final lastSyncTime = localCursor?.version ?? 0;

      // 获取服务器上变更的消息版本信息
      final response = await datasyncGetSyncChatMessagesApi(IGetSyncChatMessagesReq(since: lastSyncTime));
      if (response.code != 0 || response.result == null) {
        // print('[MessageSync] 获取消息摘要失败: ${response.msg}');
        return;
      }

      // 对比本地数据，过滤出需要同步消息的会话
      final needSyncConversations = await _compareAndFilterMessageVersions(
        syncStatusService,
        response.result!.messageVersions,
      );

      if (needSyncConversations.isNotEmpty) {
        // 有需要同步消息的会话
        await _syncMessagesForConversations(needSyncConversations);
      }

      // 更新游标（无论是否有变更都要更新）
      await datasyncService.upsert(
        'chat_messages',
        -1, // 使用时间戳而不是版本号
        response.result!.serverTimestamp,
      );
    } catch (error) {
      print('[MessageSync] 消息同步失败: $error');
    }
  }

  /// 对比本地数据，过滤出需要同步消息的会话
  Future<List<_ConversationSeqItem>> _compareAndFilterMessageVersions(
    ChatSyncStatusService syncStatusService,
    List<IChatMessageVersionItem> messageVersions,
  ) async {
    if (messageVersions.isEmpty) return [];

    // 按会话分组获取服务器的最大 seq
    final serverConversationMap = <String, int>{};
    for (final item in messageVersions) {
      final currentSeq = serverConversationMap[item.conversationId] ?? 0;
      if (item.seq > currentSeq) {
        serverConversationMap[item.conversationId] = item.seq;
      }
    }

    final conversationIds = serverConversationMap.keys.toList();
    // 批量查询本地消息同步状态
    final localVersions = await syncStatusService.getModuleVersions('message', conversationIds);
    final localVersionMap = {for (var v in localVersions) v.conversationId: v.seq};

    final List<_ConversationSeqItem> needSyncConversations = [];
    serverConversationMap.forEach((conversationId, serverSeq) {
      final localSeq = localVersionMap[conversationId] ?? 0;
      if (serverSeq > localSeq) {
        needSyncConversations.add(_ConversationSeqItem(conversationId, serverSeq));
      }
    });

    return needSyncConversations;
  }

  /// 同步指定会话的消息数据
  Future<void> _syncMessagesForConversations(List<_ConversationSeqItem> conversationsWithSeq) async {
    final syncStatusService = getIt<ChatSyncStatusService>();

    for (final item in conversationsWithSeq) {
      // 获取本地消息同步状态
      final localSyncStatus = await syncStatusService.getSyncStatus('message', item.conversationId);
      final localSeq = localSyncStatus?.seq ?? 0;

      // 同步该会话的消息（从本地seq+1开始到服务器seq）
      await syncConversationMessages(
        item.conversationId,
        localSeq + 1,
        item.serverSeq,
      );

      // 更新消息同步状态
      await syncStatusService.upsertSyncStatus(
        module: 'message',
        conversationId: item.conversationId,
        seq: item.serverSeq,
      );
    }

    // TODO: 发送通知到渲染进程（在 Flutter 中可以通过 EventBus 或 Stream）
  }

  /// 同步单个会话的消息
  Future<void> syncConversationMessages(String conversationId, int fromSeq, int toSeq) async {
    try {
      await _doSyncConversationMessages(conversationId, fromSeq, toSeq);
    } catch (error) {
      print('[MessageSync] 消息同步失败: $error');
    }
  }

  /// 执行单个会话的消息同步
  Future<void> _doSyncConversationMessages(String conversationId, int fromSeq, int toSeq) async {
    final chatService = getIt<ChatMessageService>();
    final messageBusiness = getIt<MessageBusiness>();
    int currentSeq = fromSeq;

    while (currentSeq <= toSeq) {
      final response = await chatSyncApi(IChatSyncReq(
        conversationId: conversationId,
        fromSeq: currentSeq,
        toSeq: (currentSeq + 99 < toSeq) ? currentSeq + 99 : toSeq,
        limit: 100,
      ));

      if (response.code == 0 && response.result != null && response.result!.messages.isNotEmpty) {
        final messages = response.result!.messages.map((msg) => ChatsCompanion(
          messageId: Value(msg.messageId),
          conversationId: Value(msg.conversationId),
          conversationType: Value(msg.conversationType),
          sendUserId: Value(msg.sendUserId),
          msgType: Value(msg.msgType),
          targetMessageId: Value(msg.targetMessageId),
          msgPreview: Value(msg.msgPreview),
          msg: Value(msg.msg),
          seq: Value(msg.seq),
          sendStatus: const Value(1), // 已发送
          createdAt: Value(msg.createdAt),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch ~/ 1000),
        )).toList();

        await chatService.batchCreate(messages);

        // 清除正在发送消息的计时器 (ACK 确认)
        final syncedIds = messages.map((m) => m.messageId.value).toList();
        messageBusiness.clearTimers(syncedIds);

        currentSeq = (currentSeq + 99 < toSeq) ? currentSeq + 100 : toSeq + 1;
      } else {
        break;
      }
    }
  }
}

class _ConversationSeqItem {
  final String conversationId;
  final int serverSeq;
  _ConversationSeqItem(this.conversationId, this.serverSeq);
}

final messageSync = MessageSync();

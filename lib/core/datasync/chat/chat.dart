import 'package:beaver/api/chat.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/chat.dart' as chat_types;
import 'package:beaver/types/api/datasync.dart';

import 'package:beaver/core/datasync/chat/conversation.dart';
import 'package:beaver/core/datasync/chat/user_conversation.dart';

/// 消息同步
class MessageSync {
  Future<void> checkAndSync() async {
    print('[MessageSync] 开始同步消息及会话数据');

    // 1. 同步会话元数据
    await conversationMetaSync.checkAndSync();
    
    // 2. 同步消息正文 (基于 seq)
    await _syncMessageBody();

    // 3. 同步用户会话设置
    await userConversationSync.checkAndSync();

    print('[MessageSync] 消息及会话同步完成');
  }

  Future<void> _syncMessageBody() async {
    print('[MessageSync] 开始同步消息正文');
    
    final datasyncService = getIt<DatasyncService>();
    final syncStatusService = getIt<ChatSyncStatusService>();
    final chatService = getIt<ChatService>();

    // 1. 获取本地同步游标
    final cursor = await datasyncService.get('chat_messages');
    final lastSyncTime = cursor?.version ?? 0;

    // 2. 获取变更摘要
    final response = await datasyncGetSyncChatMessagesApi(IGetSyncChatMessagesReq(since: lastSyncTime));
    if (response.code != 0 || response.result == null) {
      print('[MessageSync] 获取消息摘要失败: ${response.msg}');
      return;
    }

    final serverTimestamp = response.result!.serverTimestamp;

    // 3. 对比过滤需要同步的会话
    final needSync = await _compareAndFilterMessageVersions(syncStatusService, response.result!.messageVersions);

    if (needSync.isNotEmpty) {
      // 4. 按会话逐个同步消息
      for (final item in needSync) {
        await _syncConversationMessages(chatService, syncStatusService, item.conversationId, item.serverSeq);
      }
    }

    // 5. 更新总游标
    await datasyncService.upsert('chat_messages', -1, serverTimestamp);
  }

  Future<List<_ConversationSeqItem>> _compareAndFilterMessageVersions(
    ChatSyncStatusService syncStatusService,
    List<IChatMessageVersionItem> serverVersions,
  ) async {
    if (serverVersions.isEmpty) return [];

    // 分组聚合服务器最大 seq
    final serverMaxMap = <String, int>{};
    for (final v in serverVersions) {
      final cur = serverMaxMap[v.conversationId] ?? 0;
      if (v.seq > cur) serverMaxMap[v.conversationId] = v.seq;
    }

    final conversationIds = serverMaxMap.keys.toList();
    final localVersions = await syncStatusService.getModuleVersions('message', conversationIds);
    final localMap = {for (var v in localVersions) v.conversationId: v.seq};

    final List<_ConversationSeqItem> result = [];
    serverMaxMap.forEach((convId, serverSeq) {
      final localSeq = localMap[convId] ?? 0;
      if (serverSeq > localSeq) {
        result.add(_ConversationSeqItem(convId, serverSeq));
      }
    });
    return result;
  }

  Future<void> _syncConversationMessages(
    ChatService chatService,
    ChatSyncStatusService syncStatusService,
    String conversationId,
    int serverSeq,
  ) async {
    final status = await syncStatusService.getSyncStatus('message', conversationId);
    int currentSeq = (status?.seq ?? 0) + 1;

    while (currentSeq <= serverSeq) {
      final response = await chatSyncApi(chat_types.IChatSyncReq(
        conversationId: conversationId,
        fromSeq: currentSeq,
        toSeq: serverSeq,
        limit: 100,
      ));

      if (response.code == 0 && response.result != null && response.result!.messages.isNotEmpty) {
        final messages = response.result!.messages;
        await chatService.batchCreateMessages(messages);
        
        currentSeq = messages.last.seq + 1;
        await syncStatusService.upsertSyncStatus(
          module: 'message',
          conversationId: conversationId,
          seq: messages.last.seq,
        );
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
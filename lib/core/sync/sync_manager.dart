import 'dart:async';
import 'package:beaver/core/database/database.dart';
import 'package:drift/drift.dart';

/// 全局数据同步管理器 (对标商业级 IM 增量同步流)
class SyncManager {
  static final SyncManager _instance = SyncManager._internal();
  static SyncManager get instance => _instance;

  SyncManager._internal();

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  // 消息同步缓冲区 (同步期间受到的 WS 消息暂存此处)
  final List<Map<String, dynamic>> _messageQueue = [];

  /// 启动全局增量同步
  Future<void> startIncrementalSync() async {
    if (_isSyncing) return;
    _isSyncing = true;
    print('[Sync] 开始增量拉取...');

    try {
      // 1. 获取本地数据库中最大的已同步 Seq
      final lastSeq = await _getLastLocalSeq();

      // 2. 向服务端请求差异数据 (例如 chat_sync_api?since=$lastSeq)
      // TODO: 这里根据 ApiClient 调用后端接口，暂用 Mock 表示过程
      await _mockBackendPull(lastSeq);

      // 3. 将本地队列消息排队落库 (防止同步期间收到的实时消息乱序)
      await _processPendingQueue();

      _isSyncing = false;
      print('[Sync] 增量同步完成');
    } catch (e) {
      _isSyncing = false;
      print('[Sync] 同步失败: $e');
    }
  }

  /// 同步期间实时接收到 WS 消息的回调
  void onIncomingWsMessage(Map<String, dynamic> msg) {
    if (_isSyncing) {
      print('[Sync] 同步进行中，消息进队列暂存');
      _messageQueue.add(msg);
    } else {
      // 正常落库 (Repository 层处理)
      _saveToDb(msg);
    }
  }

  /// 获取本地最大 Seq
  Future<int> _getLastLocalSeq() async {
    final db = DatabaseManager.instance;
    final lastMsg = await (db.select(db.chats)
          ..orderBy([(t) => OrderingTerm(expression: t.seq, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
    return lastMsg?.seq ?? 0;
  }

  /// 处理同步期间积累的队列
  Future<void> _processPendingQueue() async {
    if (_messageQueue.isEmpty) return;
    print('[Sync] 处理同步缓冲区中 ${_messageQueue.length} 条消息');

    for (var msg in _messageQueue) {
      _saveToDb(msg);
    }
    _messageQueue.clear();
  }

  /// 落地本地库 (简单示例)
  void _saveToDb(Map<String, dynamic> data) async {
    final db = DatabaseManager.instance;
    await db.into(db.chats).insert(
          ChatsCompanion.insert(
            messageId: data['messageId'] as String? ?? '',
            conversationId: data['conversationId'] as String? ?? '',
            senderId: data['senderId'] as String? ?? '',
            content: data['content'] as String? ?? '',
            type: Value(data['type'] as int? ?? 0),
            seq: Value(data['seq'] as int? ?? 0),
            createdAt: data['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
          ),
        );
  }

  // Mock
  Future<void> _mockBackendPull(int since) async {
    await Future.delayed(const Duration(seconds: 1)); // 模拟拉取耗时
  }
}

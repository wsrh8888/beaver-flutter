/// 队列项 (对标 desktop business/base/base.ts QueueItem)
abstract class QueueItem {
  String get key;
  dynamic get data;
  int get timestamp;
}

/// 批处理配置 (对标 desktop BusinessBatchConfig)
class BusinessBatchConfig {
  final int queueSizeLimit;
  final int delayMs;

  const BusinessBatchConfig({
    this.queueSizeLimit = 50,
    this.delayMs = 1000,
  });
}

/// 业务层基类：队列聚合 + 批量处理 (对标 desktop BaseBusiness<T>)
abstract class BaseBusiness<T extends QueueItem> {
  final List<T> _pendingQueue = [];
  final BusinessBatchConfig config;

  BaseBusiness([BusinessBatchConfig? config])
      : config = config ?? const BusinessBatchConfig();

  String get businessName;

  void addToQueue(T item) {
    _pendingQueue.add(item);
    if (_pendingQueue.length >= config.queueSizeLimit) {
      _processQueue();
    } else {
      Future.delayed(Duration(milliseconds: config.delayMs), () {
        if (_pendingQueue.isNotEmpty) _processQueue();
      });
    }
  }

  Future<void> _processQueue() async {
    if (_pendingQueue.isEmpty) return;
    final items = List<T>.from(_pendingQueue);
    _pendingQueue.clear();
    try {
      await processBatchRequests(items);
    } catch (e) {
      print('[$businessName] 批量处理失败: $e');
    }
  }

  Future<void> processBatchRequests(List<T> items);

  Map<String, dynamic> getQueueStatus() => {
        'queueLength': _pendingQueue.length,
        'businessName': businessName,
      };
}

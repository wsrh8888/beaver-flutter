import 'package:beaver/features/setting/feedback/data/models/feedback.dart';

class FeedbackRepository {
  Future<List<FeedbackType>> getFeedbackTypes() async {
    // 模拟获取反馈类型
    await Future.delayed(const Duration(seconds: 1));
    return [
      const FeedbackType(value: 1, label: '功能异常'),
      const FeedbackType(value: 2, label: '功能建议'),
      const FeedbackType(value: 3, label: '使用体验'),
      const FeedbackType(value: 4, label: '其他问题'),
    ];
  }

  Future<bool> submitFeedback({
    required int type,
    required String content,
    required List<UploadedImage> images,
  }) async {
    // 模拟提交反馈
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}


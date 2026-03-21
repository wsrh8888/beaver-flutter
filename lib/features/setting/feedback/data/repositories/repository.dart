import 'package:beaver/features/setting/feedback/data/models/feedback.dart';

class FeedbackRepository {
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


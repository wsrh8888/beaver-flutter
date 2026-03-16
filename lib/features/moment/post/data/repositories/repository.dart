import 'package:beaver/features/moment/post/data/models/post.dart';

class PostMomentRepository {
  Future<bool> createMoment(PostMomentRequest request) async {
    // 模拟发布动�?
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<String> uploadImage(String imagePath) async {
    // 模拟上传图片
    await Future.delayed(const Duration(seconds: 1));
    return 'https://neeko-copilot.bytedance.net/api/text2image?prompt=uploaded%20image&size=512x512';
  }
}


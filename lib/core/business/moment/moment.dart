import 'package:beaver/api/moment.dart';
import 'package:beaver/types/api/moment.dart';
import 'package:beaver/features/moment/post/data/models/post.dart';

/// 朋友圈业务逻辑
class MomentBusiness {
  /**
   * @description 获取朋友圈列表
   */
  Future<List<IMomentListItem>> getMomentList({required int page, int limit = 10}) async {
    final res = await getMomentListApi(IGetMomentListReq(page: page, limit: limit));
    if (res.code == 0 && res.result != null) {
      return res.result!.list;
    }
    return [];
  }

  /**
   * @description 点赞动态
   */
  Future<bool> likeMoment(String momentId, bool status) async {
    final res = await likeMomentApi(ILikeMomentReq(momentId: momentId, status: status));
    return res.code == 0;
  }

  /**
   * @description 发布朋友圈
   */
  Future<bool> createMoment(PostMomentRequest request) async {
    // 模拟发布动态
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /**
   * @description 上传图片
   */
  Future<String> uploadImage(String imagePath) async {
    // 模拟上传图片
    await Future.delayed(const Duration(seconds: 1));
    return 'https://neeko-copilot.bytedance.net/api/text2image?prompt=uploaded%20image&size=512x512';
  }
}

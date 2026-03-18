import 'package:beaver/api/moment.dart';
import 'package:beaver/types/api/moment.dart';

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
}

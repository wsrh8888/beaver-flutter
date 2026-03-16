import 'package:beaver/api/moment.dart';
import 'package:beaver/types/api/moment.dart';

class MomentListRepository {
  Future<List<IMomentListItem>> getMomentList(int page, int limit) async {
    try {
      final res = await getMomentListApi(IGetMomentListReq(page: page, limit: limit));
      if (res.code == 0 && res.result != null) {
        return res.result!.list;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> toggleLike(String momentId, bool status) async {
    try {
      final res = await likeMomentApi(ILikeMomentReq(momentId: momentId, status: status));
      return res.code == 0;
    } catch (e) {
      return false;
    }
  }
}

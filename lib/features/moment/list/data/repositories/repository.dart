import 'package:beaver/api/moment.dart';
import 'package:beaver/types/api/moment.dart';

class MomentListRepository {
  MomentListRepository();

  Future<List<IMomentListItem>> getMomentList(int page, int limit) async {
    final response = await getMomentListApi(IGetMomentListReq(page: page, limit: limit));
    if (response.isSuccess && response.result != null) {
      return response.result!.list;
    }
    return [];
  }

  Future<bool> toggleLike(String momentId, bool status) async {
    final response = await likeMomentApi(ILikeMomentReq(momentId: momentId, status: status));
    return response.isSuccess;
  }
}

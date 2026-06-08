import 'package:beaver/api/moment.dart';
import 'package:beaver/types/api/moment.dart';

class MomentDetailRepository {
  MomentDetailRepository();

  Future<IMomentListItem?> loadDetail(String momentId) async {
    final response = await getMomentDetailApi(
      IGetMomentDetailReq(momentId: momentId),
    );
    if (response.isSuccess && response.result != null) {
      return response.result;
    }
    return null;
  }

  Future<List<IMomentCommentModel>> loadRootComments(
    String momentId,
    int page,
    int limit,
  ) async {
    final response = await getMomentCommentsApi(
      IGetMomentCommentsReq(momentId: momentId, page: page, limit: limit),
    );
    if (response.isSuccess && response.result != null) {
      return response.result!.list;
    }
    return [];
  }

  Future<({List<IMomentCommentModel> list, int count})> loadChildComments(
    String momentId,
    String parentId,
    int page,
    int limit,
  ) async {
    final response = await getMomentCommentsApi(
      IGetMomentCommentsReq(
        momentId: momentId,
        parentId: parentId,
        page: page,
        limit: limit,
      ),
    );
    if (response.isSuccess && response.result != null) {
      return (list: response.result!.list, count: response.result!.count);
    }
    return (list: <IMomentCommentModel>[], count: 0);
  }

  Future<ICreateMomentCommentRes?> addComment({
    required String momentId,
    required String content,
    String? parentId,
    String? replyToCommentId,
  }) async {
    final response = await createMomentCommentApi(
      ICreateMomentCommentReq(
        momentId: momentId,
        content: content,
        parentId: parentId,
        replyToCommentId: replyToCommentId,
      ),
    );
    if (response.isSuccess && response.result != null) {
      return response.result;
    }
    return null;
  }

  Future<bool> toggleLike(String momentId, bool status) async {
    final response = await likeMomentApi(
      ILikeMomentReq(momentId: momentId, status: status),
    );
    return response.isSuccess;
  }

  Future<List<IMomentLikeModel>> loadLikes(
    String momentId,
    int page,
    int limit,
  ) async {
    final response = await getMomentLikesApi(
      IGetMomentLikesReq(momentId: momentId, page: page, limit: limit),
    );
    if (response.isSuccess && response.result != null) {
      return response.result!.list;
    }
    return [];
  }
}

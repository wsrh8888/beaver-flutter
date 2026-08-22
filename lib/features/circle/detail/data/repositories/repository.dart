import 'package:beaver/api/circle.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/circle.dart';

class CircleDetailRepository {
  Future<BaseResponse<IGetPostDetailRes>> loadDetail(String postId) {
    return getPostDetailApi(IGetPostDetailReq(postId: postId));
  }

  Future<BaseResponse<IGetCircleCommentListRes>> loadRootComments({
    required String postId,
    required int page,
    required int limit,
  }) {
    return getCircleCommentListApi(
      IGetCircleCommentListReq(postId: postId, page: page, limit: limit),
    );
  }

  Future<BaseResponse<IGetCircleCommentListRes>> loadChildComments({
    required String postId,
    required String parentId,
    required int page,
    required int limit,
  }) {
    return getCircleCommentListApi(
      IGetCircleCommentListReq(
        postId: postId,
        parentId: parentId,
        page: page,
        limit: limit,
      ),
    );
  }

  Future<BaseResponse<ICreateCircleCommentRes>> addComment({
    required String postId,
    required String content,
    String? parentId,
    String? replyToCommentId,
  }) {
    return createCircleCommentApi(
      ICreateCircleCommentReq(
        postId: postId,
        content: content,
        parentId: parentId,
        replyToCommentId: replyToCommentId,
      ),
    );
  }

  Future<BaseResponse<ILikePostRes>> toggleLike({
    required String postId,
    required bool status,
  }) {
    return likePostApi(ILikePostReq(postId: postId, status: status));
  }
}

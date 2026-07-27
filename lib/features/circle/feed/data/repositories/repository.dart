import 'package:beaver/api/circle.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/circle.dart';

class CircleFeedRepository {
  Future<BaseResponse<IGetPostListRes>> getPostList({
    required String circleId,
    required int page,
    required int limit,
  }) {
    return getPostListApi(
      IGetPostListReq(circleId: circleId, page: page, limit: limit),
    );
  }

  Future<BaseResponse<ILikePostRes>> toggleLike({
    required String postId,
    required bool status,
  }) {
    return likePostApi(ILikePostReq(postId: postId, status: status));
  }
}

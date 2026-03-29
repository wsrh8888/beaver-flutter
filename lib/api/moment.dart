import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/moment.dart';

/// 创建朋友圈
Future<BaseResponse<ICreateMomentRes>> createMomentApi(ICreateMomentReq data) {
  const url = '/api/moment/create';
  return httpClient.post<ICreateMomentRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => ICreateMomentRes.fromJson(json),
  );
}

/// 获取朋友圈列表
Future<BaseResponse<IGetMomentListRes>> getMomentListApi(IGetMomentListReq data) {
  const url = '/api/moment/list';
  return httpClient.post<IGetMomentListRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGetMomentListRes.fromJson(json),
  );
}

/// 点赞朋友圈
Future<BaseResponse<ILikeMomentRes>> likeMomentApi(ILikeMomentReq data) {
  const url = '/api/moment/like';
  return httpClient.post<ILikeMomentRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => ILikeMomentRes.fromJson(json),
  );
}

/// 发表评论
Future<BaseResponse<ICreateMomentCommentRes>> createMomentCommentApi(ICreateMomentCommentReq data) {
  const url = '/api/moment/comment/create';
  return httpClient.post<ICreateMomentCommentRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => ICreateMomentCommentRes.fromJson(json),
  );
}

/// 获取动态详情
Future<BaseResponse<IGetMomentDetailRes>> getMomentDetailApi(IGetMomentDetailReq data) {
  const url = '/api/moment/detail';
  return httpClient.post<IGetMomentDetailRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGetMomentDetailRes.fromJson(json),
  );
}

/// 删除朋友圈
Future<BaseResponse<void>> deleteMomentApi(IDeleteMomentReq data) {
  const url = '/api/moment/delete';
  return httpClient.get<void>(
    url,
    queryParameters: data.toJson(),
  );
}

/// 获取动态评论列表
Future<BaseResponse<IGetMomentCommentsRes>> getMomentCommentsApi(IGetMomentCommentsReq data) {
  const url = '/api/moment/comments';
  return httpClient.post<IGetMomentCommentsRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGetMomentCommentsRes.fromJson(json),
  );
}

/// 获取动态点赞列表
Future<BaseResponse<IGetMomentLikesRes>> getMomentLikesApi(IGetMomentLikesReq data) {
  const url = '/api/moment/likes';
  return httpClient.post<IGetMomentLikesRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IGetMomentLikesRes.fromJson(json),
  );
}


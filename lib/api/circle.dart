import 'package:beaver/common/config/env.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/circle.dart';

Future<BaseResponse<IGetMyCircleListRes>> getMyCircleListApi(
  IGetMyCircleListReq data,
) {
  final url = '$baseUrl/api/circle/v1/circle/mine';
  return httpClient.get<IGetMyCircleListRes>(
    url,
    queryParameters: data.toJson(),
    fromJsonT: (json) => IGetMyCircleListRes.fromJson(json),
  );
}

Future<BaseResponse<ICreateCircleRes>> createCircleApi(ICreateCircleReq data) {
  final url = '$baseUrl/api/circle/v1/circle/create';
  return httpClient.post<ICreateCircleRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => ICreateCircleRes.fromJson(json),
  );
}

Future<BaseResponse<IGetCircleDetailRes>> getCircleDetailApi(
  IGetCircleDetailReq data,
) {
  final url = '$baseUrl/api/circle/v1/circle/detail';
  return httpClient.get<IGetCircleDetailRes>(
    url,
    queryParameters: data.toJson(),
    fromJsonT: (json) => IGetCircleDetailRes.fromJson(json),
  );
}

Future<BaseResponse<IJoinCircleRes>> joinCircleApi(IJoinCircleReq data) {
  final url = '$baseUrl/api/circle/v1/circle/join';
  return httpClient.post<IJoinCircleRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => IJoinCircleRes.fromJson(json),
  );
}

Future<BaseResponse<IGetPostListRes>> getPostListApi(IGetPostListReq data) {
  final url = '$baseUrl/api/circle/v1/post/list';
  return httpClient.get<IGetPostListRes>(
    url,
    queryParameters: data.toJson(),
    fromJsonT: (json) => IGetPostListRes.fromJson(json),
  );
}

Future<BaseResponse<IGetPostDetailRes>> getPostDetailApi(
  IGetPostDetailReq data,
) {
  final url = '$baseUrl/api/circle/v1/post/detail';
  return httpClient.get<IGetPostDetailRes>(
    url,
    queryParameters: data.toJson(),
    fromJsonT: (json) => IGetPostDetailRes.fromJson(json),
  );
}

Future<BaseResponse<ICreatePostRes>> createPostApi(ICreatePostReq data) {
  final url = '$baseUrl/api/circle/v1/post/create';
  return httpClient.post<ICreatePostRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => ICreatePostRes.fromJson(json),
  );
}

Future<BaseResponse<ILikePostRes>> likePostApi(ILikePostReq data) {
  final url = '$baseUrl/api/circle/v1/post/like';
  return httpClient.post<ILikePostRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => ILikePostRes.fromJson(
      json is Map<String, dynamic> ? json : null,
    ),
  );
}

Future<BaseResponse<ICreateCircleCommentRes>> createCircleCommentApi(
  ICreateCircleCommentReq data,
) {
  final url = '$baseUrl/api/circle/v1/comment/create';
  return httpClient.post<ICreateCircleCommentRes>(
    url,
    data: data.toJson(),
    fromJsonT: (json) => ICreateCircleCommentRes.fromJson(json),
  );
}

Future<BaseResponse<IGetCircleCommentListRes>> getCircleCommentListApi(
  IGetCircleCommentListReq data,
) {
  final url = '$baseUrl/api/circle/v1/comment/list';
  return httpClient.get<IGetCircleCommentListRes>(
    url,
    queryParameters: data.toJson(),
    fromJsonT: (json) => IGetCircleCommentListRes.fromJson(json),
  );
}

Future<BaseResponse<IDeleteCircleCommentRes>> deleteCircleCommentApi(
  IDeleteCircleCommentReq data,
) {
  final url = '$baseUrl/api/circle/v1/comment/delete';
  return httpClient.get<IDeleteCircleCommentRes>(
    url,
    queryParameters: data.toJson(),
    fromJsonT: (json) => IDeleteCircleCommentRes.fromJson(
      json is Map<String, dynamic> ? json : null,
    ),
  );
}

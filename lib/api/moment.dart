import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/moment.dart';

Future<BaseResponse<IGetMomentListRes>> getMomentListApi(IGetMomentListReq data) {
  const url = '/api/moment/list';
  return httpClient.post<IGetMomentListRes>(url, data: data.toJson(), fromJsonT: (json) => IGetMomentListRes.fromJson(json));
}

Future<BaseResponse<ILikeMomentRes>> likeMomentApi(ILikeMomentReq data) {
  const url = '/api/moment/like';
  return httpClient.post<ILikeMomentRes>(url, data: data.toJson(), fromJsonT: (json) => ILikeMomentRes.fromJson(json));
}

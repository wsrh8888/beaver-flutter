import 'package:beaver/api/circle.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/circle.dart';

class CircleListRepository {
  Future<BaseResponse<IGetMyCircleListRes>> loadMyCircles() {
    return getMyCircleListApi(const IGetMyCircleListReq(page: 1, limit: 100));
  }

  Future<BaseResponse<ICreateCircleRes>> createCircle({
    required String name,
    required String description,
  }) {
    return createCircleApi(
      ICreateCircleReq(
        name: name.trim(),
        description: description.trim(),
        joinType: 0,
      ),
    );
  }
}

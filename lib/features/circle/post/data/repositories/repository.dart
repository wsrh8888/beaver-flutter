import 'package:beaver/api/circle.dart';
import 'package:beaver/api/file.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/circle.dart';

class CirclePostRepository {
  Future<BaseResponse<ICreatePostRes>> createPost({
    required String circleId,
    String? title,
    required String content,
    List<ICirclePostFile>? files,
  }) {
    return createPostApi(
      ICreatePostReq(
        circleId: circleId,
        title: title,
        content: content,
        files: files,
      ),
    );
  }

  Future<String> uploadImage(String imagePath) async {
    final response = await uploadFileApi(imagePath);
    if (response.isSuccess && response.result != null) {
      return response.result!.fileUrl;
    }
    return '';
  }
}

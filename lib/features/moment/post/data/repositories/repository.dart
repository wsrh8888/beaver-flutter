import 'package:beaver/api/moment.dart';
import 'package:beaver/types/api/moment.dart';

class PostMomentRepository {
  PostMomentRepository();

  Future<bool> createMoment(ICreateMomentReq request) async {
    final response = await createMomentApi(request);
    return response.isSuccess;
  }

  Future<String> uploadImage(String imagePath) async {
    final response = await uploadImageApi(imagePath);
    if (response.isSuccess && response.result != null) {
      return response.result!;
    }
    return '';
  }
}


import 'package:beaver/types/api/moment.dart';
import 'package:beaver/features/moment/post/data/models/post.dart';

/// 朋友圈仓库接口
abstract class MomentRepositoryInterface {
  Future<List<IMomentListItem>> getMomentList({required int page, int limit = 10});
  Future<bool> likeMoment(String momentId, bool status);
  Future<bool> createMoment(PostMomentRequest request);
  Future<String> uploadImage(String imagePath);
}
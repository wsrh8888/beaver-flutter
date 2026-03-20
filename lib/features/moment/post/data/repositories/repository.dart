import 'package:beaver/di/injection.dart';
import 'package:beaver/features/moment/post/data/models/post.dart';
import 'package:beaver/types/business/moment.dart';

class PostMomentRepository {
  final MomentRepositoryInterface _momentRepository;

  PostMomentRepository({MomentRepositoryInterface? momentRepository}) 
    : _momentRepository = momentRepository ?? getIt<MomentRepositoryInterface>();

  Future<bool> createMoment(PostMomentRequest request) async {
    return _momentRepository.createMoment(request);
  }

  Future<String> uploadImage(String imagePath) async {
    return _momentRepository.uploadImage(imagePath);
  }
}


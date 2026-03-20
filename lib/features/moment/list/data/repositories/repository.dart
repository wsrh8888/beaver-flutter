import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/moment.dart';
import 'package:beaver/types/business/moment.dart';

class MomentListRepository {
  final MomentRepositoryInterface _momentRepository;

  MomentListRepository({MomentRepositoryInterface? momentRepository}) 
    : _momentRepository = momentRepository ?? getIt<MomentRepositoryInterface>();

  Future<List<IMomentListItem>> getMomentList(int page, int limit) async {
    return _momentRepository.getMomentList(page: page, limit: limit);
  }

  Future<bool> toggleLike(String momentId, bool status) async {
    return _momentRepository.likeMoment(momentId, status);
  }
}

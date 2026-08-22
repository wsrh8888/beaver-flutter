import 'package:beaver/core/datasync/circle/circle_sync.dart';

class CircleDatasync {
  Future<void> checkAndSync() async {
    await circleSync.checkAndSync();
  }
}

final circleDatasync = CircleDatasync();

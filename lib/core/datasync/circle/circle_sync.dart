import 'package:beaver/api/circle.dart';
import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/business/circle/circle.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/circle.dart';
import 'package:beaver/types/api/datasync.dart';

/// 圈子资料同步（对齐 PC datasync/circle）
class CircleSync {
  Future<void> checkAndSync() async {
    try {
      final datasyncService = getIt<DatasyncService>();
      final circleService = getIt<CircleService>();

      final cursor = await datasyncService.get('circles');
      final lastVersion = cursor?.version ?? 0;

      final serverResponse = await datasyncGetSyncCircleInfoApi(
        IGetSyncCircleInfoReq(since: lastVersion),
      );
      if (serverResponse.code != 0 || serverResponse.result == null) {
        return;
      }

      final circleVersions = serverResponse.result!.circleVersions;
      final needUpdate = await _compareAndFilter(circleService, circleVersions);

      if (needUpdate.isNotEmpty) {
        await _syncCircleData(circleService, lastVersion);
      }

      final maxVersion = circleVersions.isNotEmpty
          ? circleVersions
              .map((e) => e.version)
              .fold<int>(lastVersion, (a, b) => a > b ? a : b)
          : lastVersion;

      await datasyncService.upsert(
        'circles',
        maxVersion,
        serverResponse.result!.serverTimestamp > 0
            ? (serverResponse.result!.serverTimestamp > 1000000000000
                ? serverResponse.result!.serverTimestamp ~/ 1000
                : serverResponse.result!.serverTimestamp)
            : (DateTime.now().millisecondsSinceEpoch ~/ 1000),
      );
    } catch (_) {
      // 静默失败，下一轮再试
    }
  }

  Future<List<ICircleInfoVersionItem>> _compareAndFilter(
    CircleService circleService,
    List<ICircleInfoVersionItem> circleVersions,
  ) async {
    if (circleVersions.isEmpty) return [];

    final circleIds = circleVersions.map((e) => e.circleId).toList();
    final localCircles = await circleService.getCirclesByIds(circleIds);
    final localVersionMap = {
      for (final item in localCircles) item.circleId: item.version,
    };

    final needUpdate = <ICircleInfoVersionItem>[];
    for (final item in circleVersions) {
      final localVersion = localVersionMap[item.circleId] ?? 0;
      if (localVersion < item.version) {
        needUpdate.add(item);
      }
    }
    return needUpdate;
  }

  Future<void> _syncCircleData(
    CircleService circleService,
    int lastVersion,
  ) async {
    final response = await circleSyncApi(ICircleSyncReq(version: lastVersion));
    if (response.code != 0 ||
        response.result == null ||
        response.result!.list.isEmpty) {
      return;
    }

    await circleService.batchUpsert(response.result!.list);
    getIt<CircleBusiness>().notifyCircleUpdate(
      response.result!.list.map((e) => e.circleId).toList(),
    );
  }
}

final circleSync = CircleSync();

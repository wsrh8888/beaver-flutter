import 'dart:async';

import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/circle.dart';
import 'package:beaver/types/business/circle.dart';
import 'package:drift/drift.dart';

/// 圈子业务门面（本地库 + 必要 API）
class CircleBusiness {
  final _circleService = getIt<CircleService>();

  final _circleUpdateController = StreamController<List<String>>.broadcast();
  Stream<List<String>> get circleUpdateStream => _circleUpdateController.stream;

  void notifyCircleUpdate(List<String> circleIds) {
    _circleUpdateController.add(circleIds);
  }

  CircleInfo _toInfo(Circle row) {
    return CircleInfo(
      circleId: row.circleId,
      conversationId: 'circle_${row.circleId}',
      name: row.name,
      avatar: row.avatar,
      description: row.description,
      memberCount: row.memberCount,
      role: row.role,
      joinType: row.joinType,
      version: row.version,
    );
  }

  Future<List<CircleInfo>> getCircleList() async {
    final rows = await _circleService.getActiveCircles();
    return rows.map(_toInfo).toList();
  }

  Future<List<CircleInfo>> getCirclesByIds(List<String> circleIds) async {
    if (circleIds.isEmpty) return [];
    final rows = await _circleService.getCirclesByIds(circleIds);
    return rows.where((r) => r.role > 0).map(_toInfo).toList();
  }

  Future<CircleInfo?> getCircleById(String circleIdOrConversationId) async {
    final circleId = circleIdOrConversationId.startsWith('circle_')
        ? circleIdOrConversationId.substring('circle_'.length)
        : circleIdOrConversationId;
    if (circleId.isEmpty) return null;
    final row = await _circleService.getCircleById(circleId);
    if (row == null || row.role <= 0) return null;
    return _toInfo(row);
  }

  /// 创建成功后写入本地（随后仍可由 sync 校准 version）
  Future<void> upsertAfterCreate({
    required String circleId,
    required String name,
    String description = '',
    String avatar = '',
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _circleService.upsert(
      CirclesCompanion(
        circleId: Value(circleId),
        name: Value(name),
        avatar: Value(avatar),
        description: Value(description),
        memberCount: const Value(1),
        role: const Value(1),
        joinType: const Value(0),
        version: const Value(1),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    notifyCircleUpdate([circleId]);
  }

  /// 详情/加入成功后落库
  Future<void> upsertFromDetail(IGetCircleDetailRes detail) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final local = await _circleService.getCircleById(detail.circleId);
    await _circleService.upsert(
      CirclesCompanion(
        circleId: Value(detail.circleId),
        name: Value(detail.name),
        avatar: Value(detail.avatar),
        description: Value(detail.description),
        creatorId: Value(detail.creatorId),
        memberCount: Value(detail.memberCount),
        role: Value(detail.role),
        joinType: Value(detail.joinType),
        version: Value(local?.version ?? 0),
        createdAt: local?.createdAt != null
            ? Value(local!.createdAt!)
            : Value(now),
        updatedAt: Value(now),
      ),
    );
    notifyCircleUpdate([detail.circleId]);
  }

  Future<void> removeCircle(String circleIdOrConversationId) async {
    final circleId = circleIdOrConversationId.startsWith('circle_')
        ? circleIdOrConversationId.substring('circle_'.length)
        : circleIdOrConversationId;
    await _circleService.deleteCircle(circleId);
    notifyCircleUpdate([circleId]);
  }
}

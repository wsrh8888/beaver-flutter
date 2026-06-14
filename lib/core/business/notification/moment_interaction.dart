import 'dart:convert';

import 'package:beaver/core/database/services/notification/event.dart';
import 'package:beaver/core/database/services/notification/inbox.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/moment_interaction.dart';

/// 朋友圈互动消息（对标微信「朋友圈消息」）
class MomentInteractionBusiness {
  final _inboxService = getIt<NotificationInboxService>();
  final _eventService = getIt<NotificationEventService>();

  Future<List<MomentInteractionItem>> getInteractions(String userId) async {
    if (userId.isEmpty) return [];

    final inboxRows = await _inboxService.getInboxByUserIdAndCategory({
      'userId': userId,
      'category': 'moment',
    });

    final activeRows = inboxRows
        .where((row) => (row['isDeleted'] as int? ?? 0) == 0)
        .toList();
    if (activeRows.isEmpty) return [];

    final eventIds = activeRows
        .map((row) => row['eventId'] as String? ?? '')
        .where((id) => id.isNotEmpty)
        .toList();
    final events = await _eventService.getByIds(eventIds);
    final eventMap = {for (final event in events) event.eventId: event};

    final items = <MomentInteractionItem>[];
    for (final row in activeRows) {
      final eventId = row['eventId'] as String? ?? '';
      final event = eventMap[eventId];
      if (event == null) continue;

      if (event.eventType == 'moment_unlike') continue;

      final payload = _parsePayload(event.payload);
      final momentId = payload['momentId'] as String? ??
          event.targetId ??
          '';
      if (momentId.isEmpty) continue;

      items.add(
        MomentInteractionItem(
          eventId: eventId,
          eventType: event.eventType,
          fromUserId: event.fromUserId ?? '',
          momentId: momentId,
          commentId: payload['commentId'] as String?,
          content: payload['content'] as String?,
          createdAt: row['createdAt'] as int? ??
              event.createdAt ??
              0,
          isRead: (row['isRead'] as int? ?? 0) == 1,
        ),
      );
    }

    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Map<String, dynamic> _parsePayload(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return {};
  }
}

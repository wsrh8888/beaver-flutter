/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

import 'package:beaver/api/datasync.dart';
import 'package:beaver/core/business/notification/event.dart';
import 'package:beaver/core/business/notification/inbox.dart';
import 'package:beaver/core/business/notification/read_cursor.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/datasync.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('datasync-notification');

/// 通知中心数据同步 (对标 PC notificationDatasync)
class NotificationSync {
  Future<void> checkAndSync() async {
    _logger.info({'text': '开始同步通知中心数据（事件/收件箱/已读游标）'});
    try {
      await _syncEvents();
      await _syncInboxes();
      await _syncReadCursors();
      _logger.info({'text': '通知中心数据同步完成'});
    } catch (e) {
      _logger.warn({'text': '通知中心数据同步异常', 'data': {'error': e.toString()}});
    }
  }

  Future<void> _syncEvents() async {
    final datasyncService = getIt<DatasyncService>();
    final eventService = getIt<NotificationEventService>();
    final eventBusiness = getIt<NotificationEventBusiness>();

    final cursor = await datasyncService.get('notification_events');
    final sinceVersion = cursor?.version ?? 0;

    final response = await datasyncGetSyncNotificationEventsApi(
      IGetSyncNotificationEventsReq(sinceVersion: sinceVersion),
    );
    if (response.code != 0 || response.result == null) {
      _logger.warn({'text': '获取通知事件版本变更失败', 'data': {'code': response.code, 'msg': response.msg}});
      return;
    }

    final eventVersions = response.result!.eventVersions;
    final needEventIds = await _filterEventVersions(eventService, eventVersions);

    if (needEventIds.isNotEmpty) {
      await eventBusiness.syncEventsByIds(needEventIds);
    }

    final nextVersion = _maxVersion(
      sinceVersion,
      response.result!.maxVersion,
      eventVersions.map((e) => e.version),
    );

    await datasyncService.upsert(
      'notification_events',
      nextVersion,
      response.result!.serverTimestamp,
    );
  }

  Future<void> _syncInboxes() async {
    final userId = DatabaseManager.currentUserId ?? '';
    if (userId.isEmpty) return;

    final datasyncService = getIt<DatasyncService>();
    final inboxService = getIt<NotificationInboxService>();
    final inboxBusiness = getIt<NotificationInboxBusiness>();

    final cursor = await datasyncService.get('notification_inboxes');
    final sinceVersion = cursor?.version ?? 0;

    final response = await datasyncGetSyncNotificationInboxesApi(
      IGetSyncNotificationInboxesReq(sinceVersion: sinceVersion),
    );
    if (response.code != 0 || response.result == null) {
      _logger.warn({'text': '获取通知收件箱版本变更失败', 'data': {'code': response.code, 'msg': response.msg}});
      return;
    }

    final inboxVersions = response.result!.inboxVersions;
    final needEventIds = await _filterInboxVersions(
      inboxService,
      userId,
      inboxVersions,
    );

    if (needEventIds.isNotEmpty) {
      await inboxBusiness.syncInboxesByEventIds(userId, needEventIds);
    }

    final nextVersion = _maxVersion(
      sinceVersion,
      response.result!.maxVersion,
      inboxVersions.map((e) => e.version),
    );

    await datasyncService.upsert(
      'notification_inboxes',
      nextVersion,
      response.result!.serverTimestamp,
    );
  }

  Future<void> _syncReadCursors() async {
    final userId = DatabaseManager.currentUserId ?? '';
    if (userId.isEmpty) return;

    final datasyncService = getIt<DatasyncService>();
    final readCursorBusiness = getIt<NotificationReadCursorBusiness>();

    final cursor = await datasyncService.get('notification_reads');
    final sinceVersion = cursor?.version ?? 0;

    final response = await datasyncGetSyncNotificationReadCursorsApi(
      IGetSyncNotificationReadCursorsReq(sinceVersion: sinceVersion),
    );
    if (response.code != 0 || response.result == null) {
      _logger.warn({'text': '获取通知已读游标版本变更失败', 'data': {'code': response.code, 'msg': response.msg}});
      return;
    }

    final cursorVersions = response.result!.cursorVersions;
    final categories = cursorVersions
        .map((item) => item.category)
        .where((cat) => cat.isNotEmpty)
        .toList();

    if (categories.isNotEmpty) {
      await readCursorBusiness.syncReadCursors(userId, categories);
    }

    final nextVersion = _maxVersion(
      sinceVersion,
      response.result!.maxVersion,
      cursorVersions.map((e) => e.version),
    );

    await datasyncService.upsert(
      'notification_reads',
      nextVersion,
      response.result!.serverTimestamp,
    );
  }

  Future<List<String>> _filterEventVersions(
    NotificationEventService eventService,
    List<INotificationEventVersionItem> eventVersions,
  ) async {
    if (eventVersions.isEmpty) return [];

    final eventIds = eventVersions.map((e) => e.eventId).where((id) => id.isNotEmpty).toList();
    if (eventIds.isEmpty) return [];

    final localMap = await eventService.getVersionMapByIds(eventIds);
    return eventVersions
        .where((item) => (localMap[item.eventId] ?? 0) < item.version)
        .map((item) => item.eventId)
        .toList();
  }

  Future<List<String>> _filterInboxVersions(
    NotificationInboxService inboxService,
    String userId,
    List<INotificationInboxVersionItem> inboxVersions,
  ) async {
    if (inboxVersions.isEmpty) return [];

    final eventIds = inboxVersions.map((e) => e.eventId).where((id) => id.isNotEmpty).toList();
    if (eventIds.isEmpty) return [];

    final localMap = await inboxService.getVersionMapByEventIds(
      userId: userId,
      eventIds: eventIds,
    );

    return inboxVersions
        .where((item) => (localMap[item.eventId] ?? 0) < item.version)
        .map((item) => item.eventId)
        .toList();
  }

  int _maxVersion(int sinceVersion, int maxVersion, Iterable<int> versions) {
    var result = sinceVersion;
    if (maxVersion > result) result = maxVersion;
    for (final version in versions) {
      if (version > result) result = version;
    }
    return result;
  }
}

final notificationSync = NotificationSync();

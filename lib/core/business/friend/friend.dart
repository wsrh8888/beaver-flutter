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

import 'dart:async';
import 'package:beaver/api/friend.dart';
import 'package:beaver/core/business/user/user.dart';
import 'package:beaver/core/database/db.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:intl/intl.dart';
import 'package:beaver/types/api/friend.dart';
import 'package:beaver/types/business/contact.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('friend-business');

/// 好友业务逻辑
class FriendBusiness implements FriendRepositoryInterface {
  final _service = getIt<FriendService>();
  final _friendUpdateController = StreamController<List<String>>.broadcast();
  final Map<String, int> _lastHandledVersionByFriendId = {};

  Stream<List<String>> get friendUpdateStream => _friendUpdateController.stream;

  void notifyFriendUpdate(List<String> friendIds) {
    _friendUpdateController.add(friendIds);
  }

  /**
   * @description 获取好友列表 (UI 格式)
   */
  Future<List<ContactModel>> getContactList() async {
    final myUserId = DatabaseManager.currentUserId ?? '';

    if (myUserId.isEmpty) {
      return [];
    }

    final friends = await _service.getFriends();
    if (friends.isEmpty) return [];

    final results = friends.map((friend) {
      // 确定好友的用户ID
      final friendUserId = friend.sendUserId == myUserId
          ? friend.revUserId
          : friend.sendUserId;

      // 确定备注信息 (根据我是发送者还是接收者)
      final notice = friend.sendUserId == myUserId
          ? friend.sendUserNotice
          : friend.revUserNotice;

      return ContactModel(
        userId: friendUserId,
        nickname: '', // Store will resolve this from ContactStore
        notice: notice,
        avatar: '', // Store will resolve this from ContactStore
      );
    }).toList();

    return results;
  }

  /**
   * @description 根据字母分组联系人
   */
  Map<String, List<ContactModel>> groupContactsByLetter(
    List<ContactModel> contacts,
  ) {
    final groups = <String, List<ContactModel>>{};

    for (final contact in contacts) {
      // 优先使用备注 (notice) 进行分组
      final displayName = contact.notice?.isNotEmpty == true
          ? contact.notice!
          : contact.nickname;
      final firstChar = displayName.isNotEmpty
          ? displayName[0].toUpperCase()
          : '#';
      final letter = RegExp(r'[A-Z]').hasMatch(firstChar) ? firstChar : '#';

      if (!groups.containsKey(letter)) {
        groups[letter] = [];
      }
      groups[letter]!.add(contact);
    }

    // 处理排序：优先使用备注排序
    groups.forEach((key, value) {
      value.sort((a, b) {
        final aName = a.notice?.isNotEmpty == true ? a.notice! : a.nickname;
        final bName = b.notice?.isNotEmpty == true ? b.notice! : b.nickname;
        return aName.compareTo(bName);
      });
    });

    return groups;
  }

  /**
   * @description 获取索引列表
   */
  List<String> getIndexList(Map<String, List<ContactModel>> groups) {
    final letters = [''];
    letters.addAll(groups.keys.toList()..sort());
    return letters;
  }

  /**
   * @description 删除好友
   */
  Future<void> deleteFriend(String friendId) async {
    _logger.info({'text': '开始删除好友', 'data': {'friendId': friendId}});
    try {
      await _service.deleteFriend(friendId);
      _logger.info({'text': '删除好友成功', 'data': {'friendId': friendId}});
    } catch (e) {
      _logger.error({
        'text': '删除好友失败',
        'data': {'friendId': friendId, 'error': e.toString()},
      });
      rethrow;
    }
  }

  /**
   * @description 更新好友备注
   */
  Future<bool> updateRemarkName(String friendId, String notice) async {
    final myUserId = DatabaseManager.currentUserId ?? '';
    if (myUserId.isEmpty) {
      _logger.warn({
        'text': '更新备注失败：当前用户未登录',
        'data': {'friendId': friendId},
      });
      return false;
    }

    _logger.info({
      'text': '开始更新好友备注',
      'data': {'friendId': friendId, 'notice': notice},
    });
    final response = await updateRemarkNameApi(
      INoticeUpdateReq(friendId: friendId, notice: notice),
    );
    if (!response.isSuccess) {
      _logger.error({
        'text': '更新好友备注接口失败',
        'data': {
          'friendId': friendId,
          'code': response.code,
          'msg': response.msg,
        },
      });
      return false;
    }

    final friend = await _service.getFriendByPeerId(myUserId, friendId);
    if (friend != null) {
      if (friend.sendUserId == myUserId) {
        await _service.updateNotice(
          friend.friendId,
          sendUserNotice: notice,
        );
      } else {
        await _service.updateNotice(
          friend.friendId,
          revUserNotice: notice,
        );
      }
      notifyFriendUpdate([friend.friendId]);
    }
    _logger.info({
      'text': '更新好友备注成功',
      'data': {'friendId': friendId, 'notice': notice},
    });
    return true;
  }

  @override
  Future<List<FriendRequest>> getFriendRequests() async {
    final currentUserId = DatabaseManager.currentUserId ?? '';
    if (currentUserId.isEmpty) {
      _logger.warn({'text': '获取好友请求失败：当前用户未登录'});
      return [];
    }

    final verifyService = getIt<FriendVerifyService>();
    final userBusiness = getIt<UserBusiness>();

    // 1. 获取验证记录
    final verifies = await verifyService.getValidList(currentUserId);
    _logger.info({
      'text': '已获取好友验证记录',
      'data': {'count': verifies.length},
    });
    if (verifies.isEmpty) return [];

    // 2. 收集需要查询的用户ID
    final userIds = verifies
        .map((v) {
          return v.sendUserId == currentUserId ? v.revUserId : v.sendUserId;
        })
        .toSet()
        .toList();

    // 3. 批量获取用户信息
    final userInfos = await userBusiness.getUsersBasicInfo(userIds);
    _logger.info({
      'text': '已批量获取用户基本信息',
      'data': {'need': userIds.length, 'got': userInfos.length},
    });
    final userMap = {for (var u in userInfos) u.userId: u};

    // 4. 组装数据
    final requests = verifies.map((v) {
      final friendUserId = v.sendUserId == currentUserId
          ? v.revUserId
          : v.sendUserId;
      final userInfo = userMap[friendUserId];
      final flag = v.sendUserId == currentUserId ? 'send' : 'receive';

      int status = (v.revStatus == 1 || v.sendStatus == 1)
          ? 1
          : (v.revStatus == 2 || v.sendStatus == 2 ? 2 : 0);

      final createdAt = v.createdAt != null
          ? DateFormat(
              'yyyy-MM-dd HH:mm',
            ).format(DateTime.fromMillisecondsSinceEpoch(v.createdAt! * 1000))
          : '';

      return FriendRequest(
        id: v.verifyId,
        nickname: userInfo?.nickname ?? friendUserId,
        fileName: userInfo?.avatar ?? '',
        message: v.message,
        source: v.source ?? 'search',
        flag: flag,
        status: status,
        createdAt: createdAt,
      );
    }).toList();

    // 按时间降序排序
    requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    _logger.info({
      'text': '组装好友请求列表完成',
      'data': {'count': requests.length},
    });
    return requests;
  }

  @override
  Future<int> getUnreadFriendRequestCount(String userId) async {
    final verifyService = getIt<FriendVerifyService>();
    return await verifyService.getUnreadCount(userId);
  }

  /**
   * @description 处理好友表更新
   */
  Future<void> handleTableUpdates(int version, String? friendId) async {
    if (friendId == null || friendId.trim().isEmpty) {
      _logger.warn({'text': '好友表更新缺少 friendId，跳过'});
      notifyFriendUpdate(const []);
      return;
    }

    final lastVersion = _lastHandledVersionByFriendId[friendId] ?? 0;
    if (version <= lastVersion) {
      _logger.info({
        'text': '好友表更新版本已处理，跳过',
        'data': {'friendId': friendId, 'version': version, 'lastVersion': lastVersion},
      });
      return;
    }

    _logger.info({
      'text': '开始拉取好友详情',
      'data': {'friendId': friendId, 'version': version},
    });
    final response = await getFriendsListByIdsApi(
      IGetFriendsListByIdsReq(friendIds: [friendId]),
    );
    if (response.code != 0 || response.result == null) {
      _logger.error({
        'text': '拉取好友详情接口失败',
        'data': {'friendId': friendId, 'code': response.code, 'msg': response.msg},
      });
      return;
    }

    if (response.result!.friends.isNotEmpty) {
      final companions = response.result!.friends
          .map((f) => f.toCompanion())
          .toList();
      await _service.batchCreate(companions);
    }

    _lastHandledVersionByFriendId[friendId] = version;
    _logger.info({
      'text': '好友表更新处理完成',
      'data': {'friendId': friendId, 'version': version},
    });
    notifyFriendUpdate([friendId]);
  }
}

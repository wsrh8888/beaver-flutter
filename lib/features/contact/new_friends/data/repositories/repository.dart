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

import 'package:beaver/api/friend.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/api/friend.dart';
import 'package:beaver/types/business/contact.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('repo-contact-new_friends');

class NewFriendsRepository {
  final _friendBusiness = getIt<FriendBusiness>();

  Future<List<FriendRequest>> getFriendRequests() async {
    try {

    return await _friendBusiness.getFriendRequests();
    } catch (e, st) {
      _logger.warn({'text':'NewFriendsRepository.getFriendRequests 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  /// 直接调用接口验证好友申请，返回 API 原生 Response
  Future<BaseResponse<void>> updateRequestStatus(
    String verifyId,
    int status,
  ) async {
    try {

    return await valiFriendApi(
      IValiFriendReq(verifyId: verifyId, status: status),
    );
    } catch (e, st) {
      _logger.warn({'text':'NewFriendsRepository.updateRequestStatus 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}

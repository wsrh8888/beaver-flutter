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
import 'package:beaver/types/api/friend.dart';
import 'package:beaver/types/business/user.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('repo-contact-search');

class SearchContactRepository {
  Future<UserInfo?> searchUser(String keyword) async {
    try {

    final response = await getSearchFriendApi(
      ISearchUserReq(
        keyword: keyword,
        type: keyword.contains('@') ? 'email' : 'userId',
      ),
    );

    if (response.code != 0 || response.result == null) {
      return null;
    }

    final res = response.result!;
    return UserInfo(
      userId: res.userId,
      nickname: res.nickName,
      avatar: res.avatar,
      abstract: res.abstract,
      email: res.email,
    );
    } catch (e, st) {
      _logger.warn({'text':'SearchContactRepository.searchUser 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }

  Future<BaseResponse<void>> addFriend(String userId) async {
    try {

    return applyAddFriendApi(
      IAddFriendReq(friendId: userId, source: 'userId', verify: 'verify'),
    );
    } catch (e, st) {
      _logger.warn({'text':'SearchContactRepository.addFriend 执行失败','data':{'error': e.toString(), 'stack': st.toString()}});
      rethrow;
    }
  }
}

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

import 'package:beaver/api/moment.dart';
import 'package:beaver/types/api/moment.dart';

class MomentDetailRepository {
  MomentDetailRepository();

  Future<IMomentListItem?> loadDetail(String momentId) async {
    final response = await getMomentDetailApi(
      IGetMomentDetailReq(momentId: momentId),
    );
    if (response.isSuccess && response.result != null) {
      return response.result;
    }
    return null;
  }

  Future<List<IMomentCommentModel>> loadRootComments(
    String momentId,
    int page,
    int limit,
  ) async {
    final response = await getMomentCommentsApi(
      IGetMomentCommentsReq(momentId: momentId, page: page, limit: limit),
    );
    if (response.isSuccess && response.result != null) {
      return response.result!.list;
    }
    return [];
  }

  Future<({List<IMomentCommentModel> list, int count})> loadChildComments(
    String momentId,
    String parentId,
    int page,
    int limit,
  ) async {
    final response = await getMomentCommentsApi(
      IGetMomentCommentsReq(
        momentId: momentId,
        parentId: parentId,
        page: page,
        limit: limit,
      ),
    );
    if (response.isSuccess && response.result != null) {
      return (list: response.result!.list, count: response.result!.count);
    }
    return (list: <IMomentCommentModel>[], count: 0);
  }

  Future<ICreateMomentCommentRes?> addComment({
    required String momentId,
    required String content,
    String? parentId,
    String? replyToCommentId,
  }) async {
    final response = await createMomentCommentApi(
      ICreateMomentCommentReq(
        momentId: momentId,
        content: content,
        parentId: parentId,
        replyToCommentId: replyToCommentId,
      ),
    );
    if (response.isSuccess && response.result != null) {
      return response.result;
    }
    return null;
  }

  Future<bool> toggleLike(String momentId, bool status) async {
    final response = await likeMomentApi(
      ILikeMomentReq(momentId: momentId, status: status),
    );
    return response.isSuccess;
  }

  Future<List<IMomentLikeModel>> loadLikes(
    String momentId,
    int page,
    int limit,
  ) async {
    final response = await getMomentLikesApi(
      IGetMomentLikesReq(momentId: momentId, page: page, limit: limit),
    );
    if (response.isSuccess && response.result != null) {
      return response.result!.list;
    }
    return [];
  }
}

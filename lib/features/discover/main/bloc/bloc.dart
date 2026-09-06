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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/discover/main/bloc/event.dart';
import 'package:beaver/features/discover/main/bloc/state.dart';
import 'package:beaver/features/discover/main/data/repositories/repository.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('discover-main');

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DiscoverMainRepository _repository;

  DiscoverBloc(this._repository) : super(const DiscoverState()) {
    on<LoadDiscoverItemsEvent>(_onLoadDiscoverItems);
  }

  Future<void> _onLoadDiscoverItems(
    LoadDiscoverItemsEvent event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(status: DiscoverStatus.loading));
    _logger.info({'text': '加载发现页内容'});

    final discoverItems = await _repository.getDiscoverItems();
    _logger.info({
      'text': '加载发现页内容成功',
      'data': {'count': discoverItems.length},
    });
    emit(state.copyWith(
      status: DiscoverStatus.success,
      discoverItems: discoverItems,
    ));
  }
}


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

import 'package:beaver/core/business/emoji/favorite_emoji.dart';
import 'package:beaver/core/business/emoji/package.dart';
import 'package:beaver/core/business/emoji/package_emoji.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/emoji.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class EmojiStoreState extends Equatable {
  final List<EmojiPackageModel> packageList;
  final List<FavoriteEmojiModel> favoriteEmojis;
  final Map<String, List<EmojiModel>> packageEmojisMap;
  final bool isLoading;

  const EmojiStoreState({
    this.packageList = const [],
    this.favoriteEmojis = const [],
    this.packageEmojisMap = const {},
    this.isLoading = false,
  });

  EmojiStoreState copyWith({
    List<EmojiPackageModel>? packageList,
    List<FavoriteEmojiModel>? favoriteEmojis,
    Map<String, List<EmojiModel>>? packageEmojisMap,
    bool? isLoading,
  }) {
    return EmojiStoreState(
      packageList: packageList ?? this.packageList,
      favoriteEmojis: favoriteEmojis ?? this.favoriteEmojis,
      packageEmojisMap: packageEmojisMap ?? this.packageEmojisMap,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [packageList, favoriteEmojis, packageEmojisMap, isLoading];
}

class EmojiStore extends Cubit<EmojiStoreState> {
  final FavoriteEmojiBusinessInterface _favoriteEmojiBusiness = getIt<FavoriteEmojiBusinessInterface>();
  final EmojiPackageBusinessInterface _packageBusiness = getIt<EmojiPackageBusinessInterface>();
  final PackageEmojiBusinessInterface _packageEmojiBusiness = getIt<PackageEmojiBusinessInterface>();

  EmojiStore() : super(const EmojiStoreState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    try {
      final packages = await _packageBusiness.getEmojiPackages();
      final favorites = await _favoriteEmojiBusiness.getUserFavoriteEmojis();
      emit(state.copyWith(
        packageList: packages,
        favoriteEmojis: favorites,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> loadPackageEmojis(String packageId) async {
    if (state.packageEmojisMap.containsKey(packageId)) return;

    try {
      final emojis = await _packageEmojiBusiness.getPackageEmojis(packageId);
      final newMap = Map<String, List<EmojiModel>>.from(state.packageEmojisMap);
      newMap[packageId] = emojis;
      emit(state.copyWith(packageEmojisMap: newMap));
    } catch (e) {
      // 错误处理
    }
  }
}

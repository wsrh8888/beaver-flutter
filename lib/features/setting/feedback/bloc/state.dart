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

import 'package:beaver/features/setting/feedback/data/models/feedback.dart';

enum FeedbackStatus { initial, loading, success, error }

class FeedbackState {
  final FeedbackStatus status;
  final List<FeedbackType> feedbackTypes;
  final int? selectedType;
  final String content;
  final List<UploadedImage> uploadedImages;
  final int charCount;
  final String? errorMessage;

  const FeedbackState({
    this.status = FeedbackStatus.initial,
    this.feedbackTypes = const [],
    this.selectedType,
    this.content = '',
    this.uploadedImages = const [],
    this.charCount = 0,
    this.errorMessage,
  });

  FeedbackState copyWith({
    FeedbackStatus? status,
    List<FeedbackType>? feedbackTypes,
    int? selectedType,
    String? content,
    List<UploadedImage>? uploadedImages,
    int? charCount,
    String? errorMessage,
  }) {
    return FeedbackState(
      status: status ?? this.status,
      feedbackTypes: feedbackTypes ?? this.feedbackTypes,
      selectedType: selectedType ?? this.selectedType,
      content: content ?? this.content,
      uploadedImages: uploadedImages ?? this.uploadedImages,
      charCount: charCount ?? this.charCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

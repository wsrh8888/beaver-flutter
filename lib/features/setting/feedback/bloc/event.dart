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

abstract class FeedbackEvent {
  const FeedbackEvent();
}

class LoadFeedbackTypesEvent extends FeedbackEvent {
  const LoadFeedbackTypesEvent();
}

class SelectFeedbackTypeEvent extends FeedbackEvent {
  final int type;

  const SelectFeedbackTypeEvent(this.type);
}

class UpdateContentEvent extends FeedbackEvent {
  final String content;

  const UpdateContentEvent(this.content);
}

class AddImageEvent extends FeedbackEvent {
  final UploadedImage image;

  const AddImageEvent(this.image);
}

class RemoveImageEvent extends FeedbackEvent {
  final int index;

  const RemoveImageEvent(this.index);
}

class SubmitFeedbackEvent extends FeedbackEvent {
  const SubmitFeedbackEvent();
}

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
import 'package:beaver/features/setting/feedback/bloc/event.dart';
import 'package:beaver/features/setting/feedback/bloc/state.dart';
import 'package:beaver/features/setting/feedback/data/repositories/repository.dart';
import 'package:beaver/features/setting/feedback/data/models/feedback.dart';
import 'package:beaver/features/setting/feedback/data/constants.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FeedbackRepository _repository;

  FeedbackBloc(this._repository) : super(const FeedbackState()) {
    on<LoadFeedbackTypesEvent>(_onLoadFeedbackTypes);
    on<SelectFeedbackTypeEvent>(_onSelectFeedbackType);
    on<UpdateContentEvent>(_onUpdateContent);
    on<AddImageEvent>(_onAddImage);
    on<RemoveImageEvent>(_onRemoveImage);
    on<SubmitFeedbackEvent>(_onSubmitFeedback);
  }

  void _onLoadFeedbackTypes(
    LoadFeedbackTypesEvent event,
    Emitter<FeedbackState> emit,
  ) {
    emit(state.copyWith(
      status: FeedbackStatus.initial, // Don't use success here!
      feedbackTypes: feedbackTypes,
    ));
  }

  void _onSelectFeedbackType(
    SelectFeedbackTypeEvent event,
    Emitter<FeedbackState> emit,
  ) {
    emit(state.copyWith(selectedType: event.type));
  }

  void _onUpdateContent(
    UpdateContentEvent event,
    Emitter<FeedbackState> emit,
  ) {
    emit(state.copyWith(
      content: event.content,
      charCount: event.content.length,
    ));
  }

  void _onAddImage(
    AddImageEvent event,
    Emitter<FeedbackState> emit,
  ) {
    final images = List<UploadedImage>.from(state.uploadedImages ?? [])..add(event.image);
    emit(state.copyWith(uploadedImages: images));
  }

  void _onRemoveImage(
    RemoveImageEvent event,
    Emitter<FeedbackState> emit,
  ) {
    final images = List<UploadedImage>.from(state.uploadedImages ?? [])..removeAt(event.index);
    emit(state.copyWith(uploadedImages: images));
  }

  Future<void> _onSubmitFeedback(
    SubmitFeedbackEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    if (state.selectedType == null || state.content.isEmpty) {
      emit(state.copyWith(
        status: FeedbackStatus.error,
        errorMessage: '请选择反馈类型并填写反馈内容',
      ));
      return;
    }

    emit(state.copyWith(status: FeedbackStatus.loading));
    try {
      final success = await _repository.submitFeedback(
        type: state.selectedType!,
        content: state.content,
        images: state.uploadedImages,
      );
      if (success) {
        emit(state.copyWith(status: FeedbackStatus.success));
      } else {
        emit(state.copyWith(
          status: FeedbackStatus.error,
          errorMessage: '提交失败，请稍后再试',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: FeedbackStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}

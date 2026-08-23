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
import 'package:beaver/features/moment/post/bloc/event.dart';
import 'package:beaver/features/moment/post/bloc/state.dart';
import 'package:beaver/features/moment/post/data/repositories/repository.dart';
import 'package:beaver/types/api/moment.dart';

class PostMomentBloc extends Bloc<PostMomentEvent, PostMomentState> {
  final PostMomentRepository _postMomentRepository;

  PostMomentBloc({PostMomentRepository? postMomentRepository}) 
    : _postMomentRepository = postMomentRepository ?? PostMomentRepository(),
      super(const PostMomentState()) {
    on<UpdateContentEvent>(_onUpdateContent);
    on<AddImageEvent>(_onAddImage);
    on<RemoveImageEvent>(_onRemoveImage);
    on<PreviewImageEvent>(_onPreviewImage);
    on<PostMomentSubmitEvent>(_onPostMomentSubmit);
  }

  Future<void> _onUpdateContent(
    UpdateContentEvent event,
    Emitter<PostMomentState> emit,
  ) async {
    emit(state.copyWith(content: event.content));
  }

  Future<void> _onAddImage(
    AddImageEvent event,
    Emitter<PostMomentState> emit,
  ) async {
    if (state.mediaList.length >= 9) {
      emit(state.copyWith(errorMessage: '最多只能上传9张图片'));
      return;
    }

    final localPath = event.imagePath;
    final withLocal = List<String>.from(state.mediaList)..add(localPath);
    emit(state.copyWith(mediaList: withLocal));

    final uploadedUrl = await _postMomentRepository.uploadImage(localPath);
    final finalList = List<String>.from(withLocal);
    final index = finalList.indexOf(localPath);

    if (uploadedUrl.isEmpty || index == -1) {
      finalList.remove(localPath);
      emit(state.copyWith(
        mediaList: finalList,
        errorMessage: '上传图片失败',
      ));
      return;
    }

    finalList[index] = uploadedUrl;
    emit(state.copyWith(mediaList: finalList));
  }

  Future<void> _onRemoveImage(
    RemoveImageEvent event,
    Emitter<PostMomentState> emit,
  ) async {
    final updatedMediaList = List<String>.from(state.mediaList);
    updatedMediaList.removeAt(event.index);
    emit(state.copyWith(mediaList: updatedMediaList));
  }

  Future<void> _onPreviewImage(
    PreviewImageEvent event,
    Emitter<PostMomentState> emit,
  ) async {
    // 图片预览逻辑
  }

  Future<void> _onPostMomentSubmit(
    PostMomentSubmitEvent event,
    Emitter<PostMomentState> emit,
  ) async {
    if (!state.canPost) {
      emit(state.copyWith(
        errorMessage: '请输入内容或添加图片',
      ));
      return;
    }

    emit(state.copyWith(status: PostMomentStatus.loading));

    try {
      final request = ICreateMomentReq(
        content: state.content,
        files: state.mediaList.map((url) => IMomentFileModel(fileKey: url, type: 2)).toList(), // 2=IMAGE
      );
      await _postMomentRepository.createMoment(request);
      emit(state.copyWith(
        status: PostMomentStatus.success,
        errorMessage: '发布成功',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PostMomentStatus.error,
        errorMessage: '发布失败: $e',
      ));
    }
  }
}

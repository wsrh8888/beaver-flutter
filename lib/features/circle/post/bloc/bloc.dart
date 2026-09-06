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
import 'package:beaver/features/circle/post/bloc/event.dart';
import 'package:beaver/features/circle/post/bloc/state.dart';
import 'package:beaver/features/circle/post/data/repositories/repository.dart';
import 'package:beaver/types/api/circle.dart';
import 'package:beaver/common/logger/index.dart';

final _logger = Logger('circle-post');

class CirclePostBloc extends Bloc<CirclePostEvent, CirclePostState> {
  final CirclePostRepository _repository;
  final String circleId;

  CirclePostBloc({
    required this.circleId,
    CirclePostRepository? repository,
  })  : _repository = repository ?? CirclePostRepository(),
        super(const CirclePostState()) {
    on<UpdateCirclePostTitleEvent>(_onUpdateTitle);
    on<UpdateCirclePostContentEvent>(_onUpdateContent);
    on<AddCirclePostImageEvent>(_onAddImage);
    on<RemoveCirclePostImageEvent>(_onRemoveImage);
    on<SubmitCirclePostEvent>(_onSubmit);
  }

  void _onUpdateTitle(
    UpdateCirclePostTitleEvent event,
    Emitter<CirclePostState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onUpdateContent(
    UpdateCirclePostContentEvent event,
    Emitter<CirclePostState> emit,
  ) {
    emit(state.copyWith(content: event.content));
  }

  Future<void> _onAddImage(
    AddCirclePostImageEvent event,
    Emitter<CirclePostState> emit,
  ) async {
    if (state.mediaList.length >= 9) {
      emit(state.copyWith(errorMessage: '最多只能上传9张图片'));
      return;
    }

    final localPath = event.imagePath;
    final withLocal = List<String>.from(state.mediaList)..add(localPath);
    emit(state.copyWith(mediaList: withLocal));

    _logger.info({'text': '开始上传帖子图片', 'data': {'localPath': localPath}});
    final uploadedUrl = await _repository.uploadImage(localPath);
    final finalList = List<String>.from(withLocal);
    final index = finalList.indexOf(localPath);

    if (uploadedUrl.isEmpty || index == -1) {
      _logger.error({
        'text': '上传帖子图片失败',
        'data': {'localPath': localPath, 'uploadedUrl': uploadedUrl},
      });
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

  void _onRemoveImage(
    RemoveCirclePostImageEvent event,
    Emitter<CirclePostState> emit,
  ) {
    final updated = List<String>.from(state.mediaList)..removeAt(event.index);
    emit(state.copyWith(mediaList: updated));
  }

  Future<void> _onSubmit(
    SubmitCirclePostEvent event,
    Emitter<CirclePostState> emit,
  ) async {
    if (!state.canPost) {
      emit(state.copyWith(errorMessage: '请输入内容或添加图片'));
      return;
    }

    final hasLocal = state.mediaList.any((e) => !e.startsWith('http'));
    if (hasLocal) {
      emit(state.copyWith(errorMessage: '图片上传中，请稍候'));
      return;
    }

    _logger.info({
      'text': '开始发布帖子',
      'data': {
        'circleId': circleId,
        'contentLength': state.content.trim().length,
        'imageCount': state.mediaList.length,
      },
    });
    emit(state.copyWith(status: CirclePostStatus.loading));

    final files = state.mediaList
        .map((url) => ICirclePostFile(fileKey: url, type: 2))
        .toList();

    final res = await _repository.createPost(
      circleId: circleId,
      content: state.content.trim(),
      files: files.isEmpty ? null : files,
    );

    if (res.code != 0) {
      _logger.error({
        'text': '发布帖子失败',
        'data': {'circleId': circleId, 'code': res.code, 'msg': res.msg},
      });
      emit(state.copyWith(
        status: CirclePostStatus.error,
        errorMessage: res.msg.isNotEmpty ? res.msg : '发布失败',
      ));
      return;
    }

    _logger.info({'text': '发布帖子成功', 'data': {'circleId': circleId}});
    emit(state.copyWith(status: CirclePostStatus.success));
  }
}

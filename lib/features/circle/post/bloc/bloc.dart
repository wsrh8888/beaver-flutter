import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/circle/post/bloc/event.dart';
import 'package:beaver/features/circle/post/bloc/state.dart';
import 'package:beaver/features/circle/post/data/repositories/repository.dart';
import 'package:beaver/types/api/circle.dart';

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

    final uploadedUrl = await _repository.uploadImage(localPath);
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

    emit(state.copyWith(status: CirclePostStatus.loading));

    final title = state.title.trim();
    final files = state.mediaList
        .map((url) => ICirclePostFile(fileKey: url, type: 2))
        .toList();

    final res = await _repository.createPost(
      circleId: circleId,
      title: title.isEmpty ? null : title,
      content: state.content.trim(),
      files: files.isEmpty ? null : files,
    );

    if (res.code != 0) {
      emit(state.copyWith(
        status: CirclePostStatus.error,
        errorMessage: res.msg.isNotEmpty ? res.msg : '发布失败',
      ));
      return;
    }

    emit(state.copyWith(status: CirclePostStatus.success));
  }
}

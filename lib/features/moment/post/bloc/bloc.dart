import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/moment/post/bloc/event.dart';
import 'package:beaver/features/moment/post/bloc/state.dart';
import 'package:beaver/features/moment/post/data/repositories/repository.dart';
import 'package:beaver/features/moment/post/data/models/post.dart';

class PostMomentBloc extends Bloc<PostMomentEvent, PostMomentState> {
  final PostMomentRepository _repository;

  PostMomentBloc(this._repository) : super(const PostMomentState()) {
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
      emit(state.copyWith(
        errorMessage: '最多只能上�?张图�?,
      ));
      return;
    }

    try {
      final uploadedUrl = await _repository.uploadImage(event.imagePath);
      final updatedMediaList = List<String>.from(state.mediaList);
      updatedMediaList.add(uploadedUrl);
      emit(state.copyWith(mediaList: updatedMediaList));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: '上传图片失败: $e',
      ));
    }
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
      final request = PostMomentRequest(
        content: state.content,
        files: state.mediaList.map((url) => PostMomentFile(url)).toList(),
      );
      await _repository.createMoment(request);
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


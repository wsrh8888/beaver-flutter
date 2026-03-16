import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/feedback/feedback_page/bloc/event.dart';
import 'package:beaver/features/feedback/feedback_page/bloc/state.dart';
import 'package:beaver/features/feedback/feedback_page/data/repositories/repository.dart';

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

  Future<void> _onLoadFeedbackTypes(
    LoadFeedbackTypesEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(state.copyWith(status: FeedbackStatus.loading));

    try {
      final feedbackTypes = await _repository.getFeedbackTypes();
      emit(state.copyWith(
        status: FeedbackStatus.success,
        feedbackTypes: feedbackTypes,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FeedbackStatus.error,
        errorMessage: '加载反馈类型失败: $e',
      ));
    }
  }

  Future<void> _onSelectFeedbackType(
    SelectFeedbackTypeEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(state.copyWith(selectedType: event.type));
  }

  Future<void> _onUpdateContent(
    UpdateContentEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(state.copyWith(
      content: event.content,
      charCount: event.content.length,
    ));
  }

  Future<void> _onAddImage(
    AddImageEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    if (state.uploadedImages.length >= 3) return;

    final uploadedImages = List<UploadedImage>.from(state.uploadedImages);
    uploadedImages.add(event.image);
    emit(state.copyWith(uploadedImages: uploadedImages));
  }

  Future<void> _onRemoveImage(
    RemoveImageEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    final uploadedImages = List<UploadedImage>.from(state.uploadedImages);
    if (event.index >= 0 && event.index < uploadedImages.length) {
      uploadedImages.removeAt(event.index);
      emit(state.copyWith(uploadedImages: uploadedImages));
    }
  }

  Future<void> _onSubmitFeedback(
    SubmitFeedbackEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    if (state.selectedType == null || state.content.trim().isEmpty) {
      emit(state.copyWith(
        status: FeedbackStatus.error,
        errorMessage: '请选择反馈类型并填写反馈内容',
      ));
      return;
    }

    emit(state.copyWith(status: FeedbackStatus.loading));

    try {
      await _repository.submitFeedback(
        type: state.selectedType!,
        content: state.content,
        images: state.uploadedImages,
      );
      emit(state.copyWith(status: FeedbackStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FeedbackStatus.error,
        errorMessage: '提交反馈失败: $e',
      ));
    }
  }
}

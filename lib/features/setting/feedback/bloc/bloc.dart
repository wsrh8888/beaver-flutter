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

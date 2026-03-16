import 'package:beaver/features/feedback/feedback_page/data/models/feedback.dart';

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

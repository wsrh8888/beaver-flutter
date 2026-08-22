import 'package:equatable/equatable.dart';

enum CirclePostStatus { initial, loading, success, error }

class CirclePostState extends Equatable {
  final CirclePostStatus status;
  final String title;
  final String content;
  final List<String> mediaList;
  final String? errorMessage;

  const CirclePostState({
    this.status = CirclePostStatus.initial,
    this.title = '',
    this.content = '',
    this.mediaList = const [],
    this.errorMessage,
  });

  bool get canPost =>
      content.trim().isNotEmpty || mediaList.isNotEmpty;

  CirclePostState copyWith({
    CirclePostStatus? status,
    String? title,
    String? content,
    List<String>? mediaList,
    String? errorMessage,
  }) {
    return CirclePostState(
      status: status ?? this.status,
      title: title ?? this.title,
      content: content ?? this.content,
      mediaList: mediaList ?? this.mediaList,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, title, content, mediaList, errorMessage];
}

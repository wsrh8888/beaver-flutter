import 'package:equatable/equatable.dart';

abstract class CirclePostEvent extends Equatable {
  const CirclePostEvent();

  @override
  List<Object?> get props => [];
}

class UpdateCirclePostTitleEvent extends CirclePostEvent {
  final String title;

  const UpdateCirclePostTitleEvent(this.title);

  @override
  List<Object?> get props => [title];
}

class UpdateCirclePostContentEvent extends CirclePostEvent {
  final String content;

  const UpdateCirclePostContentEvent(this.content);

  @override
  List<Object?> get props => [content];
}

class AddCirclePostImageEvent extends CirclePostEvent {
  final String imagePath;

  const AddCirclePostImageEvent(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class RemoveCirclePostImageEvent extends CirclePostEvent {
  final int index;

  const RemoveCirclePostImageEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class SubmitCirclePostEvent extends CirclePostEvent {
  const SubmitCirclePostEvent();
}

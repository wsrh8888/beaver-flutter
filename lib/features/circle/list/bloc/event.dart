import 'package:equatable/equatable.dart';

abstract class CircleListEvent extends Equatable {
  const CircleListEvent();

  @override
  List<Object?> get props => [];
}

class LoadCircleListEvent extends CircleListEvent {
  const LoadCircleListEvent();
}

class CreateCircleEvent extends CircleListEvent {
  final String name;
  final String? avatarPath;

  const CreateCircleEvent({required this.name, this.avatarPath});

  @override
  List<Object?> get props => [name, avatarPath];
}

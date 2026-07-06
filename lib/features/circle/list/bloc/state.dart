import 'package:equatable/equatable.dart';
import 'package:beaver/types/api/circle.dart';

enum CircleListStatus { initial, loading, success, error }

class CircleListState extends Equatable {
  final CircleListStatus status;
  final List<ICircleListItem> circles;
  final String? errorMessage;

  const CircleListState({
    this.status = CircleListStatus.initial,
    this.circles = const [],
    this.errorMessage,
  });

  CircleListState copyWith({
    CircleListStatus? status,
    List<ICircleListItem>? circles,
    String? errorMessage,
  }) {
    return CircleListState(
      status: status ?? this.status,
      circles: circles ?? this.circles,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, circles, errorMessage];
}

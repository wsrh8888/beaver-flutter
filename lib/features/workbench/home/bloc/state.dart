import 'package:equatable/equatable.dart';
import 'package:beaver/types/api/workbench.dart';

enum WorkbenchHomeStatus { initial, loading, success, error }

class WorkbenchHomeState extends Equatable {
  final WorkbenchHomeStatus status;
  final List<IWorkbenchAppGroup> groups;
  final String? errorMessage;

  const WorkbenchHomeState({
    this.status = WorkbenchHomeStatus.initial,
    this.groups = const [],
    this.errorMessage,
  });

  bool get isEmpty => !groups.any((g) => g.list.isNotEmpty);

  WorkbenchHomeState copyWith({
    WorkbenchHomeStatus? status,
    List<IWorkbenchAppGroup>? groups,
    String? errorMessage,
  }) {
    return WorkbenchHomeState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, groups, errorMessage];
}

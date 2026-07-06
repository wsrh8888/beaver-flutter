import 'package:equatable/equatable.dart';
import 'package:beaver/types/api/workbench.dart';

enum WorkbenchHomeStatus { initial, loading, success, error }

class WorkbenchHomeState extends Equatable {
  final WorkbenchHomeStatus status;
  final List<IWorkbenchAppItem> appList;
  final String? errorMessage;

  const WorkbenchHomeState({
    this.status = WorkbenchHomeStatus.initial,
    this.appList = const [],
    this.errorMessage,
  });

  WorkbenchHomeState copyWith({
    WorkbenchHomeStatus? status,
    List<IWorkbenchAppItem>? appList,
    String? errorMessage,
  }) {
    return WorkbenchHomeState(
      status: status ?? this.status,
      appList: appList ?? this.appList,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, appList, errorMessage];
}

import 'package:equatable/equatable.dart';

abstract class WorkbenchHomeEvent extends Equatable {
  const WorkbenchHomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadWorkbenchHomeEvent extends WorkbenchHomeEvent {
  const LoadWorkbenchHomeEvent();
}

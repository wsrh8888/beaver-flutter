import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class UpdateStoreState extends Equatable {
  final String? version;

  const UpdateStoreState({
    this.version,
  });

  UpdateStoreState copyWith({
    String? version,
  }) {
    return UpdateStoreState(
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [version];
}

class UpdateStore extends Cubit<UpdateStoreState> {
  UpdateStore() : super(const UpdateStoreState());

  Future<void> init() async {
    // 检查更新逻辑
  }
}

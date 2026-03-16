import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/setting/legal/disclaimer/bloc/event.dart';
import 'package:beaver/features/setting/legal/disclaimer/bloc/state.dart';
import 'package:beaver/features/setting/legal/disclaimer/data/repositories/repository.dart';

class DisclaimerBloc extends Bloc<DisclaimerEvent, DisclaimerState> {
  final DisclaimerRepository _repository;

  DisclaimerBloc(this._repository) : super(const DisclaimerState()) {
    on<LoadDisclaimerEvent>(_onLoadDisclaimer);
  }

  Future<void> _onLoadDisclaimer(
    LoadDisclaimerEvent event,
    Emitter<DisclaimerState> emit,
  ) async {
    emit(state.copyWith(status: DisclaimerStatus.loading));

    try {
      final projectLinks = await _repository.getProjectLinks();
      final authorInfo = await _repository.getAuthorInfo();
      emit(state.copyWith(
        status: DisclaimerStatus.success,
        projectLinks: projectLinks,
        authorInfo: authorInfo,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DisclaimerStatus.error,
        errorMessage: '加载声明信息失败: $e',
      ));
    }
  }
}


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/setting/legal/privacy/bloc/event.dart';
import 'package:beaver/features/setting/legal/privacy/bloc/state.dart';
import 'package:beaver/features/setting/legal/privacy/data/repositories/repository.dart';

class PrivacyBloc extends Bloc<PrivacyEvent, PrivacyState> {
  final PrivacyRepository _repository;

  PrivacyBloc(this._repository) : super(const PrivacyState()) {
    on<LoadPrivacyPolicyEvent>(_onLoadPrivacyPolicy);
  }

  Future<void> _onLoadPrivacyPolicy(
    LoadPrivacyPolicyEvent event,
    Emitter<PrivacyState> emit,
  ) async {
    emit(state.copyWith(status: PrivacyStatus.loading));

    try {
      final privacyPolicy = await _repository.getPrivacyPolicy();
      emit(state.copyWith(
        status: PrivacyStatus.success,
        privacyPolicy: privacyPolicy,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PrivacyStatus.error,
        errorMessage: '加载隐私政策失败: $e',
      ));
    }
  }
}


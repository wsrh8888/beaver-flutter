import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/setting/agreement/bloc/event.dart';
import 'package:beaver/features/setting/agreement/bloc/state.dart';
import 'package:beaver/features/setting/agreement/data/repositories/repository.dart';

class AgreementBloc extends Bloc<AgreementEvent, AgreementState> {
  final AgreementRepository _repository;

  AgreementBloc(this._repository) : super(const AgreementState()) {
    on<LoadAgreementEvent>(_onLoadAgreement);
  }

  Future<void> _onLoadAgreement(
    LoadAgreementEvent event,
    Emitter<AgreementState> emit,
  ) async {
    emit(state.copyWith(status: AgreementStatus.loading));

    try {
      final agreement = await _repository.getAgreement();
      emit(state.copyWith(
        status: AgreementStatus.success,
        agreement: agreement,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AgreementStatus.error,
        errorMessage: '加载协议失败: $e',
      ));
    }
  }
}
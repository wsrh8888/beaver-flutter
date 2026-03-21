import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/call/call.dart';

class CallStoreState extends Equatable {
  final String? currentCallId;

  const CallStoreState({
    this.currentCallId,
  });

  CallStoreState copyWith({
    String? currentCallId,
  }) {
    return CallStoreState(
      currentCallId: currentCallId ?? this.currentCallId,
    );
  }

  @override
  List<Object?> get props => [currentCallId];
}

class CallStore extends Cubit<CallStoreState> {
  final CallBusiness _callBusiness;
  
  CallStore({CallBusiness? callBusiness}) 
    : _callBusiness = callBusiness ?? getIt<CallBusiness>(),
      super(const CallStoreState());

  Future<void> init() async {
    // 业务层挂载 (消除 unused lint)
    // print('CallStore: 业务层就绪 ${ _callBusiness.runtimeType }');
  }

  // 暴露业务层
  CallBusiness get business => _callBusiness;
}

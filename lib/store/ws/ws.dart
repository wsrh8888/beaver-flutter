import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum WsConnectionStatus {
  connected,
  connecting,
  syncing,
  disconnected,
}

class WsStoreState extends Equatable {
  final WsConnectionStatus status;

  const WsStoreState({this.status = WsConnectionStatus.disconnected});

  bool get showBanner => status != WsConnectionStatus.connected;

  String get bannerText {
    switch (status) {
      case WsConnectionStatus.connecting:
        return '连接中...';
      case WsConnectionStatus.syncing:
        return '收取中...';
      case WsConnectionStatus.disconnected:
        return '网络未连接';
      case WsConnectionStatus.connected:
        return '';
    }
  }

  WsStoreState copyWith({WsConnectionStatus? status}) {
    return WsStoreState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}

class WsStore extends Cubit<WsStoreState> {
  WsStore() : super(const WsStoreState(status: WsConnectionStatus.connecting));

  void setConnecting() {
    if (state.status == WsConnectionStatus.connecting) return;
    emit(state.copyWith(status: WsConnectionStatus.connecting));
  }

  void setSyncing() {
    emit(state.copyWith(status: WsConnectionStatus.syncing));
  }

  void setConnected() {
    emit(state.copyWith(status: WsConnectionStatus.connected));
  }

  void setDisconnected() {
    emit(state.copyWith(status: WsConnectionStatus.disconnected));
  }
}

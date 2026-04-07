import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/common/webview/bloc/event.dart';
import 'package:beaver/features/common/webview/bloc/state.dart';

class WebViewBloc extends Bloc<WebViewEvent, WebViewState> {
  WebViewBloc({required String url}) : super(WebViewState(url: url)) {
    on<WebViewProgressChanged>(_onProgressChanged);
    on<WebViewPageStarted>(_onPageStarted);
    on<WebViewPageFinished>(_onPageFinished);
    on<WebViewErrorOccurred>(_onErrorOccurred);
  }

  void _onProgressChanged(WebViewProgressChanged event, Emitter<WebViewState> emit) {
    emit(state.copyWith(progress: event.progress));
  }

  void _onPageStarted(WebViewPageStarted event, Emitter<WebViewState> emit) {
    emit(state.copyWith(status: WebViewStatus.loading, progress: 0));
  }

  void _onPageFinished(WebViewPageFinished event, Emitter<WebViewState> emit) {
    emit(state.copyWith(status: WebViewStatus.success, progress: 100));
  }

  void _onErrorOccurred(WebViewErrorOccurred event, Emitter<WebViewState> emit) {
    emit(state.copyWith(status: WebViewStatus.error, errorMessage: event.errorMessage));
  }
}

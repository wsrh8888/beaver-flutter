import 'package:equatable/equatable.dart';

abstract class WebViewEvent extends Equatable {
  const WebViewEvent();

  @override
  List<Object?> get props => [];
}

class WebViewProgressChanged extends WebViewEvent {
  final double progress;
  const WebViewProgressChanged(this.progress);

  @override
  List<Object?> get props => [progress];
}

class WebViewPageStarted extends WebViewEvent {}

class WebViewPageFinished extends WebViewEvent {}

class WebViewErrorOccurred extends WebViewEvent {
  final String errorMessage;
  const WebViewErrorOccurred(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

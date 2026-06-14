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

class WebViewPageFinished extends WebViewEvent {
  final String? pageTitle;
  const WebViewPageFinished({this.pageTitle});

  @override
  List<Object?> get props => [pageTitle];
}

class WebViewErrorOccurred extends WebViewEvent {
  final String errorMessage;
  const WebViewErrorOccurred(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

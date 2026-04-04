import 'package:equatable/equatable.dart';

enum WebViewStatus { initial, loading, success, error }

class WebViewState extends Equatable {
  final WebViewStatus status;
  final String url;
  final double progress;
  final String? errorMessage;

  const WebViewState({
    this.status = WebViewStatus.initial,
    required this.url,
    this.progress = 0,
    this.errorMessage,
  });

  WebViewState copyWith({
    WebViewStatus? status,
    String? url,
    double? progress,
    String? errorMessage,
  }) {
    return WebViewState(
      status: status ?? this.status,
      url: url ?? this.url,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, url, progress, errorMessage];
}

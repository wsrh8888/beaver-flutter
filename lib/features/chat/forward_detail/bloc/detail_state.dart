import 'package:equatable/equatable.dart';
import 'package:beaver/types/business/message.dart';

enum ForwardDetailStatus { initial, loading, success, failure }

class ForwardDetailState extends Equatable {
  final ForwardDetailStatus status;
  final String title;
  final List<MessageModel> messages;
  final String? error;

  const ForwardDetailState({
    this.status = ForwardDetailStatus.initial,
    this.title = '',
    this.messages = const [],
    this.error,
  });

  ForwardDetailState copyWith({
    ForwardDetailStatus? status,
    String? title,
    List<MessageModel>? messages,
    String? error,
  }) {
    return ForwardDetailState(
      status: status ?? this.status,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, title, messages, error];
}

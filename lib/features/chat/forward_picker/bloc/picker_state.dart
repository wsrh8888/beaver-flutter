import 'package:equatable/equatable.dart';
import 'package:beaver/types/business/user.dart';

enum ForwardPickerStatus { initial, loading, success, failure, executing, completed }

class ForwardPickerState extends Equatable {
  final ForwardPickerStatus status;
  final List<UserInfo> contacts;
  final String? error;

  const ForwardPickerState({
    this.status = ForwardPickerStatus.initial,
    this.contacts = const [],
    this.error,
  });

  ForwardPickerState copyWith({
    ForwardPickerStatus? status,
    List<UserInfo>? contacts,
    String? error,
  }) {
    return ForwardPickerState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, contacts, error];
}

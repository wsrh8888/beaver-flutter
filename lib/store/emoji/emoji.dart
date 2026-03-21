import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class EmojiStoreState extends Equatable {
  final List<dynamic> customEmojis;

  const EmojiStoreState({
    this.customEmojis = const [],
  });

  EmojiStoreState copyWith({
    List<dynamic>? customEmojis,
  }) {
    return EmojiStoreState(
      customEmojis: customEmojis ?? this.customEmojis,
    );
  }

  @override
  List<Object?> get props => [customEmojis];
}

class EmojiStore extends Cubit<EmojiStoreState> {
  EmojiStore() : super(const EmojiStoreState());

  Future<void> init() async {
    // 加载表情逻辑
    emit(state.copyWith(customEmojis: []));
  }
}

import 'package:beaver/features/discover/main/data/models/discover.dart';

enum DiscoverStatus { initial, loading, success, error }

class DiscoverState {
  final DiscoverStatus status;
  final List<DiscoverItem> discoverItems;
  final String? errorMessage;

  const DiscoverState({
    this.status = DiscoverStatus.initial,
    this.discoverItems = const [],
    this.errorMessage,
  });

  DiscoverState copyWith({
    DiscoverStatus? status,
    List<DiscoverItem>? discoverItems,
    String? errorMessage,
  }) {
    return DiscoverState(
      status: status ?? this.status,
      discoverItems: discoverItems ?? this.discoverItems,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


import 'package:beaver/types/api/moment.dart';

abstract class MomentListEvent {
  const MomentListEvent();
}

class LoadMomentListEvent extends MomentListEvent {
  final bool refresh;
  const LoadMomentListEvent({this.refresh = false});
}

class ToggleLikeMomentEvent extends MomentListEvent {
  final IMomentListItem moment;
  final String currentUserId;
  final String currentUserName;

  const ToggleLikeMomentEvent({
    required this.moment,
    required this.currentUserId,
    required this.currentUserName,
  });
}

abstract class DiscoverEvent {
  const DiscoverEvent();
}

class LoadDiscoverItemsEvent extends DiscoverEvent {
  const LoadDiscoverItemsEvent();
}

class NavigateToEvent extends DiscoverEvent {
  final String route;

  const NavigateToEvent(this.route);
}

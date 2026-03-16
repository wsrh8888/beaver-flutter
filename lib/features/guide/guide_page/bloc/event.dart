abstract class GuideEvent {
  const GuideEvent();
}

class LoadGuideConfigEvent extends GuideEvent {
  const LoadGuideConfigEvent();
}

class NavigateToRegisterEvent extends GuideEvent {
  const NavigateToRegisterEvent();
}

class NavigateToLoginEvent extends GuideEvent {
  const NavigateToLoginEvent();
}

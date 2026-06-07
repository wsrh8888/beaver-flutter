import 'package:equatable/equatable.dart';

abstract class OAuthScanConfirmEvent extends Equatable {
  const OAuthScanConfirmEvent();

  @override
  List<Object?> get props => [];
}

class OAuthScanConfirmInitEvent extends OAuthScanConfirmEvent {
  final String sceneId;

  const OAuthScanConfirmInitEvent(this.sceneId);

  @override
  List<Object?> get props => [sceneId];
}

class OAuthScanConfirmSubmitEvent extends OAuthScanConfirmEvent {
  const OAuthScanConfirmSubmitEvent();
}

class OAuthScanConfirmCancelEvent extends OAuthScanConfirmEvent {
  const OAuthScanConfirmCancelEvent();
}

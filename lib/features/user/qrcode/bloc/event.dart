abstract class QrcodeEvent {
  const QrcodeEvent();
}

class LoadQrCodeEvent extends QrcodeEvent {
  const LoadQrCodeEvent();
}

class SaveQrCodeEvent extends QrcodeEvent {
  const SaveQrCodeEvent();
}

import 'package:beaver/features/qrcode/qrcode_page/data/models/qrcode.dart';

enum QrcodeStatus { initial, loading, success, error }

class QrcodeState {
  final QrcodeStatus status;
  final QrCodeData? qrCodeData;
  final String? errorMessage;

  const QrcodeState({
    this.status = QrcodeStatus.initial,
    this.qrCodeData,
    this.errorMessage,
  });

  QrcodeState copyWith({
    QrcodeStatus? status,
    QrCodeData? qrCodeData,
    String? errorMessage,
  }) {
    return QrcodeState(
      status: status ?? this.status,
      qrCodeData: qrCodeData ?? this.qrCodeData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

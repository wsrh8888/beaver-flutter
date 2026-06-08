import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:beaver/features/common/scan/bloc/bloc.dart';
import 'package:beaver/features/common/scan/bloc/event.dart';
import 'package:beaver/features/common/scan/bloc/state.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/shared/utils/qrcode/index.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with SingleTickerProviderStateMixin {
  late ScanBloc _bloc;
  final MobileScannerController _controller = MobileScannerController();
  final ImagePicker _imagePicker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _bloc = ScanBloc()..add(CheckPermissionEvent());
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _bloc.close();
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<ScanBloc, ScanState>(
        listener: (context, state) {
          if (state.status == ScanStatus.success && state.result != null) {
            handleQrCode(context, state.result!);
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '扫一扫',
            showBack: true,
            onBack: () => context.pop(),
            showBackground: false,
            isScrollable: false,
            child: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(ScanState state) {
    if (state.status == ScanStatus.permissionDenied) {
      return _buildPermissionDeniedView();
    }

    if (state.status == ScanStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: (capture) {
            if (state.status == ScanStatus.success) return;
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              final String? code = barcode.rawValue;
              if (code != null) {
                _bloc.add(ScanResultEvent(code));
                break;
              }
            }
          },
        ),
        _buildScannerOverlay(),
        Positioned(
          bottom: 40.w,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                icon: Icons.photo_library, // 相册
                onPressed: _pickImageFromGallery,
              ),
              SizedBox(width: 40.w),
              _buildActionButton(
                icon: state.isTorchOn ? Icons.flash_on : Icons.flash_off,
                onPressed: () {
                  _controller.toggleTorch();
                  _bloc.add(ToggleTorchEvent());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickImageFromGallery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null || !mounted) return;

    try {
      final capture = await _controller.analyzeImage(image.path);
      String? code;
      for (final barcode in capture?.barcodes ?? const <Barcode>[]) {
        final value = barcode.rawValue;
        if (value != null && value.isNotEmpty) {
          code = value;
          break;
        }
      }

      if (code == null) {
        if (mounted) BeaverToast.show(context, '未识别到二维码');
        return;
      }

      if (!mounted) return;
      handleQrCode(context, code);
    } on MobileScannerBarcodeException catch (e) {
      if (mounted) BeaverToast.show(context, e.message ?? '图片解析失败');
    }
  }

  Widget _buildScannerOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scanSize = 260.w;
        final scanLeft = (constraints.maxWidth - scanSize) / 2;
        final scanTop = constraints.maxHeight * 0.38 - scanSize / 2;
        final maskColor = Colors.black.withValues(alpha: 0.5);

        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: scanTop,
              child: ColoredBox(color: maskColor),
            ),
            Positioned(
              top: scanTop + scanSize,
              left: 0,
              right: 0,
              bottom: 0,
              child: ColoredBox(color: maskColor),
            ),
            Positioned(
              top: scanTop,
              left: 0,
              width: scanLeft,
              height: scanSize,
              child: ColoredBox(color: maskColor),
            ),
            Positioned(
              top: scanTop,
              left: scanLeft + scanSize,
              right: 0,
              height: scanSize,
              child: ColoredBox(color: maskColor),
            ),
            Positioned(
              left: scanLeft,
              top: scanTop,
              width: scanSize,
              height: scanSize,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.w,
                  ),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: Stack(
                  children: [
                    _buildCorner(Alignment.topLeft),
                    _buildCorner(Alignment.topRight),
                    _buildCorner(Alignment.bottomLeft),
                    _buildCorner(Alignment.bottomRight),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Positioned(
                          top: 10.w + (240.w * _animation.value),
                          left: 10.w,
                          right: 10.w,
                          child: Container(
                            height: 2.w,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFF7D45).withValues(alpha: 0),
                                  const Color(0xFFFF7D45),
                                  const Color(0xFFFF7D45).withValues(alpha: 0),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: scanTop + scanSize + 20.w,
              left: 0,
              right: 0,
              child: const Center(
                child: Text(
                  '将二维码放入框内，即可自动扫描',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCorner(Alignment alignment) {
    const double cornerSize = 20;
    const double cornerWidth = 4;
    return Align(
      alignment: alignment,
      child: Container(
        width: cornerSize.w,
        height: cornerSize.w,
        decoration: BoxDecoration(
          border: Border(
            top: (alignment == Alignment.topLeft || alignment == Alignment.topRight)
                ? BorderSide(color: const Color(0xFFFF7D45), width: cornerWidth.w)
                : BorderSide.none,
            bottom: (alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight)
                ? BorderSide(color: const Color(0xFFFF7D45), width: cornerWidth.w)
                : BorderSide.none,
            left: (alignment == Alignment.topLeft || alignment == Alignment.bottomLeft)
                ? BorderSide(color: const Color(0xFFFF7D45), width: cornerWidth.w)
                : BorderSide.none,
            right: (alignment == Alignment.topRight || alignment == Alignment.bottomRight)
                ? BorderSide(color: const Color(0xFFFF7D45), width: cornerWidth.w)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28.w),
      ),
    );
  }

  Widget _buildPermissionDeniedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.no_photography, size: 64, color: Colors.grey),
          SizedBox(height: 16.w),
          const Text('需要相机权限才能使用扫码功能'),
          SizedBox(height: 16.w),
          ElevatedButton(
            onPressed: () => openAppSettings(),
            child: const Text('去开启权限'),
          ),
        ],
      ),
    );
  }
}

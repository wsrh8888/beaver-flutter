import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/emoji/emoji.dart';
import 'package:beaver/types/business/emoji.dart';
import 'package:beaver/api/emoji.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class EmojiDetailScreen extends StatefulWidget {
  final String emojiId;

  const EmojiDetailScreen({super.key, required this.emojiId});

  @override
  State<EmojiDetailScreen> createState() => _EmojiDetailScreenState();
}

class _EmojiDetailScreenState extends State<EmojiDetailScreen> {
  EmojiModel? _emoji;
  bool _isLoading = true;
  bool _isCollecting = false;

  @override
  void initState() {
    super.initState();
    _loadEmoji();
  }

  Future<void> _loadEmoji() async {
    final service = getIt<EmojiBusinessInterface>();
    final emoji = await service.getEmojiById(widget.emojiId);
    setState(() {
      _emoji = emoji;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _emoji == null
              ? const Center(child: Text('表情不存在', style: TextStyle(color: Colors.white)))
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'emoji_${_emoji!.emojiId}',
                        child: BeaverCachedImage(
                          fileUrl: _emoji!.fileKey,
                          width: 250.w,
                          height: 250.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        _emoji?.name ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 50.h),
                      _buildActions(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(Icons.favorite_border, '添加收藏', _collectEmoji),
        SizedBox(width: 40.w),
        _buildActionButton(Icons.send, '发送', () {
          Navigator.pop(context);
        }),
      ],
    );
  }

  Future<void> _collectEmoji() async {
    final emoji = _emoji;
    if (emoji == null || _isCollecting) return;

    setState(() => _isCollecting = true);
    final res = await addEmojiApi({
      'fileKey': emoji.fileKey,
      'title': emoji.name.isNotEmpty ? emoji.name : '收藏表情',
    });
    if (!mounted) return;

    setState(() => _isCollecting = false);
    if (res.code == 0) {
      BeaverToast.show(context, '已添加到表情', type: ToastType.success);
    } else {
      BeaverToast.show(context, res.msg, type: ToastType.error);
    }
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28.sp),
          ),
          SizedBox(height: 8.h),
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
        ],
      ),
    );
  }
}

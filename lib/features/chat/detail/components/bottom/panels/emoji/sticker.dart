import 'package:beaver/features/chat/detail/bloc/bloc.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/types/business/message.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/store/emoji/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StickerGrid extends StatelessWidget {
  const StickerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<EmojiStore, EmojiStoreState>(
            builder: (context, state) {
              final favorites = state.favoriteEmojis;
              if (favorites.isEmpty) {
                return _buildEmptyState();
              }

              return GridView.builder(
                padding: EdgeInsets.all(12.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12.w,
                  crossAxisSpacing: 12.w,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final sticker = favorites[index];
                  return GestureDetector(
                    onTap: () {
                      final bloc = context.read<ChatBloc>();
                      bloc.add(SendMessageEvent(MessageContentModel(
                        type: MessageType.emoji,
                        emojiMsg: EmojiMsg(
                          fileKey: sticker.fileKey,
                          emojiId: sticker.emojiId,
                          packageId: sticker.packageId ?? '',
                          width: sticker.width ?? 120,
                          height: sticker.height ?? 120,
                        ),
                      )));
                      bloc.add(const DismissComposerEvent());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F2F6),
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      padding: EdgeInsets.all(8.w),
                      child: BeaverCachedImage(
                        fileKey: sticker.fileKey,
                        fit: BoxFit.contain,
                        placeholder: const Icon(Icons.image, color: Colors.grey),
                        enableFullscreen: false,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border, size: 48.w, color: Colors.grey[300]),
          SizedBox(height: 12.h),
          Text(
            '暂无收藏表情',
            style: TextStyle(color: Colors.grey[400], fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

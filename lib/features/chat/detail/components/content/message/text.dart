import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/utils/emoji.dart';
import 'package:beaver/shared/utils/invite/invite.dart';
import 'package:beaver/shared/utils/qrcode/handlers/join_circle/index.dart';
import 'package:beaver/shared/utils/qrcode/handlers/join_group/index.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TextMessage extends StatelessWidget {
  final TextMsg msg;
  final bool isSelf;
  final double? emojiSize;
  final double? fontSize;

  const TextMessage({
    super.key,
    required this.msg,
    this.isSelf = false,
    this.emojiSize,
    this.fontSize,
  });

  static final _emojiTokenPattern = RegExp(r'\[[^\]]+\]');
  static final _urlPattern = RegExp(
    r'(https?:\/\/[^\s]+|beaver:\/\/[^\s]+)',
    caseSensitive: false,
  );

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: fontSize ?? 15.sp, height: 1.4);
    final size = emojiSize ?? 35.w;
    final linkColor = isSelf
        ? const Color(0xFF1A73E8)
        : const Color(0xFF576B95);

    return Text.rich(
      TextSpan(
        style: style,
        children: _parseContent(context, msg.content, size, linkColor),
      ),
    );
  }

  List<InlineSpan> _parseContent(
    BuildContext context,
    String text,
    double size,
    Color linkColor,
  ) {
    final spans = <InlineSpan>[];
    var lastEnd = 0;

    for (final match in _emojiTokenPattern.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.addAll(
          _parsePlainWithLinks(
            context,
            text.substring(lastEnd, match.start),
            linkColor,
          ),
        );
      }

      final token = match.group(0)!;
      final assetPath = getEmojiPath(token);
      if (assetPath != null) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Image.asset(
                assetPath,
                width: size,
                height: size,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      } else {
        spans.addAll(_parsePlainWithLinks(context, token, linkColor));
      }

      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.addAll(
        _parsePlainWithLinks(context, text.substring(lastEnd), linkColor),
      );
    }

    if (spans.isEmpty) {
      spans.add(TextSpan(text: text));
    }

    return spans;
  }

  List<InlineSpan> _parsePlainWithLinks(
    BuildContext context,
    String text,
    Color linkColor,
  ) {
    if (text.isEmpty) return const [];

    final spans = <InlineSpan>[];
    var lastEnd = 0;

    for (final match in _urlPattern.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }

      final url = match.group(0)!;
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            onTap: () => _handleLinkTap(context, url),
            child: Text(
              url,
              style: TextStyle(
                color: linkColor,
                decoration: TextDecoration.underline,
                fontSize: fontSize ?? 15.sp,
                height: 1.4,
              ),
            ),
          ),
        ),
      );
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    if (spans.isEmpty) {
      spans.add(TextSpan(text: text));
    }

    return spans;
  }

  void _handleLinkTap(BuildContext context, String raw) {
    final invite = parseInviteRef(raw);
    if (invite != null) {
      final route = invite.kind == InviteKind.circle
          ? AppRoutes.circleJoin
          : AppRoutes.groupJoin;
      final uri = Uri(
        path: route,
        queryParameters: {'inviteCode': invite.code},
      );
      context.push(uri.toString());
      return;
    }

    final circleId = parseCircleIdFromShare(raw);
    if (circleId != null && circleId.isNotEmpty) {
      final uri = Uri(
        path: AppRoutes.circleJoin,
        queryParameters: {'circleId': circleId},
      );
      context.push(uri.toString());
      return;
    }

    final groupId = parseGroupIdFromShare(raw);
    if (groupId != null && groupId.isNotEmpty) {
      final uri = Uri(
        path: AppRoutes.groupJoin,
        queryParameters: {'groupId': groupId},
      );
      context.push(uri.toString());
      return;
    }

    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      context.push('${AppRoutes.webview}?url=${Uri.encodeComponent(raw)}');
    }
  }
}

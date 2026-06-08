import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/store/call/call_list.dart';
import 'package:beaver/store/chat/chat.dart';
import 'package:beaver/types/business/chat.dart';

class IncomingCallBanner extends StatelessWidget {
  const IncomingCallBanner({super.key});

  String _displayName(CallListItem call, List<ChatModel> conversations) {
    if (call.callType == 'group') {
      for (final conv in conversations) {
        if (conv.conversationId == call.conversationId &&
            conv.nickname.isNotEmpty) {
          return conv.nickname;
        }
      }
      return '群组通话';
    }
    return call.callerName ?? '未知用户';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallListStore, CallListStoreState>(
      builder: (context, callState) {
        final displayCalls = [
          ...callState.incomingCalls,
          ...callState.activeCalls,
        ];
        if (displayCalls.isEmpty) return const SizedBox.shrink();

        return BlocBuilder<ChatStore, ChatStoreState>(
          builder: (context, chatState) {
            return Column(
              children: displayCalls.map((call) {
                return Material(
                  color: const Color(0xFFE8F5E9),
                  child: InkWell(
                    onTap: () {
                      context.push(
                        AppRoutes.callIncoming,
                        extra: {
                          'conversationId': call.conversationId,
                          'roomId': call.roomId,
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.w,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFC8E6C9)),
                        ),
                      ),
                      child: Text(
                        '${_displayName(call, chatState.conversations)} 正在通话中',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF2E7D32),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}

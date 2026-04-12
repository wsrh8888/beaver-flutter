import 'dart:convert';
import 'package:beaver/api/chat.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class ForwardDetailBloc extends Bloc<ForwardDetailEvent, ForwardDetailState> {
  ForwardDetailBloc() : super(const ForwardDetailState()) {
    on<FetchForwardDetailEvent>(_onFetchDetail);
  }

  Future<void> _onFetchDetail(FetchForwardDetailEvent event, Emitter<ForwardDetailState> emit) async {
    emit(state.copyWith(status: ForwardDetailStatus.loading));

    final res = await getForwardDetailsApi(
      IGetForwardDetailsReq(recordId: event.recordId),
    );

    if (res.code == 0 && res.result != null) {
      final items = res.result!.list;
      final messages = items.map((item) {
        final msgJson = jsonDecode(item.msg);
        final msgContent = MessageContentModel.fromJson(msgJson);
        return MessageModel(
          id: item.messageId,
          conversationId: item.conversationId,
          userId: item.sendUserId,
          nickname: item.sender.nickName,
          avatar: item.sender.avatar,
          msg: msgContent,
          type: msgContent.type,
          status: MessageStatus.sent,
          createdAt: DateTime.fromMillisecondsSinceEpoch(item.createdAt * 1000),
          isSent: false,
        );
      }).toList();

      emit(state.copyWith(
        status: ForwardDetailStatus.success,
        title: res.result!.title,
        messages: messages,
      ));
    } else {
      emit(state.copyWith(
        status: ForwardDetailStatus.failure,
        error: res.msg,
      ));
    }
  }
}

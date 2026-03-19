import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/contact/detail/bloc/event.dart';
import 'package:beaver/features/contact/detail/bloc/state.dart';
import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/contact/detail/data/models/user_info.dart';

class ContactDetailBloc extends Bloc<DetailEvent, DetailState> {
  final _friendBusiness = getIt<FriendBusiness>();

  ContactDetailBloc() : super(const DetailState()) {
    on<LoadUserInfoEvent>(_onLoadUserInfo);
    on<ToggleMoreMenuEvent>(_onToggleMoreMenu);
    on<ShowEditNoteDialogEvent>(_onShowEditNoteDialog);
    on<CloseEditNoteDialogEvent>(_onCloseEditNoteDialog);
    on<SaveRemarkNameEvent>(_onSaveRemarkName);
    on<DeleteFriendEvent>(_onDeleteFriend);
    on<SendMessageEvent>(_onSendMessage);
    on<AudioCallEvent>(_onAudioCall);
    on<VideoCallEvent>(_onVideoCall);
  }

  Future<void> _onLoadUserInfo(
    LoadUserInfoEvent event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(status: DetailStatus.loading));

    try {
      // 模拟获取用户信息
      await Future.delayed(const Duration(seconds: 1));
      final userInfo = UserInfo(
        userId: event.userId,
        nickname: '张三',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=professional%20avatar%20portrait&size=512x512',
      );
      emit(state.copyWith(
        status: DetailStatus.success,
        userInfo: userInfo,
        isFriend: true, 
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DetailStatus.error,
        errorMessage: '加载用户信息失败: $e',
      ));
    }
  }

  Future<void> _onToggleMoreMenu(
    ToggleMoreMenuEvent event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(showMoreMenu: !state.showMoreMenu));
  }

  Future<void> _onShowEditNoteDialog(
    ShowEditNoteDialogEvent event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(
      showEditNoteDialog: true,
      newRemarkName: state.userInfo?.remarkName,
    ));
  }

  Future<void> _onCloseEditNoteDialog(
    CloseEditNoteDialogEvent event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(showEditNoteDialog: false));
  }

  Future<void> _onSaveRemarkName(
    SaveRemarkNameEvent event,
    Emitter<DetailState> emit,
  ) async {
    if (state.userInfo == null) return;

    emit(state.copyWith(status: DetailStatus.loading));

    try {
      // 模拟更新备注名称
      await Future.delayed(const Duration(seconds: 1));
      final updatedUserInfo = state.userInfo!.copyWith(remarkName: event.remarkName);
      emit(state.copyWith(
        status: DetailStatus.success,
        userInfo: updatedUserInfo,
        showEditNoteDialog: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DetailStatus.error,
        errorMessage: '更新备注失败: $e',
      ));
    }
  }

  Future<void> _onDeleteFriend(
    DeleteFriendEvent event,
    Emitter<DetailState> emit,
  ) async {
    if (state.userInfo == null) return;

    emit(state.copyWith(status: DetailStatus.loading));

    try {
      await _friendBusiness.deleteFriend(state.userInfo!.userId);
      emit(state.copyWith(
        status: DetailStatus.success,
        isFriend: false,
        showMoreMenu: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DetailStatus.error,
        errorMessage: '删除好友失败: $e',
      ));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<DetailState> emit,
  ) async {
    // 模拟发送消
    if (state.userInfo?.conversationId != null) {
      // 导航到聊天页
    }
  }

  Future<void> _onAudioCall(
    AudioCallEvent event,
    Emitter<DetailState> emit,
  ) async {
    // 模拟音频通话
  }

  Future<void> _onVideoCall(
    VideoCallEvent event,
    Emitter<DetailState> emit,
  ) async {
    // 模拟视频通话
  }
}


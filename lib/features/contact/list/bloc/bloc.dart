import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/contact/list/bloc/event.dart';
import 'package:beaver/features/contact/list/bloc/state.dart';
import 'package:beaver/features/contact/list/data/repositories/repository.dart';
import 'package:beaver/store/friend/friend.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactListRepository _contactListRepository;
  final FriendStore _friendStore;
  StreamSubscription? _friendSubscription;

  ContactListBloc({
    ContactListRepository? contactListRepository,
    FriendStore? friendStore,
  }) : _contactListRepository =
           contactListRepository ?? ContactListRepository(),
       _friendStore = friendStore ?? getIt<FriendStore>(),
       super(const ContactListState()) {
    on<LoadContactListEvent>(_onLoadContactList);
    on<UpdateCurrentIndexEvent>(_onUpdateCurrentIndex);

    // --- 响应式联动 (Reactive Linkage) ---
    // 监听全局 FriendStore，一旦好友列表组装完成或元数据变更，立即重新分组 UI
    _friendSubscription = _friendStore.stream.listen((friendState) {
      add(const LoadContactListEvent());
    });
  }

  @override
  Future<void> close() {
    _friendSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadContactList(
    LoadContactListEvent event,
    Emitter<ContactListState> emit,
  ) async {
    // 遵循规范：从 Global Store 获取已组装好的数据
    final contacts = _friendStore.state.friends;

    // 对于本地数据，不需要强制 Loading 状态，直接进行分组渲染
    // 如果数据为空，UI 会由 _buildEmptyState 处理

    try {
      final groupedContacts = _contactListRepository.groupContactsByLetter(
        contacts,
      );
      final indexList = _contactListRepository.getIndexList(groupedContacts);

      emit(
        state.copyWith(
          status: ContactListStatus.success,
          contacts: contacts,
          groupedContacts: groupedContacts,
          indexList: indexList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ContactListStatus.error,
          errorMessage: '处理联系人列表失败: $e',
        ),
      );
    }
  }

  void _onUpdateCurrentIndex(
    UpdateCurrentIndexEvent event,
    Emitter<ContactListState> emit,
  ) {
    emit(state.copyWith(currentIndex: event.index));
  }
}

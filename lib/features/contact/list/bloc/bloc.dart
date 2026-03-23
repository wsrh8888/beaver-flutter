import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/contact/list/bloc/event.dart';
import 'package:beaver/features/contact/list/bloc/state.dart';
import 'package:beaver/features/contact/list/data/repositories/repository.dart';
import 'package:beaver/store/friend/friend.dart';
import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/store/user/user.dart';

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
    _friendSubscription = _friendStore.stream
        .map((state) => state.friends)
        .distinct() // 只有当好友列表确实发生变化（由于 Equatable，这将按内容对比）时才触发
        .listen((friends) {
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
    final currentUserId = getIt<UserStore>().state.currentUserId;

    final groupedContacts = _contactListRepository.groupContactsByLetter(
      contacts,
    );
    final indexList = _contactListRepository.getIndexList(groupedContacts);

    // 获取未读数
    int friendCount = 0;
    int groupCount = 0;
    if (currentUserId.isNotEmpty) {
      friendCount = await getIt<FriendBusiness>().getUnreadFriendRequestCount(
        currentUserId,
      );
      groupCount = await getIt<GroupBusiness>()
          .getUnreadGroupNotificationCount(currentUserId);
    }

    emit(
      state.copyWith(
        status: ContactListStatus.success,
        contacts: contacts,
        groupedContacts: groupedContacts,
        indexList: indexList,
        friendRequestCount: friendCount,
        groupNotificationCount: groupCount,
      ),
    );
  }

  void _onUpdateCurrentIndex(
    UpdateCurrentIndexEvent event,
    Emitter<ContactListState> emit,
  ) {
    emit(state.copyWith(currentIndex: event.index));
  }
}

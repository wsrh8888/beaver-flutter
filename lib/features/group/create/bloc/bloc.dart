import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/group/create/bloc/event.dart';
import 'package:beaver/features/group/create/bloc/state.dart';
import 'package:beaver/features/group/create/data/repositories/repository.dart';
import 'package:beaver/store/friend/friend.dart';
import 'package:beaver/types/business/contact.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  final CreateGroupRepository _createGroupRepository;
  final FriendStore _friendStore;
  StreamSubscription? _friendSubscription;

  CreateGroupBloc({
    CreateGroupRepository? createGroupRepository,
    FriendStore? friendStore,
  }) : _createGroupRepository =
           createGroupRepository ?? CreateGroupRepository(),
       _friendStore = friendStore ?? getIt<FriendStore>(),
       super(const CreateGroupState()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<SelectContactEvent>(_onSelectContact);
    on<SearchContactsEvent>(_onSearchContacts);
    on<CreateGroupSubmitEvent>(_onCreateGroup);

    // 响应式监听：好友列表变化时自动刷新 UI
    _friendSubscription = _friendStore.stream.listen((_) {
      add(const LoadContactsEvent());
    });
  }

  @override
  Future<void> close() {
    _friendSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadContacts(
    LoadContactsEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    final contacts = _friendStore.state.friends;
    emit(state.copyWith(status: CreateGroupStatus.success, contacts: contacts));
  }

  Future<void> _onSelectContact(
    SelectContactEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    final selectedContacts = List<ContactModel>.from(state.selectedContacts);
    final index = selectedContacts.indexWhere(
      (c) => c.userId == event.contact.userId,
    );

    if (index == -1) {
      selectedContacts.add(event.contact);
    } else {
      selectedContacts.removeAt(index);
    }

    emit(state.copyWith(selectedContacts: selectedContacts));
  }

  Future<void> _onSearchContacts(
    SearchContactsEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onCreateGroup(
    CreateGroupSubmitEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    if (state.selectedContacts.isEmpty) {
      emit(
        state.copyWith(
          status: CreateGroupStatus.error,
          errorMessage: '请至少选择一个联系人',
        ),
      );
      return;
    }

    emit(state.copyWith(status: CreateGroupStatus.loading));

    try {
      final userIds = state.selectedContacts.map((c) => c.userId).toList();
      final groupId = await _createGroupRepository.createGroup(userIds);
      emit(state.copyWith(status: CreateGroupStatus.success, groupId: groupId));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateGroupStatus.error,
          errorMessage: '创建群组失败: $e',
        ),
      );
    }
  }
}

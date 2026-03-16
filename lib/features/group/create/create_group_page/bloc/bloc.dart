import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/createGroup/create_group_page/bloc/event.dart';
import 'package:beaver/features/createGroup/create_group_page/bloc/state.dart';
import 'package:beaver/features/createGroup/create_group_page/data/repositories/repository.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  final CreateGroupRepository _repository;

  CreateGroupBloc(this._repository) : super(const CreateGroupState()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<SelectContactEvent>(_onSelectContact);
    on<SearchContactsEvent>(_onSearchContacts);
    on<CreateGroupSubmitEvent>(_onCreateGroup);
  }

  Future<void> _onLoadContacts(
    LoadContactsEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    emit(state.copyWith(status: CreateGroupStatus.loading));

    try {
      final contacts = await _repository.getContacts();
      emit(state.copyWith(
        status: CreateGroupStatus.success,
        contacts: contacts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CreateGroupStatus.error,
        errorMessage: '加载联系人失败: $e',
      ));
    }
  }

  Future<void> _onSelectContact(
    SelectContactEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    final selectedContacts = List<Contact>.from(state.selectedContacts);
    final index = selectedContacts.indexWhere((c) => c.userId == event.contact.userId);

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
      emit(state.copyWith(
        status: CreateGroupStatus.error,
        errorMessage: '请至少选择一个联系人',
      ));
      return;
    }

    emit(state.copyWith(status: CreateGroupStatus.loading));

    try {
      final userIds = state.selectedContacts.map((c) => c.userId).toList();
      final groupId = await _repository.createGroup(userIds);
      emit(state.copyWith(
        status: CreateGroupStatus.success,
        groupId: groupId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CreateGroupStatus.error,
        errorMessage: '创建群组失败: $e',
      ));
    }
  }
}

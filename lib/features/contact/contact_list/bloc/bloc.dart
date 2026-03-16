import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/contact/contact_list/bloc/event.dart';
import 'package:beaver/features/contact/contact_list/bloc/state.dart';
import 'package:beaver/features/contact/contact_list/data/repositories/repository.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactListRepository _repository;

  ContactListBloc({required ContactListRepository repository})
      : _repository = repository,
        super(const ContactListState()) {
    on<LoadContactListEvent>(_onLoadContactList);
    on<UpdateCurrentIndexEvent>(_onUpdateCurrentIndex);
  }

  Future<void> _onLoadContactList(
    LoadContactListEvent event,
    Emitter<ContactListState> emit,
  ) async {
    emit(state.copyWith(status: ContactListStatus.loading));

    try {
      final contacts = await _repository.getContactList();
      final groupedContacts = _repository.groupContactsByLetter(contacts);
      final indexList = _repository.getIndexList(groupedContacts);

      emit(state.copyWith(
        status: ContactListStatus.success,
        contacts: contacts,
        groupedContacts: groupedContacts,
        indexList: indexList,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ContactListStatus.error,
        errorMessage: '加载联系人失败: $e',
      ));
    }
  }

  void _onUpdateCurrentIndex(
    UpdateCurrentIndexEvent event,
    Emitter<ContactListState> emit,
  ) {
    emit(state.copyWith(currentIndex: event.index));
  }
}

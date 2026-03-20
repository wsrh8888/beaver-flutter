import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/contact/list/bloc/event.dart';
import 'package:beaver/features/contact/list/bloc/state.dart';
import 'package:beaver/features/contact/list/data/repositories/repository.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactListRepository _contactListRepository;

  ContactListBloc({ContactListRepository? contactListRepository}) 
    : _contactListRepository = contactListRepository ?? ContactListRepository(),
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
      final contacts = await _contactListRepository.getContactList();
      final groupedContacts = _contactListRepository.groupContactsByLetter(contacts);
      final indexList = _contactListRepository.getIndexList(groupedContacts);

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

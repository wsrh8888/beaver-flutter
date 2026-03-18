import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/features/contact/list/bloc/event.dart';
import 'package:beaver/features/contact/list/bloc/state.dart';
import 'package:beaver/core/business/friend/friend.dart';
import 'package:beaver/di/injection.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final _friendBusiness = getIt<FriendBusiness>();

  ContactListBloc() : super(const ContactListState()) {
    on<LoadContactListEvent>(_onLoadContactList);
    on<UpdateCurrentIndexEvent>(_onUpdateCurrentIndex);
  }

  Future<void> _onLoadContactList(
    LoadContactListEvent event,
    Emitter<ContactListState> emit,
  ) async {
    emit(state.copyWith(status: ContactListStatus.loading));

    try {
      final contacts = await _friendBusiness.getContactList();
      final groupedContacts = _friendBusiness.groupContactsByLetter(contacts);
      final indexList = _friendBusiness.getIndexList(groupedContacts);

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

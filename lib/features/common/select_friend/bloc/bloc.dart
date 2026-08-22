import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/friend/friend.dart';
import 'package:beaver/types/business/contact.dart';
import 'event.dart';
import 'state.dart';

class ContactSelectorBloc extends Bloc<ContactSelectorEvent, ContactSelectorState> {
  final FriendStore _friendStore;
  StreamSubscription? _friendSubscription;

  ContactSelectorBloc({
    FriendStore? friendStore,
    List<ContactModel> initialSelected = const [],
  }) : _friendStore = friendStore ?? getIt<FriendStore>(),
       super(ContactSelectorState(selectedContacts: initialSelected)) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<SelectContactEvent>(_onSelectContact);
    on<SearchContactsEvent>(_onSearchContacts);

    _friendSubscription = _friendStore.stream.listen((_) {
      add(const LoadContactsEvent());
    });
    
    add(const LoadContactsEvent());
  }

  @override
  Future<void> close() {
    _friendSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadContacts(
    LoadContactsEvent event,
    Emitter<ContactSelectorState> emit,
  ) async {
    final contacts = _friendStore.state.friends;
    emit(state.copyWith(status: ContactSelectorStatus.success, contacts: contacts));
  }

  Future<void> _onSelectContact(
    SelectContactEvent event,
    Emitter<ContactSelectorState> emit,
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
    Emitter<ContactSelectorState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
  }
}

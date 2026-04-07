import 'package:beaver/types/business/contact.dart';
abstract class CreateGroupEvent {
  const CreateGroupEvent();
}

class LoadContactsEvent extends CreateGroupEvent {
  const LoadContactsEvent();
}

class SelectContactEvent extends CreateGroupEvent {
  final ContactModel contact;

  const SelectContactEvent(this.contact);
}

class SearchContactsEvent extends CreateGroupEvent {
  final String query;

  const SearchContactsEvent(this.query);
}

class CreateGroupSubmitEvent extends CreateGroupEvent {
  const CreateGroupSubmitEvent();
}

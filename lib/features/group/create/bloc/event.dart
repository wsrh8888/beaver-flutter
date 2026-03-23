import 'package:beaver/types/business/group.dart';
abstract class CreateGroupEvent {
  const CreateGroupEvent();
}

class LoadContactsEvent extends CreateGroupEvent {
  const LoadContactsEvent();
}

class SelectContactEvent extends CreateGroupEvent {
  final Contact contact;

  const SelectContactEvent(this.contact);
}

class SearchContactsEvent extends CreateGroupEvent {
  final String query;

  const SearchContactsEvent(this.query);
}

class CreateGroupSubmitEvent extends CreateGroupEvent {
  const CreateGroupSubmitEvent();
}

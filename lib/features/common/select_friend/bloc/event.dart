import 'package:beaver/types/business/contact.dart';

abstract class ContactSelectorEvent {
  const ContactSelectorEvent();
}

class LoadContactsEvent extends ContactSelectorEvent {
  const LoadContactsEvent();
}

class SelectContactEvent extends ContactSelectorEvent {
  final ContactModel contact;

  const SelectContactEvent(this.contact);
}

class SearchContactsEvent extends ContactSelectorEvent {
  final String query;

  const SearchContactsEvent(this.query);
}

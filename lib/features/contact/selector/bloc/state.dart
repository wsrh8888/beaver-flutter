import 'package:beaver/types/business/contact.dart';

enum ContactSelectorStatus { initial, loading, success, error }

class ContactSelectorState {
  final ContactSelectorStatus status;
  final List<ContactModel> contacts;
  final List<ContactModel> selectedContacts;
  final String searchQuery;
  final String? errorMessage;

  const ContactSelectorState({
    this.status = ContactSelectorStatus.initial,
    this.contacts = const [],
    this.selectedContacts = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  ContactSelectorState copyWith({
    ContactSelectorStatus? status,
    List<ContactModel>? contacts,
    List<ContactModel>? selectedContacts,
    String? searchQuery,
    String? errorMessage,
  }) {
    return ContactSelectorState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      selectedContacts: selectedContacts ?? this.selectedContacts,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

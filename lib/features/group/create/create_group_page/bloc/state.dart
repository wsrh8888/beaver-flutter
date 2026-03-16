import 'package:beaver/features/createGroup/create_group_page/data/models/contact.dart';

enum CreateGroupStatus { initial, loading, success, error }

class CreateGroupState {
  final CreateGroupStatus status;
  final List<Contact> contacts;
  final List<Contact> selectedContacts;
  final String searchQuery;
  final String? groupId;
  final String? errorMessage;

  const CreateGroupState({
    this.status = CreateGroupStatus.initial,
    this.contacts = const [],
    this.selectedContacts = const [],
    this.searchQuery = '',
    this.groupId,
    this.errorMessage,
  });

  CreateGroupState copyWith({
    CreateGroupStatus? status,
    List<Contact>? contacts,
    List<Contact>? selectedContacts,
    String? searchQuery,
    String? groupId,
    String? errorMessage,
  }) {
    return CreateGroupState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      selectedContacts: selectedContacts ?? this.selectedContacts,
      searchQuery: searchQuery ?? this.searchQuery,
      groupId: groupId ?? this.groupId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

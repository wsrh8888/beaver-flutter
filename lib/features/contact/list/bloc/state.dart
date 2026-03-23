import 'package:beaver/types/business/contact.dart';

enum ContactListStatus { initial, loading, success, error }

class ContactListState {
  final ContactListStatus status;
  final List<ContactModel> contacts;
  final Map<String, List<ContactModel>> groupedContacts;
  final List<String> indexList;
  final String? errorMessage;
  final String currentIndex;
  final int friendRequestCount;
  final int groupNotificationCount;

  const ContactListState({
    this.status = ContactListStatus.initial,
    this.contacts = const [],
    this.groupedContacts = const {},
    this.indexList = const [],
    this.errorMessage,
    this.currentIndex = '',
    this.friendRequestCount = 0,
    this.groupNotificationCount = 0,
  });

  ContactListState copyWith({
    ContactListStatus? status,
    List<ContactModel>? contacts,
    Map<String, List<ContactModel>>? groupedContacts, 
    List<String>? indexList,
    String? errorMessage,
    String? currentIndex,
    int? friendRequestCount,
    int? groupNotificationCount,
  }) {
    return ContactListState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      groupedContacts: groupedContacts ?? this.groupedContacts,
      indexList: indexList ?? this.indexList,
      errorMessage: errorMessage ?? this.errorMessage,
      currentIndex: currentIndex ?? this.currentIndex,
      friendRequestCount: friendRequestCount ?? this.friendRequestCount,
      groupNotificationCount: groupNotificationCount ?? this.groupNotificationCount,
    );
  }
}

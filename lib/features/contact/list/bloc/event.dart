abstract class ContactListEvent {
  const ContactListEvent();
}

class LoadContactListEvent extends ContactListEvent {
  const LoadContactListEvent();
}

class UpdateCurrentIndexEvent extends ContactListEvent {
  final String index;

  const UpdateCurrentIndexEvent(this.index);
}

import 'package:beaver/core/database/database.dart';

class MessageService {
  final AppDatabase database;
  MessageService(this.database);
}

class ConversationService {
  final AppDatabase database;
  ConversationService(this.database);
}

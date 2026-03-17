import 'package:drift/drift.dart';

class CallHistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get callId => text().unique()();
  TextColumn get conversationId => text()();
  TextColumn get callerId => text()();
  TextColumn get callerName => text()();
  TextColumn get callerAvatar => text().nullable()();
  TextColumn get receiverId => text()();
  TextColumn get receiverName => text()();
  TextColumn get receiverAvatar => text().nullable()();
  TextColumn get callType => text()(); // 'audio' or 'video'
  BoolColumn get isIncoming => boolean()();
  BoolColumn get isMissed => boolean()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  IntColumn get duration => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  Set<Column> get primaryKey => {id};
}

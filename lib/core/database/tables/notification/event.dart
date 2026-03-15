import 'package:drift/drift.dart';

class NotificationEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventId => text().named('event_id')();
  TextColumn get eventType => text().named('event_type')();
  TextColumn get category => text().named('category')();
  IntColumn get version => integer().named('version').withDefault(const Constant(0))();
  TextColumn get fromUserId => text().named('from_user_id').nullable()();
  TextColumn get targetId => text().named('target_id').nullable()();
  TextColumn get targetType => text().named('target_type')();
  TextColumn get payload => text().named('payload').nullable()();
  IntColumn get priority => integer().named('priority').withDefault(const Constant(5))();
  IntColumn get status => integer().named('status').withDefault(const Constant(1))();
  TextColumn get dedupHash => text().named('dedup_hash').nullable()();
  IntColumn get createdAt => integer().named('created_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  List<String> get customConstraints => ['UNIQUE (event_id)'];
}

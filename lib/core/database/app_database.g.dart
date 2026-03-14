// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nickNameMeta = const VerificationMeta(
    'nickName',
  );
  @override
  late final GeneratedColumn<String> nickName = GeneratedColumn<String>(
    'nick_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
    'avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _abstractMeta = const VerificationMeta(
    'abstract',
  );
  @override
  late final GeneratedColumn<String> abstract = GeneratedColumn<String>(
    'abstract',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<int> gender = GeneratedColumn<int>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    nickName,
    email,
    phone,
    avatar,
    abstract,
    gender,
    status,
    version,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('nick_name')) {
      context.handle(
        _nickNameMeta,
        nickName.isAcceptableOrUnknown(data['nick_name']!, _nickNameMeta),
      );
    } else if (isInserting) {
      context.missing(_nickNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    }
    if (data.containsKey('abstract')) {
      context.handle(
        _abstractMeta,
        abstract.isAcceptableOrUnknown(data['abstract']!, _abstractMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      nickName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nick_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      ),
      abstract: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abstract'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gender'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String userId;
  final String nickName;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? abstract;
  final int gender;
  final int status;
  final int version;
  final int? createdAt;
  final int? updatedAt;
  const User({
    required this.id,
    required this.userId,
    required this.nickName,
    this.email,
    this.phone,
    this.avatar,
    this.abstract,
    required this.gender,
    required this.status,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['nick_name'] = Variable<String>(nickName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    if (!nullToAbsent || abstract != null) {
      map['abstract'] = Variable<String>(abstract);
    }
    map['gender'] = Variable<int>(gender);
    map['status'] = Variable<int>(status);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      userId: Value(userId),
      nickName: Value(nickName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      avatar: avatar == null && nullToAbsent
          ? const Value.absent()
          : Value(avatar),
      abstract: abstract == null && nullToAbsent
          ? const Value.absent()
          : Value(abstract),
      gender: Value(gender),
      status: Value(status),
      version: Value(version),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      nickName: serializer.fromJson<String>(json['nickName']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      abstract: serializer.fromJson<String?>(json['abstract']),
      gender: serializer.fromJson<int>(json['gender']),
      status: serializer.fromJson<int>(json['status']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'nickName': serializer.toJson<String>(nickName),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'avatar': serializer.toJson<String?>(avatar),
      'abstract': serializer.toJson<String?>(abstract),
      'gender': serializer.toJson<int>(gender),
      'status': serializer.toJson<int>(status),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  User copyWith({
    int? id,
    String? userId,
    String? nickName,
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> avatar = const Value.absent(),
    Value<String?> abstract = const Value.absent(),
    int? gender,
    int? status,
    int? version,
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => User(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    nickName: nickName ?? this.nickName,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    avatar: avatar.present ? avatar.value : this.avatar,
    abstract: abstract.present ? abstract.value : this.abstract,
    gender: gender ?? this.gender,
    status: status ?? this.status,
    version: version ?? this.version,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      nickName: data.nickName.present ? data.nickName.value : this.nickName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      abstract: data.abstract.present ? data.abstract.value : this.abstract,
      gender: data.gender.present ? data.gender.value : this.gender,
      status: data.status.present ? data.status.value : this.status,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nickName: $nickName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('avatar: $avatar, ')
          ..write('abstract: $abstract, ')
          ..write('gender: $gender, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    nickName,
    email,
    phone,
    avatar,
    abstract,
    gender,
    status,
    version,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.nickName == this.nickName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.avatar == this.avatar &&
          other.abstract == this.abstract &&
          other.gender == this.gender &&
          other.status == this.status &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> nickName;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> avatar;
  final Value<String?> abstract;
  final Value<int> gender;
  final Value<int> status;
  final Value<int> version;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.nickName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.avatar = const Value.absent(),
    this.abstract = const Value.absent(),
    this.gender = const Value.absent(),
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String nickName,
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.avatar = const Value.absent(),
    this.abstract = const Value.absent(),
    this.gender = const Value.absent(),
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId),
       nickName = Value(nickName);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? nickName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? avatar,
    Expression<String>? abstract,
    Expression<int>? gender,
    Expression<int>? status,
    Expression<int>? version,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (nickName != null) 'nick_name': nickName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (avatar != null) 'avatar': avatar,
      if (abstract != null) 'abstract': abstract,
      if (gender != null) 'gender': gender,
      if (status != null) 'status': status,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<String>? nickName,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? avatar,
    Value<String?>? abstract,
    Value<int>? gender,
    Value<int>? status,
    Value<int>? version,
    Value<int?>? createdAt,
    Value<int?>? updatedAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nickName: nickName ?? this.nickName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      abstract: abstract ?? this.abstract,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (nickName.present) {
      map['nick_name'] = Variable<String>(nickName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (abstract.present) {
      map['abstract'] = Variable<String>(abstract.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int>(gender.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nickName: $nickName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('avatar: $avatar, ')
          ..write('abstract: $abstract, ')
          ..write('gender: $gender, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UserSyncStatusTable extends UserSyncStatus
    with TableInfo<$UserSyncStatusTable, UserSyncStatusData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSyncStatusTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userVersionMeta = const VerificationMeta(
    'userVersion',
  );
  @override
  late final GeneratedColumn<int> userVersion = GeneratedColumn<int>(
    'user_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSyncTimeMeta = const VerificationMeta(
    'lastSyncTime',
  );
  @override
  late final GeneratedColumn<int> lastSyncTime = GeneratedColumn<int>(
    'last_sync_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    userVersion,
    lastSyncTime,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_sync_status';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSyncStatusData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('user_version')) {
      context.handle(
        _userVersionMeta,
        userVersion.isAcceptableOrUnknown(
          data['user_version']!,
          _userVersionMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
        _lastSyncTimeMeta,
        lastSyncTime.isAcceptableOrUnknown(
          data['last_sync_time']!,
          _lastSyncTimeMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSyncStatusData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSyncStatusData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      userVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_version'],
      )!,
      lastSyncTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sync_time'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $UserSyncStatusTable createAlias(String alias) {
    return $UserSyncStatusTable(attachedDatabase, alias);
  }
}

class UserSyncStatusData extends DataClass
    implements Insertable<UserSyncStatusData> {
  final int id;
  final String userId;
  final int userVersion;
  final int lastSyncTime;
  final int? updatedAt;
  const UserSyncStatusData({
    required this.id,
    required this.userId,
    required this.userVersion,
    required this.lastSyncTime,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['user_version'] = Variable<int>(userVersion);
    map['last_sync_time'] = Variable<int>(lastSyncTime);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  UserSyncStatusCompanion toCompanion(bool nullToAbsent) {
    return UserSyncStatusCompanion(
      id: Value(id),
      userId: Value(userId),
      userVersion: Value(userVersion),
      lastSyncTime: Value(lastSyncTime),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory UserSyncStatusData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSyncStatusData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      userVersion: serializer.fromJson<int>(json['userVersion']),
      lastSyncTime: serializer.fromJson<int>(json['lastSyncTime']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'userVersion': serializer.toJson<int>(userVersion),
      'lastSyncTime': serializer.toJson<int>(lastSyncTime),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  UserSyncStatusData copyWith({
    int? id,
    String? userId,
    int? userVersion,
    int? lastSyncTime,
    Value<int?> updatedAt = const Value.absent(),
  }) => UserSyncStatusData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    userVersion: userVersion ?? this.userVersion,
    lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  UserSyncStatusData copyWithCompanion(UserSyncStatusCompanion data) {
    return UserSyncStatusData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      userVersion: data.userVersion.present
          ? data.userVersion.value
          : this.userVersion,
      lastSyncTime: data.lastSyncTime.present
          ? data.lastSyncTime.value
          : this.lastSyncTime,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSyncStatusData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('userVersion: $userVersion, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, userVersion, lastSyncTime, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSyncStatusData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.userVersion == this.userVersion &&
          other.lastSyncTime == this.lastSyncTime &&
          other.updatedAt == this.updatedAt);
}

class UserSyncStatusCompanion extends UpdateCompanion<UserSyncStatusData> {
  final Value<int> id;
  final Value<String> userId;
  final Value<int> userVersion;
  final Value<int> lastSyncTime;
  final Value<int?> updatedAt;
  const UserSyncStatusCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.userVersion = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserSyncStatusCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    this.userVersion = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<UserSyncStatusData> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<int>? userVersion,
    Expression<int>? lastSyncTime,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (userVersion != null) 'user_version': userVersion,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserSyncStatusCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<int>? userVersion,
    Value<int>? lastSyncTime,
    Value<int?>? updatedAt,
  }) {
    return UserSyncStatusCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userVersion: userVersion ?? this.userVersion,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (userVersion.present) {
      map['user_version'] = Variable<int>(userVersion.value);
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<int>(lastSyncTime.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSyncStatusCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('userVersion: $userVersion, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ChatsTable extends Chats with TableInfo<$ChatsTable, Chat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationTypeMeta = const VerificationMeta(
    'conversationType',
  );
  @override
  late final GeneratedColumn<int> conversationType = GeneratedColumn<int>(
    'conversation_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sendUserIdMeta = const VerificationMeta(
    'sendUserId',
  );
  @override
  late final GeneratedColumn<String> sendUserId = GeneratedColumn<String>(
    'send_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _msgTypeMeta = const VerificationMeta(
    'msgType',
  );
  @override
  late final GeneratedColumn<int> msgType = GeneratedColumn<int>(
    'msg_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMessageIdMeta = const VerificationMeta(
    'targetMessageId',
  );
  @override
  late final GeneratedColumn<String> targetMessageId = GeneratedColumn<String>(
    'target_message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _msgPreviewMeta = const VerificationMeta(
    'msgPreview',
  );
  @override
  late final GeneratedColumn<String> msgPreview = GeneratedColumn<String>(
    'msg_preview',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _msgMeta = const VerificationMeta('msg');
  @override
  late final GeneratedColumn<String> msg = GeneratedColumn<String>(
    'msg',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sendStatusMeta = const VerificationMeta(
    'sendStatus',
  );
  @override
  late final GeneratedColumn<int> sendStatus = GeneratedColumn<int>(
    'send_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    messageId,
    conversationId,
    conversationType,
    seq,
    sendUserId,
    msgType,
    targetMessageId,
    msgPreview,
    msg,
    sendStatus,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('conversation_type')) {
      context.handle(
        _conversationTypeMeta,
        conversationType.isAcceptableOrUnknown(
          data['conversation_type']!,
          _conversationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationTypeMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    }
    if (data.containsKey('send_user_id')) {
      context.handle(
        _sendUserIdMeta,
        sendUserId.isAcceptableOrUnknown(
          data['send_user_id']!,
          _sendUserIdMeta,
        ),
      );
    }
    if (data.containsKey('msg_type')) {
      context.handle(
        _msgTypeMeta,
        msgType.isAcceptableOrUnknown(data['msg_type']!, _msgTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_msgTypeMeta);
    }
    if (data.containsKey('target_message_id')) {
      context.handle(
        _targetMessageIdMeta,
        targetMessageId.isAcceptableOrUnknown(
          data['target_message_id']!,
          _targetMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('msg_preview')) {
      context.handle(
        _msgPreviewMeta,
        msgPreview.isAcceptableOrUnknown(data['msg_preview']!, _msgPreviewMeta),
      );
    }
    if (data.containsKey('msg')) {
      context.handle(
        _msgMeta,
        msg.isAcceptableOrUnknown(data['msg']!, _msgMeta),
      );
    }
    if (data.containsKey('send_status')) {
      context.handle(
        _sendStatusMeta,
        sendStatus.isAcceptableOrUnknown(data['send_status']!, _sendStatusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      conversationType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}conversation_type'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      sendUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}send_user_id'],
      ),
      msgType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}msg_type'],
      )!,
      targetMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_message_id'],
      ),
      msgPreview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}msg_preview'],
      ),
      msg: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}msg'],
      ),
      sendStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}send_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ChatsTable createAlias(String alias) {
    return $ChatsTable(attachedDatabase, alias);
  }
}

class Chat extends DataClass implements Insertable<Chat> {
  final int id;
  final String messageId;
  final String conversationId;
  final int conversationType;
  final int seq;
  final String? sendUserId;
  final int msgType;
  final String? targetMessageId;
  final String? msgPreview;
  final String? msg;
  final int sendStatus;
  final int? createdAt;
  final int? updatedAt;
  const Chat({
    required this.id,
    required this.messageId,
    required this.conversationId,
    required this.conversationType,
    required this.seq,
    this.sendUserId,
    required this.msgType,
    this.targetMessageId,
    this.msgPreview,
    this.msg,
    required this.sendStatus,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['message_id'] = Variable<String>(messageId);
    map['conversation_id'] = Variable<String>(conversationId);
    map['conversation_type'] = Variable<int>(conversationType);
    map['seq'] = Variable<int>(seq);
    if (!nullToAbsent || sendUserId != null) {
      map['send_user_id'] = Variable<String>(sendUserId);
    }
    map['msg_type'] = Variable<int>(msgType);
    if (!nullToAbsent || targetMessageId != null) {
      map['target_message_id'] = Variable<String>(targetMessageId);
    }
    if (!nullToAbsent || msgPreview != null) {
      map['msg_preview'] = Variable<String>(msgPreview);
    }
    if (!nullToAbsent || msg != null) {
      map['msg'] = Variable<String>(msg);
    }
    map['send_status'] = Variable<int>(sendStatus);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      id: Value(id),
      messageId: Value(messageId),
      conversationId: Value(conversationId),
      conversationType: Value(conversationType),
      seq: Value(seq),
      sendUserId: sendUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(sendUserId),
      msgType: Value(msgType),
      targetMessageId: targetMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetMessageId),
      msgPreview: msgPreview == null && nullToAbsent
          ? const Value.absent()
          : Value(msgPreview),
      msg: msg == null && nullToAbsent ? const Value.absent() : Value(msg),
      sendStatus: Value(sendStatus),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Chat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chat(
      id: serializer.fromJson<int>(json['id']),
      messageId: serializer.fromJson<String>(json['messageId']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      conversationType: serializer.fromJson<int>(json['conversationType']),
      seq: serializer.fromJson<int>(json['seq']),
      sendUserId: serializer.fromJson<String?>(json['sendUserId']),
      msgType: serializer.fromJson<int>(json['msgType']),
      targetMessageId: serializer.fromJson<String?>(json['targetMessageId']),
      msgPreview: serializer.fromJson<String?>(json['msgPreview']),
      msg: serializer.fromJson<String?>(json['msg']),
      sendStatus: serializer.fromJson<int>(json['sendStatus']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'messageId': serializer.toJson<String>(messageId),
      'conversationId': serializer.toJson<String>(conversationId),
      'conversationType': serializer.toJson<int>(conversationType),
      'seq': serializer.toJson<int>(seq),
      'sendUserId': serializer.toJson<String?>(sendUserId),
      'msgType': serializer.toJson<int>(msgType),
      'targetMessageId': serializer.toJson<String?>(targetMessageId),
      'msgPreview': serializer.toJson<String?>(msgPreview),
      'msg': serializer.toJson<String?>(msg),
      'sendStatus': serializer.toJson<int>(sendStatus),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  Chat copyWith({
    int? id,
    String? messageId,
    String? conversationId,
    int? conversationType,
    int? seq,
    Value<String?> sendUserId = const Value.absent(),
    int? msgType,
    Value<String?> targetMessageId = const Value.absent(),
    Value<String?> msgPreview = const Value.absent(),
    Value<String?> msg = const Value.absent(),
    int? sendStatus,
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => Chat(
    id: id ?? this.id,
    messageId: messageId ?? this.messageId,
    conversationId: conversationId ?? this.conversationId,
    conversationType: conversationType ?? this.conversationType,
    seq: seq ?? this.seq,
    sendUserId: sendUserId.present ? sendUserId.value : this.sendUserId,
    msgType: msgType ?? this.msgType,
    targetMessageId: targetMessageId.present
        ? targetMessageId.value
        : this.targetMessageId,
    msgPreview: msgPreview.present ? msgPreview.value : this.msgPreview,
    msg: msg.present ? msg.value : this.msg,
    sendStatus: sendStatus ?? this.sendStatus,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Chat copyWithCompanion(ChatsCompanion data) {
    return Chat(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      conversationType: data.conversationType.present
          ? data.conversationType.value
          : this.conversationType,
      seq: data.seq.present ? data.seq.value : this.seq,
      sendUserId: data.sendUserId.present
          ? data.sendUserId.value
          : this.sendUserId,
      msgType: data.msgType.present ? data.msgType.value : this.msgType,
      targetMessageId: data.targetMessageId.present
          ? data.targetMessageId.value
          : this.targetMessageId,
      msgPreview: data.msgPreview.present
          ? data.msgPreview.value
          : this.msgPreview,
      msg: data.msg.present ? data.msg.value : this.msg,
      sendStatus: data.sendStatus.present
          ? data.sendStatus.value
          : this.sendStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chat(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('conversationId: $conversationId, ')
          ..write('conversationType: $conversationType, ')
          ..write('seq: $seq, ')
          ..write('sendUserId: $sendUserId, ')
          ..write('msgType: $msgType, ')
          ..write('targetMessageId: $targetMessageId, ')
          ..write('msgPreview: $msgPreview, ')
          ..write('msg: $msg, ')
          ..write('sendStatus: $sendStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    messageId,
    conversationId,
    conversationType,
    seq,
    sendUserId,
    msgType,
    targetMessageId,
    msgPreview,
    msg,
    sendStatus,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chat &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.conversationId == this.conversationId &&
          other.conversationType == this.conversationType &&
          other.seq == this.seq &&
          other.sendUserId == this.sendUserId &&
          other.msgType == this.msgType &&
          other.targetMessageId == this.targetMessageId &&
          other.msgPreview == this.msgPreview &&
          other.msg == this.msg &&
          other.sendStatus == this.sendStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ChatsCompanion extends UpdateCompanion<Chat> {
  final Value<int> id;
  final Value<String> messageId;
  final Value<String> conversationId;
  final Value<int> conversationType;
  final Value<int> seq;
  final Value<String?> sendUserId;
  final Value<int> msgType;
  final Value<String?> targetMessageId;
  final Value<String?> msgPreview;
  final Value<String?> msg;
  final Value<int> sendStatus;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  const ChatsCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.conversationType = const Value.absent(),
    this.seq = const Value.absent(),
    this.sendUserId = const Value.absent(),
    this.msgType = const Value.absent(),
    this.targetMessageId = const Value.absent(),
    this.msgPreview = const Value.absent(),
    this.msg = const Value.absent(),
    this.sendStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ChatsCompanion.insert({
    this.id = const Value.absent(),
    required String messageId,
    required String conversationId,
    required int conversationType,
    this.seq = const Value.absent(),
    this.sendUserId = const Value.absent(),
    required int msgType,
    this.targetMessageId = const Value.absent(),
    this.msgPreview = const Value.absent(),
    this.msg = const Value.absent(),
    this.sendStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : messageId = Value(messageId),
       conversationId = Value(conversationId),
       conversationType = Value(conversationType),
       msgType = Value(msgType);
  static Insertable<Chat> custom({
    Expression<int>? id,
    Expression<String>? messageId,
    Expression<String>? conversationId,
    Expression<int>? conversationType,
    Expression<int>? seq,
    Expression<String>? sendUserId,
    Expression<int>? msgType,
    Expression<String>? targetMessageId,
    Expression<String>? msgPreview,
    Expression<String>? msg,
    Expression<int>? sendStatus,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (conversationId != null) 'conversation_id': conversationId,
      if (conversationType != null) 'conversation_type': conversationType,
      if (seq != null) 'seq': seq,
      if (sendUserId != null) 'send_user_id': sendUserId,
      if (msgType != null) 'msg_type': msgType,
      if (targetMessageId != null) 'target_message_id': targetMessageId,
      if (msgPreview != null) 'msg_preview': msgPreview,
      if (msg != null) 'msg': msg,
      if (sendStatus != null) 'send_status': sendStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ChatsCompanion copyWith({
    Value<int>? id,
    Value<String>? messageId,
    Value<String>? conversationId,
    Value<int>? conversationType,
    Value<int>? seq,
    Value<String?>? sendUserId,
    Value<int>? msgType,
    Value<String?>? targetMessageId,
    Value<String?>? msgPreview,
    Value<String?>? msg,
    Value<int>? sendStatus,
    Value<int?>? createdAt,
    Value<int?>? updatedAt,
  }) {
    return ChatsCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      conversationId: conversationId ?? this.conversationId,
      conversationType: conversationType ?? this.conversationType,
      seq: seq ?? this.seq,
      sendUserId: sendUserId ?? this.sendUserId,
      msgType: msgType ?? this.msgType,
      targetMessageId: targetMessageId ?? this.targetMessageId,
      msgPreview: msgPreview ?? this.msgPreview,
      msg: msg ?? this.msg,
      sendStatus: sendStatus ?? this.sendStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (conversationType.present) {
      map['conversation_type'] = Variable<int>(conversationType.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (sendUserId.present) {
      map['send_user_id'] = Variable<String>(sendUserId.value);
    }
    if (msgType.present) {
      map['msg_type'] = Variable<int>(msgType.value);
    }
    if (targetMessageId.present) {
      map['target_message_id'] = Variable<String>(targetMessageId.value);
    }
    if (msgPreview.present) {
      map['msg_preview'] = Variable<String>(msgPreview.value);
    }
    if (msg.present) {
      map['msg'] = Variable<String>(msg.value);
    }
    if (sendStatus.present) {
      map['send_status'] = Variable<int>(sendStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('conversationId: $conversationId, ')
          ..write('conversationType: $conversationType, ')
          ..write('seq: $seq, ')
          ..write('sendUserId: $sendUserId, ')
          ..write('msgType: $msgType, ')
          ..write('targetMessageId: $targetMessageId, ')
          ..write('msgPreview: $msgPreview, ')
          ..write('msg: $msg, ')
          ..write('sendStatus: $sendStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ChatConversationsTable extends ChatConversations
    with TableInfo<$ChatConversationsTable, ChatConversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxSeqMeta = const VerificationMeta('maxSeq');
  @override
  late final GeneratedColumn<int> maxSeq = GeneratedColumn<int>(
    'max_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastMessageMeta = const VerificationMeta(
    'lastMessage',
  );
  @override
  late final GeneratedColumn<String> lastMessage = GeneratedColumn<String>(
    'last_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    type,
    maxSeq,
    lastMessage,
    version,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatConversation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('max_seq')) {
      context.handle(
        _maxSeqMeta,
        maxSeq.isAcceptableOrUnknown(data['max_seq']!, _maxSeqMeta),
      );
    }
    if (data.containsKey('last_message')) {
      context.handle(
        _lastMessageMeta,
        lastMessage.isAcceptableOrUnknown(
          data['last_message']!,
          _lastMessageMeta,
        ),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatConversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatConversation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      maxSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_seq'],
      )!,
      lastMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_message'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ChatConversationsTable createAlias(String alias) {
    return $ChatConversationsTable(attachedDatabase, alias);
  }
}

class ChatConversation extends DataClass
    implements Insertable<ChatConversation> {
  final int id;
  final String conversationId;
  final int type;
  final int maxSeq;
  final String? lastMessage;
  final int version;
  final int? createdAt;
  final int? updatedAt;
  const ChatConversation({
    required this.id,
    required this.conversationId,
    required this.type,
    required this.maxSeq,
    this.lastMessage,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['type'] = Variable<int>(type);
    map['max_seq'] = Variable<int>(maxSeq);
    if (!nullToAbsent || lastMessage != null) {
      map['last_message'] = Variable<String>(lastMessage);
    }
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  ChatConversationsCompanion toCompanion(bool nullToAbsent) {
    return ChatConversationsCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      type: Value(type),
      maxSeq: Value(maxSeq),
      lastMessage: lastMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessage),
      version: Value(version),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ChatConversation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatConversation(
      id: serializer.fromJson<int>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      type: serializer.fromJson<int>(json['type']),
      maxSeq: serializer.fromJson<int>(json['maxSeq']),
      lastMessage: serializer.fromJson<String?>(json['lastMessage']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'type': serializer.toJson<int>(type),
      'maxSeq': serializer.toJson<int>(maxSeq),
      'lastMessage': serializer.toJson<String?>(lastMessage),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  ChatConversation copyWith({
    int? id,
    String? conversationId,
    int? type,
    int? maxSeq,
    Value<String?> lastMessage = const Value.absent(),
    int? version,
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => ChatConversation(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    type: type ?? this.type,
    maxSeq: maxSeq ?? this.maxSeq,
    lastMessage: lastMessage.present ? lastMessage.value : this.lastMessage,
    version: version ?? this.version,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ChatConversation copyWithCompanion(ChatConversationsCompanion data) {
    return ChatConversation(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      type: data.type.present ? data.type.value : this.type,
      maxSeq: data.maxSeq.present ? data.maxSeq.value : this.maxSeq,
      lastMessage: data.lastMessage.present
          ? data.lastMessage.value
          : this.lastMessage,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatConversation(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('type: $type, ')
          ..write('maxSeq: $maxSeq, ')
          ..write('lastMessage: $lastMessage, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    conversationId,
    type,
    maxSeq,
    lastMessage,
    version,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatConversation &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.type == this.type &&
          other.maxSeq == this.maxSeq &&
          other.lastMessage == this.lastMessage &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ChatConversationsCompanion extends UpdateCompanion<ChatConversation> {
  final Value<int> id;
  final Value<String> conversationId;
  final Value<int> type;
  final Value<int> maxSeq;
  final Value<String?> lastMessage;
  final Value<int> version;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  const ChatConversationsCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.type = const Value.absent(),
    this.maxSeq = const Value.absent(),
    this.lastMessage = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ChatConversationsCompanion.insert({
    this.id = const Value.absent(),
    required String conversationId,
    required int type,
    this.maxSeq = const Value.absent(),
    this.lastMessage = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : conversationId = Value(conversationId),
       type = Value(type);
  static Insertable<ChatConversation> custom({
    Expression<int>? id,
    Expression<String>? conversationId,
    Expression<int>? type,
    Expression<int>? maxSeq,
    Expression<String>? lastMessage,
    Expression<int>? version,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (type != null) 'type': type,
      if (maxSeq != null) 'max_seq': maxSeq,
      if (lastMessage != null) 'last_message': lastMessage,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ChatConversationsCompanion copyWith({
    Value<int>? id,
    Value<String>? conversationId,
    Value<int>? type,
    Value<int>? maxSeq,
    Value<String?>? lastMessage,
    Value<int>? version,
    Value<int?>? createdAt,
    Value<int?>? updatedAt,
  }) {
    return ChatConversationsCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      type: type ?? this.type,
      maxSeq: maxSeq ?? this.maxSeq,
      lastMessage: lastMessage ?? this.lastMessage,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (maxSeq.present) {
      map['max_seq'] = Variable<int>(maxSeq.value);
    }
    if (lastMessage.present) {
      map['last_message'] = Variable<String>(lastMessage.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatConversationsCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('type: $type, ')
          ..write('maxSeq: $maxSeq, ')
          ..write('lastMessage: $lastMessage, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ChatUserConversationsTable extends ChatUserConversations
    with TableInfo<$ChatUserConversationsTable, ChatUserConversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatUserConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isHiddenMeta = const VerificationMeta(
    'isHidden',
  );
  @override
  late final GeneratedColumn<int> isHidden = GeneratedColumn<int>(
    'is_hidden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<int> isPinned = GeneratedColumn<int>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isMutedMeta = const VerificationMeta(
    'isMuted',
  );
  @override
  late final GeneratedColumn<int> isMuted = GeneratedColumn<int>(
    'is_muted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _userReadSeqMeta = const VerificationMeta(
    'userReadSeq',
  );
  @override
  late final GeneratedColumn<int> userReadSeq = GeneratedColumn<int>(
    'user_read_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    conversationId,
    isHidden,
    isPinned,
    isMuted,
    userReadSeq,
    version,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_user_conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatUserConversation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('is_hidden')) {
      context.handle(
        _isHiddenMeta,
        isHidden.isAcceptableOrUnknown(data['is_hidden']!, _isHiddenMeta),
      );
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('is_muted')) {
      context.handle(
        _isMutedMeta,
        isMuted.isAcceptableOrUnknown(data['is_muted']!, _isMutedMeta),
      );
    }
    if (data.containsKey('user_read_seq')) {
      context.handle(
        _userReadSeqMeta,
        userReadSeq.isAcceptableOrUnknown(
          data['user_read_seq']!,
          _userReadSeqMeta,
        ),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatUserConversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatUserConversation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      isHidden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_hidden'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_pinned'],
      )!,
      isMuted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_muted'],
      )!,
      userReadSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_read_seq'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ChatUserConversationsTable createAlias(String alias) {
    return $ChatUserConversationsTable(attachedDatabase, alias);
  }
}

class ChatUserConversation extends DataClass
    implements Insertable<ChatUserConversation> {
  final int id;
  final String userId;
  final String conversationId;
  final int isHidden;
  final int isPinned;
  final int isMuted;
  final int userReadSeq;
  final int version;
  final int? updatedAt;
  const ChatUserConversation({
    required this.id,
    required this.userId,
    required this.conversationId,
    required this.isHidden,
    required this.isPinned,
    required this.isMuted,
    required this.userReadSeq,
    required this.version,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['conversation_id'] = Variable<String>(conversationId);
    map['is_hidden'] = Variable<int>(isHidden);
    map['is_pinned'] = Variable<int>(isPinned);
    map['is_muted'] = Variable<int>(isMuted);
    map['user_read_seq'] = Variable<int>(userReadSeq);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  ChatUserConversationsCompanion toCompanion(bool nullToAbsent) {
    return ChatUserConversationsCompanion(
      id: Value(id),
      userId: Value(userId),
      conversationId: Value(conversationId),
      isHidden: Value(isHidden),
      isPinned: Value(isPinned),
      isMuted: Value(isMuted),
      userReadSeq: Value(userReadSeq),
      version: Value(version),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ChatUserConversation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatUserConversation(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      isHidden: serializer.fromJson<int>(json['isHidden']),
      isPinned: serializer.fromJson<int>(json['isPinned']),
      isMuted: serializer.fromJson<int>(json['isMuted']),
      userReadSeq: serializer.fromJson<int>(json['userReadSeq']),
      version: serializer.fromJson<int>(json['version']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'conversationId': serializer.toJson<String>(conversationId),
      'isHidden': serializer.toJson<int>(isHidden),
      'isPinned': serializer.toJson<int>(isPinned),
      'isMuted': serializer.toJson<int>(isMuted),
      'userReadSeq': serializer.toJson<int>(userReadSeq),
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  ChatUserConversation copyWith({
    int? id,
    String? userId,
    String? conversationId,
    int? isHidden,
    int? isPinned,
    int? isMuted,
    int? userReadSeq,
    int? version,
    Value<int?> updatedAt = const Value.absent(),
  }) => ChatUserConversation(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    conversationId: conversationId ?? this.conversationId,
    isHidden: isHidden ?? this.isHidden,
    isPinned: isPinned ?? this.isPinned,
    isMuted: isMuted ?? this.isMuted,
    userReadSeq: userReadSeq ?? this.userReadSeq,
    version: version ?? this.version,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ChatUserConversation copyWithCompanion(ChatUserConversationsCompanion data) {
    return ChatUserConversation(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      isHidden: data.isHidden.present ? data.isHidden.value : this.isHidden,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isMuted: data.isMuted.present ? data.isMuted.value : this.isMuted,
      userReadSeq: data.userReadSeq.present
          ? data.userReadSeq.value
          : this.userReadSeq,
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatUserConversation(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('conversationId: $conversationId, ')
          ..write('isHidden: $isHidden, ')
          ..write('isPinned: $isPinned, ')
          ..write('isMuted: $isMuted, ')
          ..write('userReadSeq: $userReadSeq, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    conversationId,
    isHidden,
    isPinned,
    isMuted,
    userReadSeq,
    version,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatUserConversation &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.conversationId == this.conversationId &&
          other.isHidden == this.isHidden &&
          other.isPinned == this.isPinned &&
          other.isMuted == this.isMuted &&
          other.userReadSeq == this.userReadSeq &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt);
}

class ChatUserConversationsCompanion
    extends UpdateCompanion<ChatUserConversation> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> conversationId;
  final Value<int> isHidden;
  final Value<int> isPinned;
  final Value<int> isMuted;
  final Value<int> userReadSeq;
  final Value<int> version;
  final Value<int?> updatedAt;
  const ChatUserConversationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.isHidden = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isMuted = const Value.absent(),
    this.userReadSeq = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ChatUserConversationsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String conversationId,
    this.isHidden = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isMuted = const Value.absent(),
    this.userReadSeq = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId),
       conversationId = Value(conversationId);
  static Insertable<ChatUserConversation> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? conversationId,
    Expression<int>? isHidden,
    Expression<int>? isPinned,
    Expression<int>? isMuted,
    Expression<int>? userReadSeq,
    Expression<int>? version,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (conversationId != null) 'conversation_id': conversationId,
      if (isHidden != null) 'is_hidden': isHidden,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isMuted != null) 'is_muted': isMuted,
      if (userReadSeq != null) 'user_read_seq': userReadSeq,
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ChatUserConversationsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<String>? conversationId,
    Value<int>? isHidden,
    Value<int>? isPinned,
    Value<int>? isMuted,
    Value<int>? userReadSeq,
    Value<int>? version,
    Value<int?>? updatedAt,
  }) {
    return ChatUserConversationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      conversationId: conversationId ?? this.conversationId,
      isHidden: isHidden ?? this.isHidden,
      isPinned: isPinned ?? this.isPinned,
      isMuted: isMuted ?? this.isMuted,
      userReadSeq: userReadSeq ?? this.userReadSeq,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (isHidden.present) {
      map['is_hidden'] = Variable<int>(isHidden.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<int>(isPinned.value);
    }
    if (isMuted.present) {
      map['is_muted'] = Variable<int>(isMuted.value);
    }
    if (userReadSeq.present) {
      map['user_read_seq'] = Variable<int>(userReadSeq.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatUserConversationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('conversationId: $conversationId, ')
          ..write('isHidden: $isHidden, ')
          ..write('isPinned: $isPinned, ')
          ..write('isMuted: $isMuted, ')
          ..write('userReadSeq: $userReadSeq, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ChatSyncStatusTable extends ChatSyncStatus
    with TableInfo<$ChatSyncStatusTable, ChatSyncStatusData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatSyncStatusTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleMeta = const VerificationMeta('module');
  @override
  late final GeneratedColumn<String> module = GeneratedColumn<String>(
    'module',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    module,
    seq,
    version,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_sync_status';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatSyncStatusData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('module')) {
      context.handle(
        _moduleMeta,
        module.isAcceptableOrUnknown(data['module']!, _moduleMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatSyncStatusData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatSyncStatusData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      module: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ChatSyncStatusTable createAlias(String alias) {
    return $ChatSyncStatusTable(attachedDatabase, alias);
  }
}

class ChatSyncStatusData extends DataClass
    implements Insertable<ChatSyncStatusData> {
  final int id;
  final String conversationId;
  final String module;
  final int seq;
  final int version;
  final int? updatedAt;
  const ChatSyncStatusData({
    required this.id,
    required this.conversationId,
    required this.module,
    required this.seq,
    required this.version,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['module'] = Variable<String>(module);
    map['seq'] = Variable<int>(seq);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  ChatSyncStatusCompanion toCompanion(bool nullToAbsent) {
    return ChatSyncStatusCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      module: Value(module),
      seq: Value(seq),
      version: Value(version),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ChatSyncStatusData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatSyncStatusData(
      id: serializer.fromJson<int>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      module: serializer.fromJson<String>(json['module']),
      seq: serializer.fromJson<int>(json['seq']),
      version: serializer.fromJson<int>(json['version']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'module': serializer.toJson<String>(module),
      'seq': serializer.toJson<int>(seq),
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  ChatSyncStatusData copyWith({
    int? id,
    String? conversationId,
    String? module,
    int? seq,
    int? version,
    Value<int?> updatedAt = const Value.absent(),
  }) => ChatSyncStatusData(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    module: module ?? this.module,
    seq: seq ?? this.seq,
    version: version ?? this.version,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ChatSyncStatusData copyWithCompanion(ChatSyncStatusCompanion data) {
    return ChatSyncStatusData(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      module: data.module.present ? data.module.value : this.module,
      seq: data.seq.present ? data.seq.value : this.seq,
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatSyncStatusData(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('module: $module, ')
          ..write('seq: $seq, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, conversationId, module, seq, version, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatSyncStatusData &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.module == this.module &&
          other.seq == this.seq &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt);
}

class ChatSyncStatusCompanion extends UpdateCompanion<ChatSyncStatusData> {
  final Value<int> id;
  final Value<String> conversationId;
  final Value<String> module;
  final Value<int> seq;
  final Value<int> version;
  final Value<int?> updatedAt;
  const ChatSyncStatusCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.module = const Value.absent(),
    this.seq = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ChatSyncStatusCompanion.insert({
    this.id = const Value.absent(),
    required String conversationId,
    required String module,
    this.seq = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : conversationId = Value(conversationId),
       module = Value(module);
  static Insertable<ChatSyncStatusData> custom({
    Expression<int>? id,
    Expression<String>? conversationId,
    Expression<String>? module,
    Expression<int>? seq,
    Expression<int>? version,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (module != null) 'module': module,
      if (seq != null) 'seq': seq,
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ChatSyncStatusCompanion copyWith({
    Value<int>? id,
    Value<String>? conversationId,
    Value<String>? module,
    Value<int>? seq,
    Value<int>? version,
    Value<int?>? updatedAt,
  }) {
    return ChatSyncStatusCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      module: module ?? this.module,
      seq: seq ?? this.seq,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (module.present) {
      map['module'] = Variable<String>(module.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatSyncStatusCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('module: $module, ')
          ..write('seq: $seq, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FriendsTable extends Friends with TableInfo<$FriendsTable, Friend> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FriendsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _friendIdMeta = const VerificationMeta(
    'friendId',
  );
  @override
  late final GeneratedColumn<String> friendId = GeneratedColumn<String>(
    'friend_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sendUserIdMeta = const VerificationMeta(
    'sendUserId',
  );
  @override
  late final GeneratedColumn<String> sendUserId = GeneratedColumn<String>(
    'send_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revUserIdMeta = const VerificationMeta(
    'revUserId',
  );
  @override
  late final GeneratedColumn<String> revUserId = GeneratedColumn<String>(
    'rev_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sendUserNoticeMeta = const VerificationMeta(
    'sendUserNotice',
  );
  @override
  late final GeneratedColumn<String> sendUserNotice = GeneratedColumn<String>(
    'send_user_notice',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revUserNoticeMeta = const VerificationMeta(
    'revUserNotice',
  );
  @override
  late final GeneratedColumn<String> revUserNotice = GeneratedColumn<String>(
    'rev_user_notice',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    friendId,
    sendUserId,
    revUserId,
    sendUserNotice,
    revUserNotice,
    source,
    isDeleted,
    version,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'friends';
  @override
  VerificationContext validateIntegrity(
    Insertable<Friend> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('friend_id')) {
      context.handle(
        _friendIdMeta,
        friendId.isAcceptableOrUnknown(data['friend_id']!, _friendIdMeta),
      );
    } else if (isInserting) {
      context.missing(_friendIdMeta);
    }
    if (data.containsKey('send_user_id')) {
      context.handle(
        _sendUserIdMeta,
        sendUserId.isAcceptableOrUnknown(
          data['send_user_id']!,
          _sendUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sendUserIdMeta);
    }
    if (data.containsKey('rev_user_id')) {
      context.handle(
        _revUserIdMeta,
        revUserId.isAcceptableOrUnknown(data['rev_user_id']!, _revUserIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revUserIdMeta);
    }
    if (data.containsKey('send_user_notice')) {
      context.handle(
        _sendUserNoticeMeta,
        sendUserNotice.isAcceptableOrUnknown(
          data['send_user_notice']!,
          _sendUserNoticeMeta,
        ),
      );
    }
    if (data.containsKey('rev_user_notice')) {
      context.handle(
        _revUserNoticeMeta,
        revUserNotice.isAcceptableOrUnknown(
          data['rev_user_notice']!,
          _revUserNoticeMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Friend map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Friend(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      friendId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}friend_id'],
      )!,
      sendUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}send_user_id'],
      )!,
      revUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rev_user_id'],
      )!,
      sendUserNotice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}send_user_notice'],
      ),
      revUserNotice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rev_user_notice'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_deleted'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $FriendsTable createAlias(String alias) {
    return $FriendsTable(attachedDatabase, alias);
  }
}

class Friend extends DataClass implements Insertable<Friend> {
  final int id;
  final String friendId;
  final String sendUserId;
  final String revUserId;
  final String? sendUserNotice;
  final String? revUserNotice;
  final String? source;
  final int isDeleted;
  final int version;
  final int? createdAt;
  final int? updatedAt;
  const Friend({
    required this.id,
    required this.friendId,
    required this.sendUserId,
    required this.revUserId,
    this.sendUserNotice,
    this.revUserNotice,
    this.source,
    required this.isDeleted,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['friend_id'] = Variable<String>(friendId);
    map['send_user_id'] = Variable<String>(sendUserId);
    map['rev_user_id'] = Variable<String>(revUserId);
    if (!nullToAbsent || sendUserNotice != null) {
      map['send_user_notice'] = Variable<String>(sendUserNotice);
    }
    if (!nullToAbsent || revUserNotice != null) {
      map['rev_user_notice'] = Variable<String>(revUserNotice);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  FriendsCompanion toCompanion(bool nullToAbsent) {
    return FriendsCompanion(
      id: Value(id),
      friendId: Value(friendId),
      sendUserId: Value(sendUserId),
      revUserId: Value(revUserId),
      sendUserNotice: sendUserNotice == null && nullToAbsent
          ? const Value.absent()
          : Value(sendUserNotice),
      revUserNotice: revUserNotice == null && nullToAbsent
          ? const Value.absent()
          : Value(revUserNotice),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      isDeleted: Value(isDeleted),
      version: Value(version),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Friend.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Friend(
      id: serializer.fromJson<int>(json['id']),
      friendId: serializer.fromJson<String>(json['friendId']),
      sendUserId: serializer.fromJson<String>(json['sendUserId']),
      revUserId: serializer.fromJson<String>(json['revUserId']),
      sendUserNotice: serializer.fromJson<String?>(json['sendUserNotice']),
      revUserNotice: serializer.fromJson<String?>(json['revUserNotice']),
      source: serializer.fromJson<String?>(json['source']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'friendId': serializer.toJson<String>(friendId),
      'sendUserId': serializer.toJson<String>(sendUserId),
      'revUserId': serializer.toJson<String>(revUserId),
      'sendUserNotice': serializer.toJson<String?>(sendUserNotice),
      'revUserNotice': serializer.toJson<String?>(revUserNotice),
      'source': serializer.toJson<String?>(source),
      'isDeleted': serializer.toJson<int>(isDeleted),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  Friend copyWith({
    int? id,
    String? friendId,
    String? sendUserId,
    String? revUserId,
    Value<String?> sendUserNotice = const Value.absent(),
    Value<String?> revUserNotice = const Value.absent(),
    Value<String?> source = const Value.absent(),
    int? isDeleted,
    int? version,
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => Friend(
    id: id ?? this.id,
    friendId: friendId ?? this.friendId,
    sendUserId: sendUserId ?? this.sendUserId,
    revUserId: revUserId ?? this.revUserId,
    sendUserNotice: sendUserNotice.present
        ? sendUserNotice.value
        : this.sendUserNotice,
    revUserNotice: revUserNotice.present
        ? revUserNotice.value
        : this.revUserNotice,
    source: source.present ? source.value : this.source,
    isDeleted: isDeleted ?? this.isDeleted,
    version: version ?? this.version,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Friend copyWithCompanion(FriendsCompanion data) {
    return Friend(
      id: data.id.present ? data.id.value : this.id,
      friendId: data.friendId.present ? data.friendId.value : this.friendId,
      sendUserId: data.sendUserId.present
          ? data.sendUserId.value
          : this.sendUserId,
      revUserId: data.revUserId.present ? data.revUserId.value : this.revUserId,
      sendUserNotice: data.sendUserNotice.present
          ? data.sendUserNotice.value
          : this.sendUserNotice,
      revUserNotice: data.revUserNotice.present
          ? data.revUserNotice.value
          : this.revUserNotice,
      source: data.source.present ? data.source.value : this.source,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Friend(')
          ..write('id: $id, ')
          ..write('friendId: $friendId, ')
          ..write('sendUserId: $sendUserId, ')
          ..write('revUserId: $revUserId, ')
          ..write('sendUserNotice: $sendUserNotice, ')
          ..write('revUserNotice: $revUserNotice, ')
          ..write('source: $source, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    friendId,
    sendUserId,
    revUserId,
    sendUserNotice,
    revUserNotice,
    source,
    isDeleted,
    version,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Friend &&
          other.id == this.id &&
          other.friendId == this.friendId &&
          other.sendUserId == this.sendUserId &&
          other.revUserId == this.revUserId &&
          other.sendUserNotice == this.sendUserNotice &&
          other.revUserNotice == this.revUserNotice &&
          other.source == this.source &&
          other.isDeleted == this.isDeleted &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FriendsCompanion extends UpdateCompanion<Friend> {
  final Value<int> id;
  final Value<String> friendId;
  final Value<String> sendUserId;
  final Value<String> revUserId;
  final Value<String?> sendUserNotice;
  final Value<String?> revUserNotice;
  final Value<String?> source;
  final Value<int> isDeleted;
  final Value<int> version;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  const FriendsCompanion({
    this.id = const Value.absent(),
    this.friendId = const Value.absent(),
    this.sendUserId = const Value.absent(),
    this.revUserId = const Value.absent(),
    this.sendUserNotice = const Value.absent(),
    this.revUserNotice = const Value.absent(),
    this.source = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FriendsCompanion.insert({
    this.id = const Value.absent(),
    required String friendId,
    required String sendUserId,
    required String revUserId,
    this.sendUserNotice = const Value.absent(),
    this.revUserNotice = const Value.absent(),
    this.source = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : friendId = Value(friendId),
       sendUserId = Value(sendUserId),
       revUserId = Value(revUserId);
  static Insertable<Friend> custom({
    Expression<int>? id,
    Expression<String>? friendId,
    Expression<String>? sendUserId,
    Expression<String>? revUserId,
    Expression<String>? sendUserNotice,
    Expression<String>? revUserNotice,
    Expression<String>? source,
    Expression<int>? isDeleted,
    Expression<int>? version,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (friendId != null) 'friend_id': friendId,
      if (sendUserId != null) 'send_user_id': sendUserId,
      if (revUserId != null) 'rev_user_id': revUserId,
      if (sendUserNotice != null) 'send_user_notice': sendUserNotice,
      if (revUserNotice != null) 'rev_user_notice': revUserNotice,
      if (source != null) 'source': source,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FriendsCompanion copyWith({
    Value<int>? id,
    Value<String>? friendId,
    Value<String>? sendUserId,
    Value<String>? revUserId,
    Value<String?>? sendUserNotice,
    Value<String?>? revUserNotice,
    Value<String?>? source,
    Value<int>? isDeleted,
    Value<int>? version,
    Value<int?>? createdAt,
    Value<int?>? updatedAt,
  }) {
    return FriendsCompanion(
      id: id ?? this.id,
      friendId: friendId ?? this.friendId,
      sendUserId: sendUserId ?? this.sendUserId,
      revUserId: revUserId ?? this.revUserId,
      sendUserNotice: sendUserNotice ?? this.sendUserNotice,
      revUserNotice: revUserNotice ?? this.revUserNotice,
      source: source ?? this.source,
      isDeleted: isDeleted ?? this.isDeleted,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (friendId.present) {
      map['friend_id'] = Variable<String>(friendId.value);
    }
    if (sendUserId.present) {
      map['send_user_id'] = Variable<String>(sendUserId.value);
    }
    if (revUserId.present) {
      map['rev_user_id'] = Variable<String>(revUserId.value);
    }
    if (sendUserNotice.present) {
      map['send_user_notice'] = Variable<String>(sendUserNotice.value);
    }
    if (revUserNotice.present) {
      map['rev_user_notice'] = Variable<String>(revUserNotice.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FriendsCompanion(')
          ..write('id: $id, ')
          ..write('friendId: $friendId, ')
          ..write('sendUserId: $sendUserId, ')
          ..write('revUserId: $revUserId, ')
          ..write('sendUserNotice: $sendUserNotice, ')
          ..write('revUserNotice: $revUserNotice, ')
          ..write('source: $source, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FriendVerifiesTable extends FriendVerifies
    with TableInfo<$FriendVerifiesTable, FriendVerify> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FriendVerifiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _verifyIdMeta = const VerificationMeta(
    'verifyId',
  );
  @override
  late final GeneratedColumn<String> verifyId = GeneratedColumn<String>(
    'verify_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sendUserIdMeta = const VerificationMeta(
    'sendUserId',
  );
  @override
  late final GeneratedColumn<String> sendUserId = GeneratedColumn<String>(
    'send_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revUserIdMeta = const VerificationMeta(
    'revUserId',
  );
  @override
  late final GeneratedColumn<String> revUserId = GeneratedColumn<String>(
    'rev_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sendStatusMeta = const VerificationMeta(
    'sendStatus',
  );
  @override
  late final GeneratedColumn<int> sendStatus = GeneratedColumn<int>(
    'send_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _revStatusMeta = const VerificationMeta(
    'revStatus',
  );
  @override
  late final GeneratedColumn<int> revStatus = GeneratedColumn<int>(
    'rev_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    verifyId,
    sendUserId,
    revUserId,
    sendStatus,
    revStatus,
    message,
    source,
    version,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'friend_verifies';
  @override
  VerificationContext validateIntegrity(
    Insertable<FriendVerify> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('verify_id')) {
      context.handle(
        _verifyIdMeta,
        verifyId.isAcceptableOrUnknown(data['verify_id']!, _verifyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_verifyIdMeta);
    }
    if (data.containsKey('send_user_id')) {
      context.handle(
        _sendUserIdMeta,
        sendUserId.isAcceptableOrUnknown(
          data['send_user_id']!,
          _sendUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sendUserIdMeta);
    }
    if (data.containsKey('rev_user_id')) {
      context.handle(
        _revUserIdMeta,
        revUserId.isAcceptableOrUnknown(data['rev_user_id']!, _revUserIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revUserIdMeta);
    }
    if (data.containsKey('send_status')) {
      context.handle(
        _sendStatusMeta,
        sendStatus.isAcceptableOrUnknown(data['send_status']!, _sendStatusMeta),
      );
    }
    if (data.containsKey('rev_status')) {
      context.handle(
        _revStatusMeta,
        revStatus.isAcceptableOrUnknown(data['rev_status']!, _revStatusMeta),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FriendVerify map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FriendVerify(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      verifyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verify_id'],
      )!,
      sendUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}send_user_id'],
      )!,
      revUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rev_user_id'],
      )!,
      sendStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}send_status'],
      )!,
      revStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev_status'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $FriendVerifiesTable createAlias(String alias) {
    return $FriendVerifiesTable(attachedDatabase, alias);
  }
}

class FriendVerify extends DataClass implements Insertable<FriendVerify> {
  final int id;
  final String verifyId;
  final String sendUserId;
  final String revUserId;
  final int sendStatus;
  final int revStatus;
  final String? message;
  final String? source;
  final int version;
  final int? createdAt;
  final int? updatedAt;
  const FriendVerify({
    required this.id,
    required this.verifyId,
    required this.sendUserId,
    required this.revUserId,
    required this.sendStatus,
    required this.revStatus,
    this.message,
    this.source,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['verify_id'] = Variable<String>(verifyId);
    map['send_user_id'] = Variable<String>(sendUserId);
    map['rev_user_id'] = Variable<String>(revUserId);
    map['send_status'] = Variable<int>(sendStatus);
    map['rev_status'] = Variable<int>(revStatus);
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  FriendVerifiesCompanion toCompanion(bool nullToAbsent) {
    return FriendVerifiesCompanion(
      id: Value(id),
      verifyId: Value(verifyId),
      sendUserId: Value(sendUserId),
      revUserId: Value(revUserId),
      sendStatus: Value(sendStatus),
      revStatus: Value(revStatus),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      version: Value(version),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory FriendVerify.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FriendVerify(
      id: serializer.fromJson<int>(json['id']),
      verifyId: serializer.fromJson<String>(json['verifyId']),
      sendUserId: serializer.fromJson<String>(json['sendUserId']),
      revUserId: serializer.fromJson<String>(json['revUserId']),
      sendStatus: serializer.fromJson<int>(json['sendStatus']),
      revStatus: serializer.fromJson<int>(json['revStatus']),
      message: serializer.fromJson<String?>(json['message']),
      source: serializer.fromJson<String?>(json['source']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'verifyId': serializer.toJson<String>(verifyId),
      'sendUserId': serializer.toJson<String>(sendUserId),
      'revUserId': serializer.toJson<String>(revUserId),
      'sendStatus': serializer.toJson<int>(sendStatus),
      'revStatus': serializer.toJson<int>(revStatus),
      'message': serializer.toJson<String?>(message),
      'source': serializer.toJson<String?>(source),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  FriendVerify copyWith({
    int? id,
    String? verifyId,
    String? sendUserId,
    String? revUserId,
    int? sendStatus,
    int? revStatus,
    Value<String?> message = const Value.absent(),
    Value<String?> source = const Value.absent(),
    int? version,
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => FriendVerify(
    id: id ?? this.id,
    verifyId: verifyId ?? this.verifyId,
    sendUserId: sendUserId ?? this.sendUserId,
    revUserId: revUserId ?? this.revUserId,
    sendStatus: sendStatus ?? this.sendStatus,
    revStatus: revStatus ?? this.revStatus,
    message: message.present ? message.value : this.message,
    source: source.present ? source.value : this.source,
    version: version ?? this.version,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  FriendVerify copyWithCompanion(FriendVerifiesCompanion data) {
    return FriendVerify(
      id: data.id.present ? data.id.value : this.id,
      verifyId: data.verifyId.present ? data.verifyId.value : this.verifyId,
      sendUserId: data.sendUserId.present
          ? data.sendUserId.value
          : this.sendUserId,
      revUserId: data.revUserId.present ? data.revUserId.value : this.revUserId,
      sendStatus: data.sendStatus.present
          ? data.sendStatus.value
          : this.sendStatus,
      revStatus: data.revStatus.present ? data.revStatus.value : this.revStatus,
      message: data.message.present ? data.message.value : this.message,
      source: data.source.present ? data.source.value : this.source,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FriendVerify(')
          ..write('id: $id, ')
          ..write('verifyId: $verifyId, ')
          ..write('sendUserId: $sendUserId, ')
          ..write('revUserId: $revUserId, ')
          ..write('sendStatus: $sendStatus, ')
          ..write('revStatus: $revStatus, ')
          ..write('message: $message, ')
          ..write('source: $source, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    verifyId,
    sendUserId,
    revUserId,
    sendStatus,
    revStatus,
    message,
    source,
    version,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FriendVerify &&
          other.id == this.id &&
          other.verifyId == this.verifyId &&
          other.sendUserId == this.sendUserId &&
          other.revUserId == this.revUserId &&
          other.sendStatus == this.sendStatus &&
          other.revStatus == this.revStatus &&
          other.message == this.message &&
          other.source == this.source &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FriendVerifiesCompanion extends UpdateCompanion<FriendVerify> {
  final Value<int> id;
  final Value<String> verifyId;
  final Value<String> sendUserId;
  final Value<String> revUserId;
  final Value<int> sendStatus;
  final Value<int> revStatus;
  final Value<String?> message;
  final Value<String?> source;
  final Value<int> version;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  const FriendVerifiesCompanion({
    this.id = const Value.absent(),
    this.verifyId = const Value.absent(),
    this.sendUserId = const Value.absent(),
    this.revUserId = const Value.absent(),
    this.sendStatus = const Value.absent(),
    this.revStatus = const Value.absent(),
    this.message = const Value.absent(),
    this.source = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FriendVerifiesCompanion.insert({
    this.id = const Value.absent(),
    required String verifyId,
    required String sendUserId,
    required String revUserId,
    this.sendStatus = const Value.absent(),
    this.revStatus = const Value.absent(),
    this.message = const Value.absent(),
    this.source = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : verifyId = Value(verifyId),
       sendUserId = Value(sendUserId),
       revUserId = Value(revUserId);
  static Insertable<FriendVerify> custom({
    Expression<int>? id,
    Expression<String>? verifyId,
    Expression<String>? sendUserId,
    Expression<String>? revUserId,
    Expression<int>? sendStatus,
    Expression<int>? revStatus,
    Expression<String>? message,
    Expression<String>? source,
    Expression<int>? version,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (verifyId != null) 'verify_id': verifyId,
      if (sendUserId != null) 'send_user_id': sendUserId,
      if (revUserId != null) 'rev_user_id': revUserId,
      if (sendStatus != null) 'send_status': sendStatus,
      if (revStatus != null) 'rev_status': revStatus,
      if (message != null) 'message': message,
      if (source != null) 'source': source,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FriendVerifiesCompanion copyWith({
    Value<int>? id,
    Value<String>? verifyId,
    Value<String>? sendUserId,
    Value<String>? revUserId,
    Value<int>? sendStatus,
    Value<int>? revStatus,
    Value<String?>? message,
    Value<String?>? source,
    Value<int>? version,
    Value<int?>? createdAt,
    Value<int?>? updatedAt,
  }) {
    return FriendVerifiesCompanion(
      id: id ?? this.id,
      verifyId: verifyId ?? this.verifyId,
      sendUserId: sendUserId ?? this.sendUserId,
      revUserId: revUserId ?? this.revUserId,
      sendStatus: sendStatus ?? this.sendStatus,
      revStatus: revStatus ?? this.revStatus,
      message: message ?? this.message,
      source: source ?? this.source,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (verifyId.present) {
      map['verify_id'] = Variable<String>(verifyId.value);
    }
    if (sendUserId.present) {
      map['send_user_id'] = Variable<String>(sendUserId.value);
    }
    if (revUserId.present) {
      map['rev_user_id'] = Variable<String>(revUserId.value);
    }
    if (sendStatus.present) {
      map['send_status'] = Variable<int>(sendStatus.value);
    }
    if (revStatus.present) {
      map['rev_status'] = Variable<int>(revStatus.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FriendVerifiesCompanion(')
          ..write('id: $id, ')
          ..write('verifyId: $verifyId, ')
          ..write('sendUserId: $sendUserId, ')
          ..write('revUserId: $revUserId, ')
          ..write('sendStatus: $sendStatus, ')
          ..write('revStatus: $revStatus, ')
          ..write('message: $message, ')
          ..write('source: $source, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
    'avatar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('a9de5548bef8c10b92428fff61275c72.png'),
  );
  static const VerificationMeta _creatorIdMeta = const VerificationMeta(
    'creatorId',
  );
  @override
  late final GeneratedColumn<String> creatorId = GeneratedColumn<String>(
    'creator_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noticeMeta = const VerificationMeta('notice');
  @override
  late final GeneratedColumn<String> notice = GeneratedColumn<String>(
    'notice',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _joinTypeMeta = const VerificationMeta(
    'joinType',
  );
  @override
  late final GeneratedColumn<int> joinType = GeneratedColumn<int>(
    'join_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    type,
    title,
    avatar,
    creatorId,
    notice,
    joinType,
    status,
    version,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<Group> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    }
    if (data.containsKey('creator_id')) {
      context.handle(
        _creatorIdMeta,
        creatorId.isAcceptableOrUnknown(data['creator_id']!, _creatorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creatorIdMeta);
    }
    if (data.containsKey('notice')) {
      context.handle(
        _noticeMeta,
        notice.isAcceptableOrUnknown(data['notice']!, _noticeMeta),
      );
    }
    if (data.containsKey('join_type')) {
      context.handle(
        _joinTypeMeta,
        joinType.isAcceptableOrUnknown(data['join_type']!, _joinTypeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Group(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      )!,
      creatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator_id'],
      )!,
      notice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notice'],
      ),
      joinType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}join_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  final int id;
  final String groupId;
  final int type;
  final String title;
  final String avatar;
  final String creatorId;
  final String? notice;
  final int joinType;
  final int status;
  final int version;
  final int? createdAt;
  final int? updatedAt;
  const Group({
    required this.id,
    required this.groupId,
    required this.type,
    required this.title,
    required this.avatar,
    required this.creatorId,
    this.notice,
    required this.joinType,
    required this.status,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<String>(groupId);
    map['type'] = Variable<int>(type);
    map['title'] = Variable<String>(title);
    map['avatar'] = Variable<String>(avatar);
    map['creator_id'] = Variable<String>(creatorId);
    if (!nullToAbsent || notice != null) {
      map['notice'] = Variable<String>(notice);
    }
    map['join_type'] = Variable<int>(joinType);
    map['status'] = Variable<int>(status);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      type: Value(type),
      title: Value(title),
      avatar: Value(avatar),
      creatorId: Value(creatorId),
      notice: notice == null && nullToAbsent
          ? const Value.absent()
          : Value(notice),
      joinType: Value(joinType),
      status: Value(status),
      version: Value(version),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Group.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      type: serializer.fromJson<int>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      avatar: serializer.fromJson<String>(json['avatar']),
      creatorId: serializer.fromJson<String>(json['creatorId']),
      notice: serializer.fromJson<String?>(json['notice']),
      joinType: serializer.fromJson<int>(json['joinType']),
      status: serializer.fromJson<int>(json['status']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<String>(groupId),
      'type': serializer.toJson<int>(type),
      'title': serializer.toJson<String>(title),
      'avatar': serializer.toJson<String>(avatar),
      'creatorId': serializer.toJson<String>(creatorId),
      'notice': serializer.toJson<String?>(notice),
      'joinType': serializer.toJson<int>(joinType),
      'status': serializer.toJson<int>(status),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  Group copyWith({
    int? id,
    String? groupId,
    int? type,
    String? title,
    String? avatar,
    String? creatorId,
    Value<String?> notice = const Value.absent(),
    int? joinType,
    int? status,
    int? version,
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => Group(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    type: type ?? this.type,
    title: title ?? this.title,
    avatar: avatar ?? this.avatar,
    creatorId: creatorId ?? this.creatorId,
    notice: notice.present ? notice.value : this.notice,
    joinType: joinType ?? this.joinType,
    status: status ?? this.status,
    version: version ?? this.version,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Group copyWithCompanion(GroupsCompanion data) {
    return Group(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      creatorId: data.creatorId.present ? data.creatorId.value : this.creatorId,
      notice: data.notice.present ? data.notice.value : this.notice,
      joinType: data.joinType.present ? data.joinType.value : this.joinType,
      status: data.status.present ? data.status.value : this.status,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('avatar: $avatar, ')
          ..write('creatorId: $creatorId, ')
          ..write('notice: $notice, ')
          ..write('joinType: $joinType, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    type,
    title,
    avatar,
    creatorId,
    notice,
    joinType,
    status,
    version,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.type == this.type &&
          other.title == this.title &&
          other.avatar == this.avatar &&
          other.creatorId == this.creatorId &&
          other.notice == this.notice &&
          other.joinType == this.joinType &&
          other.status == this.status &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<int> id;
  final Value<String> groupId;
  final Value<int> type;
  final Value<String> title;
  final Value<String> avatar;
  final Value<String> creatorId;
  final Value<String?> notice;
  final Value<int> joinType;
  final Value<int> status;
  final Value<int> version;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.avatar = const Value.absent(),
    this.creatorId = const Value.absent(),
    this.notice = const Value.absent(),
    this.joinType = const Value.absent(),
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    required String groupId,
    this.type = const Value.absent(),
    required String title,
    this.avatar = const Value.absent(),
    required String creatorId,
    this.notice = const Value.absent(),
    this.joinType = const Value.absent(),
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : groupId = Value(groupId),
       title = Value(title),
       creatorId = Value(creatorId);
  static Insertable<Group> custom({
    Expression<int>? id,
    Expression<String>? groupId,
    Expression<int>? type,
    Expression<String>? title,
    Expression<String>? avatar,
    Expression<String>? creatorId,
    Expression<String>? notice,
    Expression<int>? joinType,
    Expression<int>? status,
    Expression<int>? version,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (avatar != null) 'avatar': avatar,
      if (creatorId != null) 'creator_id': creatorId,
      if (notice != null) 'notice': notice,
      if (joinType != null) 'join_type': joinType,
      if (status != null) 'status': status,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  GroupsCompanion copyWith({
    Value<int>? id,
    Value<String>? groupId,
    Value<int>? type,
    Value<String>? title,
    Value<String>? avatar,
    Value<String>? creatorId,
    Value<String?>? notice,
    Value<int>? joinType,
    Value<int>? status,
    Value<int>? version,
    Value<int?>? createdAt,
    Value<int?>? updatedAt,
  }) {
    return GroupsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      type: type ?? this.type,
      title: title ?? this.title,
      avatar: avatar ?? this.avatar,
      creatorId: creatorId ?? this.creatorId,
      notice: notice ?? this.notice,
      joinType: joinType ?? this.joinType,
      status: status ?? this.status,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (creatorId.present) {
      map['creator_id'] = Variable<String>(creatorId.value);
    }
    if (notice.present) {
      map['notice'] = Variable<String>(notice.value);
    }
    if (joinType.present) {
      map['join_type'] = Variable<int>(joinType.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('avatar: $avatar, ')
          ..write('creatorId: $creatorId, ')
          ..write('notice: $notice, ')
          ..write('joinType: $joinType, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GroupMembersTable extends GroupMembers
    with TableInfo<$GroupMembersTable, GroupMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<int> role = GeneratedColumn<int>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _joinTimeMeta = const VerificationMeta(
    'joinTime',
  );
  @override
  late final GeneratedColumn<int> joinTime = GeneratedColumn<int>(
    'join_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    userId,
    role,
    status,
    joinTime,
    version,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('join_time')) {
      context.handle(
        _joinTimeMeta,
        joinTime.isAcceptableOrUnknown(data['join_time']!, _joinTimeMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}role'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      joinTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}join_time'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $GroupMembersTable createAlias(String alias) {
    return $GroupMembersTable(attachedDatabase, alias);
  }
}

class GroupMember extends DataClass implements Insertable<GroupMember> {
  final int id;
  final String groupId;
  final String userId;
  final int role;
  final int status;
  final int? joinTime;
  final int version;
  final int? createdAt;
  final int? updatedAt;
  const GroupMember({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.role,
    required this.status,
    this.joinTime,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<String>(groupId);
    map['user_id'] = Variable<String>(userId);
    map['role'] = Variable<int>(role);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || joinTime != null) {
      map['join_time'] = Variable<int>(joinTime);
    }
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  GroupMembersCompanion toCompanion(bool nullToAbsent) {
    return GroupMembersCompanion(
      id: Value(id),
      groupId: Value(groupId),
      userId: Value(userId),
      role: Value(role),
      status: Value(status),
      joinTime: joinTime == null && nullToAbsent
          ? const Value.absent()
          : Value(joinTime),
      version: Value(version),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory GroupMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupMember(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      userId: serializer.fromJson<String>(json['userId']),
      role: serializer.fromJson<int>(json['role']),
      status: serializer.fromJson<int>(json['status']),
      joinTime: serializer.fromJson<int?>(json['joinTime']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<String>(groupId),
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<int>(role),
      'status': serializer.toJson<int>(status),
      'joinTime': serializer.toJson<int?>(joinTime),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  GroupMember copyWith({
    int? id,
    String? groupId,
    String? userId,
    int? role,
    int? status,
    Value<int?> joinTime = const Value.absent(),
    int? version,
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => GroupMember(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
    status: status ?? this.status,
    joinTime: joinTime.present ? joinTime.value : this.joinTime,
    version: version ?? this.version,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  GroupMember copyWithCompanion(GroupMembersCompanion data) {
    return GroupMember(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      status: data.status.present ? data.status.value : this.status,
      joinTime: data.joinTime.present ? data.joinTime.value : this.joinTime,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupMember(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('joinTime: $joinTime, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    userId,
    role,
    status,
    joinTime,
    version,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMember &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.status == this.status &&
          other.joinTime == this.joinTime &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GroupMembersCompanion extends UpdateCompanion<GroupMember> {
  final Value<int> id;
  final Value<String> groupId;
  final Value<String> userId;
  final Value<int> role;
  final Value<int> status;
  final Value<int?> joinTime;
  final Value<int> version;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  const GroupMembersCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.status = const Value.absent(),
    this.joinTime = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  GroupMembersCompanion.insert({
    this.id = const Value.absent(),
    required String groupId,
    required String userId,
    this.role = const Value.absent(),
    this.status = const Value.absent(),
    this.joinTime = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : groupId = Value(groupId),
       userId = Value(userId);
  static Insertable<GroupMember> custom({
    Expression<int>? id,
    Expression<String>? groupId,
    Expression<String>? userId,
    Expression<int>? role,
    Expression<int>? status,
    Expression<int>? joinTime,
    Expression<int>? version,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (status != null) 'status': status,
      if (joinTime != null) 'join_time': joinTime,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  GroupMembersCompanion copyWith({
    Value<int>? id,
    Value<String>? groupId,
    Value<String>? userId,
    Value<int>? role,
    Value<int>? status,
    Value<int?>? joinTime,
    Value<int>? version,
    Value<int?>? createdAt,
    Value<int?>? updatedAt,
  }) {
    return GroupMembersCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      status: status ?? this.status,
      joinTime: joinTime ?? this.joinTime,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<int>(role.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (joinTime.present) {
      map['join_time'] = Variable<int>(joinTime.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembersCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('joinTime: $joinTime, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GroupJoinRequestsTable extends GroupJoinRequests
    with TableInfo<$GroupJoinRequestsTable, GroupJoinRequest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupJoinRequestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _applicantUserIdMeta = const VerificationMeta(
    'applicantUserId',
  );
  @override
  late final GeneratedColumn<String> applicantUserId = GeneratedColumn<String>(
    'applicant_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _handledByMeta = const VerificationMeta(
    'handledBy',
  );
  @override
  late final GeneratedColumn<String> handledBy = GeneratedColumn<String>(
    'handled_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _handledAtMeta = const VerificationMeta(
    'handledAt',
  );
  @override
  late final GeneratedColumn<int> handledAt = GeneratedColumn<int>(
    'handled_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    applicantUserId,
    message,
    status,
    handledBy,
    handledAt,
    version,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_join_requests';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupJoinRequest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('applicant_user_id')) {
      context.handle(
        _applicantUserIdMeta,
        applicantUserId.isAcceptableOrUnknown(
          data['applicant_user_id']!,
          _applicantUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_applicantUserIdMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('handled_by')) {
      context.handle(
        _handledByMeta,
        handledBy.isAcceptableOrUnknown(data['handled_by']!, _handledByMeta),
      );
    }
    if (data.containsKey('handled_at')) {
      context.handle(
        _handledAtMeta,
        handledAt.isAcceptableOrUnknown(data['handled_at']!, _handledAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupJoinRequest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupJoinRequest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      applicantUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}applicant_user_id'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      handledBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}handled_by'],
      ),
      handledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}handled_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $GroupJoinRequestsTable createAlias(String alias) {
    return $GroupJoinRequestsTable(attachedDatabase, alias);
  }
}

class GroupJoinRequest extends DataClass
    implements Insertable<GroupJoinRequest> {
  final int id;
  final String groupId;
  final String applicantUserId;
  final String? message;
  final int status;
  final String? handledBy;
  final int? handledAt;
  final int version;
  final int? createdAt;
  final int? updatedAt;
  const GroupJoinRequest({
    required this.id,
    required this.groupId,
    required this.applicantUserId,
    this.message,
    required this.status,
    this.handledBy,
    this.handledAt,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<String>(groupId);
    map['applicant_user_id'] = Variable<String>(applicantUserId);
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || handledBy != null) {
      map['handled_by'] = Variable<String>(handledBy);
    }
    if (!nullToAbsent || handledAt != null) {
      map['handled_at'] = Variable<int>(handledAt);
    }
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  GroupJoinRequestsCompanion toCompanion(bool nullToAbsent) {
    return GroupJoinRequestsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      applicantUserId: Value(applicantUserId),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      status: Value(status),
      handledBy: handledBy == null && nullToAbsent
          ? const Value.absent()
          : Value(handledBy),
      handledAt: handledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(handledAt),
      version: Value(version),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory GroupJoinRequest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupJoinRequest(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      applicantUserId: serializer.fromJson<String>(json['applicantUserId']),
      message: serializer.fromJson<String?>(json['message']),
      status: serializer.fromJson<int>(json['status']),
      handledBy: serializer.fromJson<String?>(json['handledBy']),
      handledAt: serializer.fromJson<int?>(json['handledAt']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<String>(groupId),
      'applicantUserId': serializer.toJson<String>(applicantUserId),
      'message': serializer.toJson<String?>(message),
      'status': serializer.toJson<int>(status),
      'handledBy': serializer.toJson<String?>(handledBy),
      'handledAt': serializer.toJson<int?>(handledAt),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  GroupJoinRequest copyWith({
    int? id,
    String? groupId,
    String? applicantUserId,
    Value<String?> message = const Value.absent(),
    int? status,
    Value<String?> handledBy = const Value.absent(),
    Value<int?> handledAt = const Value.absent(),
    int? version,
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => GroupJoinRequest(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    applicantUserId: applicantUserId ?? this.applicantUserId,
    message: message.present ? message.value : this.message,
    status: status ?? this.status,
    handledBy: handledBy.present ? handledBy.value : this.handledBy,
    handledAt: handledAt.present ? handledAt.value : this.handledAt,
    version: version ?? this.version,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  GroupJoinRequest copyWithCompanion(GroupJoinRequestsCompanion data) {
    return GroupJoinRequest(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      applicantUserId: data.applicantUserId.present
          ? data.applicantUserId.value
          : this.applicantUserId,
      message: data.message.present ? data.message.value : this.message,
      status: data.status.present ? data.status.value : this.status,
      handledBy: data.handledBy.present ? data.handledBy.value : this.handledBy,
      handledAt: data.handledAt.present ? data.handledAt.value : this.handledAt,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupJoinRequest(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('applicantUserId: $applicantUserId, ')
          ..write('message: $message, ')
          ..write('status: $status, ')
          ..write('handledBy: $handledBy, ')
          ..write('handledAt: $handledAt, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    applicantUserId,
    message,
    status,
    handledBy,
    handledAt,
    version,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupJoinRequest &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.applicantUserId == this.applicantUserId &&
          other.message == this.message &&
          other.status == this.status &&
          other.handledBy == this.handledBy &&
          other.handledAt == this.handledAt &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GroupJoinRequestsCompanion extends UpdateCompanion<GroupJoinRequest> {
  final Value<int> id;
  final Value<String> groupId;
  final Value<String> applicantUserId;
  final Value<String?> message;
  final Value<int> status;
  final Value<String?> handledBy;
  final Value<int?> handledAt;
  final Value<int> version;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  const GroupJoinRequestsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.applicantUserId = const Value.absent(),
    this.message = const Value.absent(),
    this.status = const Value.absent(),
    this.handledBy = const Value.absent(),
    this.handledAt = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  GroupJoinRequestsCompanion.insert({
    this.id = const Value.absent(),
    required String groupId,
    required String applicantUserId,
    this.message = const Value.absent(),
    this.status = const Value.absent(),
    this.handledBy = const Value.absent(),
    this.handledAt = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : groupId = Value(groupId),
       applicantUserId = Value(applicantUserId);
  static Insertable<GroupJoinRequest> custom({
    Expression<int>? id,
    Expression<String>? groupId,
    Expression<String>? applicantUserId,
    Expression<String>? message,
    Expression<int>? status,
    Expression<String>? handledBy,
    Expression<int>? handledAt,
    Expression<int>? version,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (applicantUserId != null) 'applicant_user_id': applicantUserId,
      if (message != null) 'message': message,
      if (status != null) 'status': status,
      if (handledBy != null) 'handled_by': handledBy,
      if (handledAt != null) 'handled_at': handledAt,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  GroupJoinRequestsCompanion copyWith({
    Value<int>? id,
    Value<String>? groupId,
    Value<String>? applicantUserId,
    Value<String?>? message,
    Value<int>? status,
    Value<String?>? handledBy,
    Value<int?>? handledAt,
    Value<int>? version,
    Value<int?>? createdAt,
    Value<int?>? updatedAt,
  }) {
    return GroupJoinRequestsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      applicantUserId: applicantUserId ?? this.applicantUserId,
      message: message ?? this.message,
      status: status ?? this.status,
      handledBy: handledBy ?? this.handledBy,
      handledAt: handledAt ?? this.handledAt,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (applicantUserId.present) {
      map['applicant_user_id'] = Variable<String>(applicantUserId.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (handledBy.present) {
      map['handled_by'] = Variable<String>(handledBy.value);
    }
    if (handledAt.present) {
      map['handled_at'] = Variable<int>(handledAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupJoinRequestsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('applicantUserId: $applicantUserId, ')
          ..write('message: $message, ')
          ..write('status: $status, ')
          ..write('handledBy: $handledBy, ')
          ..write('handledAt: $handledAt, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GroupSyncStatusTable extends GroupSyncStatus
    with TableInfo<$GroupSyncStatusTable, GroupSyncStatusData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupSyncStatusTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleMeta = const VerificationMeta('module');
  @override
  late final GeneratedColumn<String> module = GeneratedColumn<String>(
    'module',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    module,
    version,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_sync_status';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupSyncStatusData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('module')) {
      context.handle(
        _moduleMeta,
        module.isAcceptableOrUnknown(data['module']!, _moduleMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupSyncStatusData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupSyncStatusData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      module: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $GroupSyncStatusTable createAlias(String alias) {
    return $GroupSyncStatusTable(attachedDatabase, alias);
  }
}

class GroupSyncStatusData extends DataClass
    implements Insertable<GroupSyncStatusData> {
  final int id;
  final String groupId;
  final String module;
  final int version;
  final int? updatedAt;
  const GroupSyncStatusData({
    required this.id,
    required this.groupId,
    required this.module,
    required this.version,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<String>(groupId);
    map['module'] = Variable<String>(module);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  GroupSyncStatusCompanion toCompanion(bool nullToAbsent) {
    return GroupSyncStatusCompanion(
      id: Value(id),
      groupId: Value(groupId),
      module: Value(module),
      version: Value(version),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory GroupSyncStatusData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupSyncStatusData(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      module: serializer.fromJson<String>(json['module']),
      version: serializer.fromJson<int>(json['version']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<String>(groupId),
      'module': serializer.toJson<String>(module),
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  GroupSyncStatusData copyWith({
    int? id,
    String? groupId,
    String? module,
    int? version,
    Value<int?> updatedAt = const Value.absent(),
  }) => GroupSyncStatusData(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    module: module ?? this.module,
    version: version ?? this.version,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  GroupSyncStatusData copyWithCompanion(GroupSyncStatusCompanion data) {
    return GroupSyncStatusData(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      module: data.module.present ? data.module.value : this.module,
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupSyncStatusData(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('module: $module, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, module, version, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupSyncStatusData &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.module == this.module &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt);
}

class GroupSyncStatusCompanion extends UpdateCompanion<GroupSyncStatusData> {
  final Value<int> id;
  final Value<String> groupId;
  final Value<String> module;
  final Value<int> version;
  final Value<int?> updatedAt;
  const GroupSyncStatusCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.module = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  GroupSyncStatusCompanion.insert({
    this.id = const Value.absent(),
    required String groupId,
    required String module,
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : groupId = Value(groupId),
       module = Value(module);
  static Insertable<GroupSyncStatusData> custom({
    Expression<int>? id,
    Expression<String>? groupId,
    Expression<String>? module,
    Expression<int>? version,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (module != null) 'module': module,
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  GroupSyncStatusCompanion copyWith({
    Value<int>? id,
    Value<String>? groupId,
    Value<String>? module,
    Value<int>? version,
    Value<int?>? updatedAt,
  }) {
    return GroupSyncStatusCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      module: module ?? this.module,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (module.present) {
      map['module'] = Variable<String>(module.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupSyncStatusCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('module: $module, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DatasyncTable extends Datasync
    with TableInfo<$DatasyncTable, DatasyncData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DatasyncTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _moduleMeta = const VerificationMeta('module');
  @override
  late final GeneratedColumn<String> module = GeneratedColumn<String>(
    'module',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, module, version, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'datasync';
  @override
  VerificationContext validateIntegrity(
    Insertable<DatasyncData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('module')) {
      context.handle(
        _moduleMeta,
        module.isAcceptableOrUnknown(data['module']!, _moduleMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DatasyncData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DatasyncData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      module: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DatasyncTable createAlias(String alias) {
    return $DatasyncTable(attachedDatabase, alias);
  }
}

class DatasyncData extends DataClass implements Insertable<DatasyncData> {
  final int id;
  final String module;
  final int? version;
  final int updatedAt;
  const DatasyncData({
    required this.id,
    required this.module,
    this.version,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['module'] = Variable<String>(module);
    if (!nullToAbsent || version != null) {
      map['version'] = Variable<int>(version);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  DatasyncCompanion toCompanion(bool nullToAbsent) {
    return DatasyncCompanion(
      id: Value(id),
      module: Value(module),
      version: version == null && nullToAbsent
          ? const Value.absent()
          : Value(version),
      updatedAt: Value(updatedAt),
    );
  }

  factory DatasyncData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DatasyncData(
      id: serializer.fromJson<int>(json['id']),
      module: serializer.fromJson<String>(json['module']),
      version: serializer.fromJson<int?>(json['version']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'module': serializer.toJson<String>(module),
      'version': serializer.toJson<int?>(version),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  DatasyncData copyWith({
    int? id,
    String? module,
    Value<int?> version = const Value.absent(),
    int? updatedAt,
  }) => DatasyncData(
    id: id ?? this.id,
    module: module ?? this.module,
    version: version.present ? version.value : this.version,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DatasyncData copyWithCompanion(DatasyncCompanion data) {
    return DatasyncData(
      id: data.id.present ? data.id.value : this.id,
      module: data.module.present ? data.module.value : this.module,
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DatasyncData(')
          ..write('id: $id, ')
          ..write('module: $module, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, module, version, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DatasyncData &&
          other.id == this.id &&
          other.module == this.module &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt);
}

class DatasyncCompanion extends UpdateCompanion<DatasyncData> {
  final Value<int> id;
  final Value<String> module;
  final Value<int?> version;
  final Value<int> updatedAt;
  const DatasyncCompanion({
    this.id = const Value.absent(),
    this.module = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DatasyncCompanion.insert({
    this.id = const Value.absent(),
    required String module,
    this.version = const Value.absent(),
    required int updatedAt,
  }) : module = Value(module),
       updatedAt = Value(updatedAt);
  static Insertable<DatasyncData> custom({
    Expression<int>? id,
    Expression<String>? module,
    Expression<int>? version,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (module != null) 'module': module,
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DatasyncCompanion copyWith({
    Value<int>? id,
    Value<String>? module,
    Value<int?>? version,
    Value<int>? updatedAt,
  }) {
    return DatasyncCompanion(
      id: id ?? this.id,
      module: module ?? this.module,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (module.present) {
      map['module'] = Variable<String>(module.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DatasyncCompanion(')
          ..write('id: $id, ')
          ..write('module: $module, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $UserSyncStatusTable userSyncStatus = $UserSyncStatusTable(this);
  late final $ChatsTable chats = $ChatsTable(this);
  late final $ChatConversationsTable chatConversations =
      $ChatConversationsTable(this);
  late final $ChatUserConversationsTable chatUserConversations =
      $ChatUserConversationsTable(this);
  late final $ChatSyncStatusTable chatSyncStatus = $ChatSyncStatusTable(this);
  late final $FriendsTable friends = $FriendsTable(this);
  late final $FriendVerifiesTable friendVerifies = $FriendVerifiesTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $GroupMembersTable groupMembers = $GroupMembersTable(this);
  late final $GroupJoinRequestsTable groupJoinRequests =
      $GroupJoinRequestsTable(this);
  late final $GroupSyncStatusTable groupSyncStatus = $GroupSyncStatusTable(
    this,
  );
  late final $DatasyncTable datasync = $DatasyncTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    userSyncStatus,
    chats,
    chatConversations,
    chatUserConversations,
    chatSyncStatus,
    friends,
    friendVerifies,
    groups,
    groupMembers,
    groupJoinRequests,
    groupSyncStatus,
    datasync,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String userId,
      required String nickName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> avatar,
      Value<String?> abstract,
      Value<int> gender,
      Value<int> status,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<String> nickName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> avatar,
      Value<String?> abstract,
      Value<int> gender,
      Value<int> status,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickName => $composableBuilder(
    column: $table.nickName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abstract => $composableBuilder(
    column: $table.abstract,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickName => $composableBuilder(
    column: $table.nickName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abstract => $composableBuilder(
    column: $table.abstract,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get nickName =>
      $composableBuilder(column: $table.nickName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<String> get abstract =>
      $composableBuilder(column: $table.abstract, builder: (column) => column);

  GeneratedColumn<int> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> nickName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<String?> abstract = const Value.absent(),
                Value<int> gender = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                userId: userId,
                nickName: nickName,
                email: email,
                phone: phone,
                avatar: avatar,
                abstract: abstract,
                gender: gender,
                status: status,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required String nickName,
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<String?> abstract = const Value.absent(),
                Value<int> gender = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                userId: userId,
                nickName: nickName,
                email: email,
                phone: phone,
                avatar: avatar,
                abstract: abstract,
                gender: gender,
                status: status,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$UserSyncStatusTableCreateCompanionBuilder =
    UserSyncStatusCompanion Function({
      Value<int> id,
      required String userId,
      Value<int> userVersion,
      Value<int> lastSyncTime,
      Value<int?> updatedAt,
    });
typedef $$UserSyncStatusTableUpdateCompanionBuilder =
    UserSyncStatusCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<int> userVersion,
      Value<int> lastSyncTime,
      Value<int?> updatedAt,
    });

class $$UserSyncStatusTableFilterComposer
    extends Composer<_$AppDatabase, $UserSyncStatusTable> {
  $$UserSyncStatusTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userVersion => $composableBuilder(
    column: $table.userVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncTime => $composableBuilder(
    column: $table.lastSyncTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSyncStatusTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSyncStatusTable> {
  $$UserSyncStatusTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userVersion => $composableBuilder(
    column: $table.userVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncTime => $composableBuilder(
    column: $table.lastSyncTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSyncStatusTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSyncStatusTable> {
  $$UserSyncStatusTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get userVersion => $composableBuilder(
    column: $table.userVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSyncTime => $composableBuilder(
    column: $table.lastSyncTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserSyncStatusTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSyncStatusTable,
          UserSyncStatusData,
          $$UserSyncStatusTableFilterComposer,
          $$UserSyncStatusTableOrderingComposer,
          $$UserSyncStatusTableAnnotationComposer,
          $$UserSyncStatusTableCreateCompanionBuilder,
          $$UserSyncStatusTableUpdateCompanionBuilder,
          (
            UserSyncStatusData,
            BaseReferences<
              _$AppDatabase,
              $UserSyncStatusTable,
              UserSyncStatusData
            >,
          ),
          UserSyncStatusData,
          PrefetchHooks Function()
        > {
  $$UserSyncStatusTableTableManager(
    _$AppDatabase db,
    $UserSyncStatusTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSyncStatusTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSyncStatusTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSyncStatusTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> userVersion = const Value.absent(),
                Value<int> lastSyncTime = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => UserSyncStatusCompanion(
                id: id,
                userId: userId,
                userVersion: userVersion,
                lastSyncTime: lastSyncTime,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                Value<int> userVersion = const Value.absent(),
                Value<int> lastSyncTime = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => UserSyncStatusCompanion.insert(
                id: id,
                userId: userId,
                userVersion: userVersion,
                lastSyncTime: lastSyncTime,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSyncStatusTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSyncStatusTable,
      UserSyncStatusData,
      $$UserSyncStatusTableFilterComposer,
      $$UserSyncStatusTableOrderingComposer,
      $$UserSyncStatusTableAnnotationComposer,
      $$UserSyncStatusTableCreateCompanionBuilder,
      $$UserSyncStatusTableUpdateCompanionBuilder,
      (
        UserSyncStatusData,
        BaseReferences<_$AppDatabase, $UserSyncStatusTable, UserSyncStatusData>,
      ),
      UserSyncStatusData,
      PrefetchHooks Function()
    >;
typedef $$ChatsTableCreateCompanionBuilder =
    ChatsCompanion Function({
      Value<int> id,
      required String messageId,
      required String conversationId,
      required int conversationType,
      Value<int> seq,
      Value<String?> sendUserId,
      required int msgType,
      Value<String?> targetMessageId,
      Value<String?> msgPreview,
      Value<String?> msg,
      Value<int> sendStatus,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });
typedef $$ChatsTableUpdateCompanionBuilder =
    ChatsCompanion Function({
      Value<int> id,
      Value<String> messageId,
      Value<String> conversationId,
      Value<int> conversationType,
      Value<int> seq,
      Value<String?> sendUserId,
      Value<int> msgType,
      Value<String?> targetMessageId,
      Value<String?> msgPreview,
      Value<String?> msg,
      Value<int> sendStatus,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });

class $$ChatsTableFilterComposer extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get conversationType => $composableBuilder(
    column: $table.conversationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sendUserId => $composableBuilder(
    column: $table.sendUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get msgType => $composableBuilder(
    column: $table.msgType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetMessageId => $composableBuilder(
    column: $table.targetMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get msgPreview => $composableBuilder(
    column: $table.msgPreview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get msg => $composableBuilder(
    column: $table.msg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sendStatus => $composableBuilder(
    column: $table.sendStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get conversationType => $composableBuilder(
    column: $table.conversationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sendUserId => $composableBuilder(
    column: $table.sendUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get msgType => $composableBuilder(
    column: $table.msgType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetMessageId => $composableBuilder(
    column: $table.targetMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get msgPreview => $composableBuilder(
    column: $table.msgPreview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get msg => $composableBuilder(
    column: $table.msg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sendStatus => $composableBuilder(
    column: $table.sendStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get conversationType => $composableBuilder(
    column: $table.conversationType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get sendUserId => $composableBuilder(
    column: $table.sendUserId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get msgType =>
      $composableBuilder(column: $table.msgType, builder: (column) => column);

  GeneratedColumn<String> get targetMessageId => $composableBuilder(
    column: $table.targetMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get msgPreview => $composableBuilder(
    column: $table.msgPreview,
    builder: (column) => column,
  );

  GeneratedColumn<String> get msg =>
      $composableBuilder(column: $table.msg, builder: (column) => column);

  GeneratedColumn<int> get sendStatus => $composableBuilder(
    column: $table.sendStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ChatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatsTable,
          Chat,
          $$ChatsTableFilterComposer,
          $$ChatsTableOrderingComposer,
          $$ChatsTableAnnotationComposer,
          $$ChatsTableCreateCompanionBuilder,
          $$ChatsTableUpdateCompanionBuilder,
          (Chat, BaseReferences<_$AppDatabase, $ChatsTable, Chat>),
          Chat,
          PrefetchHooks Function()
        > {
  $$ChatsTableTableManager(_$AppDatabase db, $ChatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> messageId = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<int> conversationType = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<String?> sendUserId = const Value.absent(),
                Value<int> msgType = const Value.absent(),
                Value<String?> targetMessageId = const Value.absent(),
                Value<String?> msgPreview = const Value.absent(),
                Value<String?> msg = const Value.absent(),
                Value<int> sendStatus = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => ChatsCompanion(
                id: id,
                messageId: messageId,
                conversationId: conversationId,
                conversationType: conversationType,
                seq: seq,
                sendUserId: sendUserId,
                msgType: msgType,
                targetMessageId: targetMessageId,
                msgPreview: msgPreview,
                msg: msg,
                sendStatus: sendStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String messageId,
                required String conversationId,
                required int conversationType,
                Value<int> seq = const Value.absent(),
                Value<String?> sendUserId = const Value.absent(),
                required int msgType,
                Value<String?> targetMessageId = const Value.absent(),
                Value<String?> msgPreview = const Value.absent(),
                Value<String?> msg = const Value.absent(),
                Value<int> sendStatus = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => ChatsCompanion.insert(
                id: id,
                messageId: messageId,
                conversationId: conversationId,
                conversationType: conversationType,
                seq: seq,
                sendUserId: sendUserId,
                msgType: msgType,
                targetMessageId: targetMessageId,
                msgPreview: msgPreview,
                msg: msg,
                sendStatus: sendStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatsTable,
      Chat,
      $$ChatsTableFilterComposer,
      $$ChatsTableOrderingComposer,
      $$ChatsTableAnnotationComposer,
      $$ChatsTableCreateCompanionBuilder,
      $$ChatsTableUpdateCompanionBuilder,
      (Chat, BaseReferences<_$AppDatabase, $ChatsTable, Chat>),
      Chat,
      PrefetchHooks Function()
    >;
typedef $$ChatConversationsTableCreateCompanionBuilder =
    ChatConversationsCompanion Function({
      Value<int> id,
      required String conversationId,
      required int type,
      Value<int> maxSeq,
      Value<String?> lastMessage,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });
typedef $$ChatConversationsTableUpdateCompanionBuilder =
    ChatConversationsCompanion Function({
      Value<int> id,
      Value<String> conversationId,
      Value<int> type,
      Value<int> maxSeq,
      Value<String?> lastMessage,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });

class $$ChatConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $ChatConversationsTable> {
  $$ChatConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxSeq => $composableBuilder(
    column: $table.maxSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastMessage => $composableBuilder(
    column: $table.lastMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatConversationsTable> {
  $$ChatConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxSeq => $composableBuilder(
    column: $table.maxSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastMessage => $composableBuilder(
    column: $table.lastMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatConversationsTable> {
  $$ChatConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get maxSeq =>
      $composableBuilder(column: $table.maxSeq, builder: (column) => column);

  GeneratedColumn<String> get lastMessage => $composableBuilder(
    column: $table.lastMessage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ChatConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatConversationsTable,
          ChatConversation,
          $$ChatConversationsTableFilterComposer,
          $$ChatConversationsTableOrderingComposer,
          $$ChatConversationsTableAnnotationComposer,
          $$ChatConversationsTableCreateCompanionBuilder,
          $$ChatConversationsTableUpdateCompanionBuilder,
          (
            ChatConversation,
            BaseReferences<
              _$AppDatabase,
              $ChatConversationsTable,
              ChatConversation
            >,
          ),
          ChatConversation,
          PrefetchHooks Function()
        > {
  $$ChatConversationsTableTableManager(
    _$AppDatabase db,
    $ChatConversationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatConversationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatConversationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<int> maxSeq = const Value.absent(),
                Value<String?> lastMessage = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => ChatConversationsCompanion(
                id: id,
                conversationId: conversationId,
                type: type,
                maxSeq: maxSeq,
                lastMessage: lastMessage,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String conversationId,
                required int type,
                Value<int> maxSeq = const Value.absent(),
                Value<String?> lastMessage = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => ChatConversationsCompanion.insert(
                id: id,
                conversationId: conversationId,
                type: type,
                maxSeq: maxSeq,
                lastMessage: lastMessage,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatConversationsTable,
      ChatConversation,
      $$ChatConversationsTableFilterComposer,
      $$ChatConversationsTableOrderingComposer,
      $$ChatConversationsTableAnnotationComposer,
      $$ChatConversationsTableCreateCompanionBuilder,
      $$ChatConversationsTableUpdateCompanionBuilder,
      (
        ChatConversation,
        BaseReferences<
          _$AppDatabase,
          $ChatConversationsTable,
          ChatConversation
        >,
      ),
      ChatConversation,
      PrefetchHooks Function()
    >;
typedef $$ChatUserConversationsTableCreateCompanionBuilder =
    ChatUserConversationsCompanion Function({
      Value<int> id,
      required String userId,
      required String conversationId,
      Value<int> isHidden,
      Value<int> isPinned,
      Value<int> isMuted,
      Value<int> userReadSeq,
      Value<int> version,
      Value<int?> updatedAt,
    });
typedef $$ChatUserConversationsTableUpdateCompanionBuilder =
    ChatUserConversationsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<String> conversationId,
      Value<int> isHidden,
      Value<int> isPinned,
      Value<int> isMuted,
      Value<int> userReadSeq,
      Value<int> version,
      Value<int?> updatedAt,
    });

class $$ChatUserConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $ChatUserConversationsTable> {
  $$ChatUserConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isHidden => $composableBuilder(
    column: $table.isHidden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isMuted => $composableBuilder(
    column: $table.isMuted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userReadSeq => $composableBuilder(
    column: $table.userReadSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatUserConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatUserConversationsTable> {
  $$ChatUserConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isHidden => $composableBuilder(
    column: $table.isHidden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isMuted => $composableBuilder(
    column: $table.isMuted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userReadSeq => $composableBuilder(
    column: $table.userReadSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatUserConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatUserConversationsTable> {
  $$ChatUserConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => column);

  GeneratedColumn<int> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<int> get isMuted =>
      $composableBuilder(column: $table.isMuted, builder: (column) => column);

  GeneratedColumn<int> get userReadSeq => $composableBuilder(
    column: $table.userReadSeq,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ChatUserConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatUserConversationsTable,
          ChatUserConversation,
          $$ChatUserConversationsTableFilterComposer,
          $$ChatUserConversationsTableOrderingComposer,
          $$ChatUserConversationsTableAnnotationComposer,
          $$ChatUserConversationsTableCreateCompanionBuilder,
          $$ChatUserConversationsTableUpdateCompanionBuilder,
          (
            ChatUserConversation,
            BaseReferences<
              _$AppDatabase,
              $ChatUserConversationsTable,
              ChatUserConversation
            >,
          ),
          ChatUserConversation,
          PrefetchHooks Function()
        > {
  $$ChatUserConversationsTableTableManager(
    _$AppDatabase db,
    $ChatUserConversationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatUserConversationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ChatUserConversationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ChatUserConversationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<int> isHidden = const Value.absent(),
                Value<int> isPinned = const Value.absent(),
                Value<int> isMuted = const Value.absent(),
                Value<int> userReadSeq = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => ChatUserConversationsCompanion(
                id: id,
                userId: userId,
                conversationId: conversationId,
                isHidden: isHidden,
                isPinned: isPinned,
                isMuted: isMuted,
                userReadSeq: userReadSeq,
                version: version,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required String conversationId,
                Value<int> isHidden = const Value.absent(),
                Value<int> isPinned = const Value.absent(),
                Value<int> isMuted = const Value.absent(),
                Value<int> userReadSeq = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => ChatUserConversationsCompanion.insert(
                id: id,
                userId: userId,
                conversationId: conversationId,
                isHidden: isHidden,
                isPinned: isPinned,
                isMuted: isMuted,
                userReadSeq: userReadSeq,
                version: version,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatUserConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatUserConversationsTable,
      ChatUserConversation,
      $$ChatUserConversationsTableFilterComposer,
      $$ChatUserConversationsTableOrderingComposer,
      $$ChatUserConversationsTableAnnotationComposer,
      $$ChatUserConversationsTableCreateCompanionBuilder,
      $$ChatUserConversationsTableUpdateCompanionBuilder,
      (
        ChatUserConversation,
        BaseReferences<
          _$AppDatabase,
          $ChatUserConversationsTable,
          ChatUserConversation
        >,
      ),
      ChatUserConversation,
      PrefetchHooks Function()
    >;
typedef $$ChatSyncStatusTableCreateCompanionBuilder =
    ChatSyncStatusCompanion Function({
      Value<int> id,
      required String conversationId,
      required String module,
      Value<int> seq,
      Value<int> version,
      Value<int?> updatedAt,
    });
typedef $$ChatSyncStatusTableUpdateCompanionBuilder =
    ChatSyncStatusCompanion Function({
      Value<int> id,
      Value<String> conversationId,
      Value<String> module,
      Value<int> seq,
      Value<int> version,
      Value<int?> updatedAt,
    });

class $$ChatSyncStatusTableFilterComposer
    extends Composer<_$AppDatabase, $ChatSyncStatusTable> {
  $$ChatSyncStatusTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatSyncStatusTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatSyncStatusTable> {
  $$ChatSyncStatusTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatSyncStatusTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatSyncStatusTable> {
  $$ChatSyncStatusTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get module =>
      $composableBuilder(column: $table.module, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ChatSyncStatusTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatSyncStatusTable,
          ChatSyncStatusData,
          $$ChatSyncStatusTableFilterComposer,
          $$ChatSyncStatusTableOrderingComposer,
          $$ChatSyncStatusTableAnnotationComposer,
          $$ChatSyncStatusTableCreateCompanionBuilder,
          $$ChatSyncStatusTableUpdateCompanionBuilder,
          (
            ChatSyncStatusData,
            BaseReferences<
              _$AppDatabase,
              $ChatSyncStatusTable,
              ChatSyncStatusData
            >,
          ),
          ChatSyncStatusData,
          PrefetchHooks Function()
        > {
  $$ChatSyncStatusTableTableManager(
    _$AppDatabase db,
    $ChatSyncStatusTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatSyncStatusTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatSyncStatusTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatSyncStatusTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> module = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => ChatSyncStatusCompanion(
                id: id,
                conversationId: conversationId,
                module: module,
                seq: seq,
                version: version,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String conversationId,
                required String module,
                Value<int> seq = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => ChatSyncStatusCompanion.insert(
                id: id,
                conversationId: conversationId,
                module: module,
                seq: seq,
                version: version,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatSyncStatusTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatSyncStatusTable,
      ChatSyncStatusData,
      $$ChatSyncStatusTableFilterComposer,
      $$ChatSyncStatusTableOrderingComposer,
      $$ChatSyncStatusTableAnnotationComposer,
      $$ChatSyncStatusTableCreateCompanionBuilder,
      $$ChatSyncStatusTableUpdateCompanionBuilder,
      (
        ChatSyncStatusData,
        BaseReferences<_$AppDatabase, $ChatSyncStatusTable, ChatSyncStatusData>,
      ),
      ChatSyncStatusData,
      PrefetchHooks Function()
    >;
typedef $$FriendsTableCreateCompanionBuilder =
    FriendsCompanion Function({
      Value<int> id,
      required String friendId,
      required String sendUserId,
      required String revUserId,
      Value<String?> sendUserNotice,
      Value<String?> revUserNotice,
      Value<String?> source,
      Value<int> isDeleted,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });
typedef $$FriendsTableUpdateCompanionBuilder =
    FriendsCompanion Function({
      Value<int> id,
      Value<String> friendId,
      Value<String> sendUserId,
      Value<String> revUserId,
      Value<String?> sendUserNotice,
      Value<String?> revUserNotice,
      Value<String?> source,
      Value<int> isDeleted,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });

class $$FriendsTableFilterComposer
    extends Composer<_$AppDatabase, $FriendsTable> {
  $$FriendsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get friendId => $composableBuilder(
    column: $table.friendId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sendUserId => $composableBuilder(
    column: $table.sendUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revUserId => $composableBuilder(
    column: $table.revUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sendUserNotice => $composableBuilder(
    column: $table.sendUserNotice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revUserNotice => $composableBuilder(
    column: $table.revUserNotice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FriendsTableOrderingComposer
    extends Composer<_$AppDatabase, $FriendsTable> {
  $$FriendsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get friendId => $composableBuilder(
    column: $table.friendId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sendUserId => $composableBuilder(
    column: $table.sendUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revUserId => $composableBuilder(
    column: $table.revUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sendUserNotice => $composableBuilder(
    column: $table.sendUserNotice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revUserNotice => $composableBuilder(
    column: $table.revUserNotice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FriendsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FriendsTable> {
  $$FriendsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get friendId =>
      $composableBuilder(column: $table.friendId, builder: (column) => column);

  GeneratedColumn<String> get sendUserId => $composableBuilder(
    column: $table.sendUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get revUserId =>
      $composableBuilder(column: $table.revUserId, builder: (column) => column);

  GeneratedColumn<String> get sendUserNotice => $composableBuilder(
    column: $table.sendUserNotice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get revUserNotice => $composableBuilder(
    column: $table.revUserNotice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FriendsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FriendsTable,
          Friend,
          $$FriendsTableFilterComposer,
          $$FriendsTableOrderingComposer,
          $$FriendsTableAnnotationComposer,
          $$FriendsTableCreateCompanionBuilder,
          $$FriendsTableUpdateCompanionBuilder,
          (Friend, BaseReferences<_$AppDatabase, $FriendsTable, Friend>),
          Friend,
          PrefetchHooks Function()
        > {
  $$FriendsTableTableManager(_$AppDatabase db, $FriendsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FriendsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FriendsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FriendsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> friendId = const Value.absent(),
                Value<String> sendUserId = const Value.absent(),
                Value<String> revUserId = const Value.absent(),
                Value<String?> sendUserNotice = const Value.absent(),
                Value<String?> revUserNotice = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => FriendsCompanion(
                id: id,
                friendId: friendId,
                sendUserId: sendUserId,
                revUserId: revUserId,
                sendUserNotice: sendUserNotice,
                revUserNotice: revUserNotice,
                source: source,
                isDeleted: isDeleted,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String friendId,
                required String sendUserId,
                required String revUserId,
                Value<String?> sendUserNotice = const Value.absent(),
                Value<String?> revUserNotice = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => FriendsCompanion.insert(
                id: id,
                friendId: friendId,
                sendUserId: sendUserId,
                revUserId: revUserId,
                sendUserNotice: sendUserNotice,
                revUserNotice: revUserNotice,
                source: source,
                isDeleted: isDeleted,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FriendsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FriendsTable,
      Friend,
      $$FriendsTableFilterComposer,
      $$FriendsTableOrderingComposer,
      $$FriendsTableAnnotationComposer,
      $$FriendsTableCreateCompanionBuilder,
      $$FriendsTableUpdateCompanionBuilder,
      (Friend, BaseReferences<_$AppDatabase, $FriendsTable, Friend>),
      Friend,
      PrefetchHooks Function()
    >;
typedef $$FriendVerifiesTableCreateCompanionBuilder =
    FriendVerifiesCompanion Function({
      Value<int> id,
      required String verifyId,
      required String sendUserId,
      required String revUserId,
      Value<int> sendStatus,
      Value<int> revStatus,
      Value<String?> message,
      Value<String?> source,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });
typedef $$FriendVerifiesTableUpdateCompanionBuilder =
    FriendVerifiesCompanion Function({
      Value<int> id,
      Value<String> verifyId,
      Value<String> sendUserId,
      Value<String> revUserId,
      Value<int> sendStatus,
      Value<int> revStatus,
      Value<String?> message,
      Value<String?> source,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });

class $$FriendVerifiesTableFilterComposer
    extends Composer<_$AppDatabase, $FriendVerifiesTable> {
  $$FriendVerifiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verifyId => $composableBuilder(
    column: $table.verifyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sendUserId => $composableBuilder(
    column: $table.sendUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revUserId => $composableBuilder(
    column: $table.revUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sendStatus => $composableBuilder(
    column: $table.sendStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revStatus => $composableBuilder(
    column: $table.revStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FriendVerifiesTableOrderingComposer
    extends Composer<_$AppDatabase, $FriendVerifiesTable> {
  $$FriendVerifiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verifyId => $composableBuilder(
    column: $table.verifyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sendUserId => $composableBuilder(
    column: $table.sendUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revUserId => $composableBuilder(
    column: $table.revUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sendStatus => $composableBuilder(
    column: $table.sendStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revStatus => $composableBuilder(
    column: $table.revStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FriendVerifiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FriendVerifiesTable> {
  $$FriendVerifiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get verifyId =>
      $composableBuilder(column: $table.verifyId, builder: (column) => column);

  GeneratedColumn<String> get sendUserId => $composableBuilder(
    column: $table.sendUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get revUserId =>
      $composableBuilder(column: $table.revUserId, builder: (column) => column);

  GeneratedColumn<int> get sendStatus => $composableBuilder(
    column: $table.sendStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revStatus =>
      $composableBuilder(column: $table.revStatus, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FriendVerifiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FriendVerifiesTable,
          FriendVerify,
          $$FriendVerifiesTableFilterComposer,
          $$FriendVerifiesTableOrderingComposer,
          $$FriendVerifiesTableAnnotationComposer,
          $$FriendVerifiesTableCreateCompanionBuilder,
          $$FriendVerifiesTableUpdateCompanionBuilder,
          (
            FriendVerify,
            BaseReferences<_$AppDatabase, $FriendVerifiesTable, FriendVerify>,
          ),
          FriendVerify,
          PrefetchHooks Function()
        > {
  $$FriendVerifiesTableTableManager(
    _$AppDatabase db,
    $FriendVerifiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FriendVerifiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FriendVerifiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FriendVerifiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> verifyId = const Value.absent(),
                Value<String> sendUserId = const Value.absent(),
                Value<String> revUserId = const Value.absent(),
                Value<int> sendStatus = const Value.absent(),
                Value<int> revStatus = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => FriendVerifiesCompanion(
                id: id,
                verifyId: verifyId,
                sendUserId: sendUserId,
                revUserId: revUserId,
                sendStatus: sendStatus,
                revStatus: revStatus,
                message: message,
                source: source,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String verifyId,
                required String sendUserId,
                required String revUserId,
                Value<int> sendStatus = const Value.absent(),
                Value<int> revStatus = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => FriendVerifiesCompanion.insert(
                id: id,
                verifyId: verifyId,
                sendUserId: sendUserId,
                revUserId: revUserId,
                sendStatus: sendStatus,
                revStatus: revStatus,
                message: message,
                source: source,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FriendVerifiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FriendVerifiesTable,
      FriendVerify,
      $$FriendVerifiesTableFilterComposer,
      $$FriendVerifiesTableOrderingComposer,
      $$FriendVerifiesTableAnnotationComposer,
      $$FriendVerifiesTableCreateCompanionBuilder,
      $$FriendVerifiesTableUpdateCompanionBuilder,
      (
        FriendVerify,
        BaseReferences<_$AppDatabase, $FriendVerifiesTable, FriendVerify>,
      ),
      FriendVerify,
      PrefetchHooks Function()
    >;
typedef $$GroupsTableCreateCompanionBuilder =
    GroupsCompanion Function({
      Value<int> id,
      required String groupId,
      Value<int> type,
      required String title,
      Value<String> avatar,
      required String creatorId,
      Value<String?> notice,
      Value<int> joinType,
      Value<int> status,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });
typedef $$GroupsTableUpdateCompanionBuilder =
    GroupsCompanion Function({
      Value<int> id,
      Value<String> groupId,
      Value<int> type,
      Value<String> title,
      Value<String> avatar,
      Value<String> creatorId,
      Value<String?> notice,
      Value<int> joinType,
      Value<int> status,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });

class $$GroupsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creatorId => $composableBuilder(
    column: $table.creatorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notice => $composableBuilder(
    column: $table.notice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get joinType => $composableBuilder(
    column: $table.joinType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creatorId => $composableBuilder(
    column: $table.creatorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notice => $composableBuilder(
    column: $table.notice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get joinType => $composableBuilder(
    column: $table.joinType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<String> get creatorId =>
      $composableBuilder(column: $table.creatorId, builder: (column) => column);

  GeneratedColumn<String> get notice =>
      $composableBuilder(column: $table.notice, builder: (column) => column);

  GeneratedColumn<int> get joinType =>
      $composableBuilder(column: $table.joinType, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupsTable,
          Group,
          $$GroupsTableFilterComposer,
          $$GroupsTableOrderingComposer,
          $$GroupsTableAnnotationComposer,
          $$GroupsTableCreateCompanionBuilder,
          $$GroupsTableUpdateCompanionBuilder,
          (Group, BaseReferences<_$AppDatabase, $GroupsTable, Group>),
          Group,
          PrefetchHooks Function()
        > {
  $$GroupsTableTableManager(_$AppDatabase db, $GroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> avatar = const Value.absent(),
                Value<String> creatorId = const Value.absent(),
                Value<String?> notice = const Value.absent(),
                Value<int> joinType = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => GroupsCompanion(
                id: id,
                groupId: groupId,
                type: type,
                title: title,
                avatar: avatar,
                creatorId: creatorId,
                notice: notice,
                joinType: joinType,
                status: status,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String groupId,
                Value<int> type = const Value.absent(),
                required String title,
                Value<String> avatar = const Value.absent(),
                required String creatorId,
                Value<String?> notice = const Value.absent(),
                Value<int> joinType = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => GroupsCompanion.insert(
                id: id,
                groupId: groupId,
                type: type,
                title: title,
                avatar: avatar,
                creatorId: creatorId,
                notice: notice,
                joinType: joinType,
                status: status,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupsTable,
      Group,
      $$GroupsTableFilterComposer,
      $$GroupsTableOrderingComposer,
      $$GroupsTableAnnotationComposer,
      $$GroupsTableCreateCompanionBuilder,
      $$GroupsTableUpdateCompanionBuilder,
      (Group, BaseReferences<_$AppDatabase, $GroupsTable, Group>),
      Group,
      PrefetchHooks Function()
    >;
typedef $$GroupMembersTableCreateCompanionBuilder =
    GroupMembersCompanion Function({
      Value<int> id,
      required String groupId,
      required String userId,
      Value<int> role,
      Value<int> status,
      Value<int?> joinTime,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });
typedef $$GroupMembersTableUpdateCompanionBuilder =
    GroupMembersCompanion Function({
      Value<int> id,
      Value<String> groupId,
      Value<String> userId,
      Value<int> role,
      Value<int> status,
      Value<int?> joinTime,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });

class $$GroupMembersTableFilterComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get joinTime => $composableBuilder(
    column: $table.joinTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GroupMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get joinTime => $composableBuilder(
    column: $table.joinTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get joinTime =>
      $composableBuilder(column: $table.joinTime, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GroupMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupMembersTable,
          GroupMember,
          $$GroupMembersTableFilterComposer,
          $$GroupMembersTableOrderingComposer,
          $$GroupMembersTableAnnotationComposer,
          $$GroupMembersTableCreateCompanionBuilder,
          $$GroupMembersTableUpdateCompanionBuilder,
          (
            GroupMember,
            BaseReferences<_$AppDatabase, $GroupMembersTable, GroupMember>,
          ),
          GroupMember,
          PrefetchHooks Function()
        > {
  $$GroupMembersTableTableManager(_$AppDatabase db, $GroupMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> role = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int?> joinTime = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => GroupMembersCompanion(
                id: id,
                groupId: groupId,
                userId: userId,
                role: role,
                status: status,
                joinTime: joinTime,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String groupId,
                required String userId,
                Value<int> role = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int?> joinTime = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => GroupMembersCompanion.insert(
                id: id,
                groupId: groupId,
                userId: userId,
                role: role,
                status: status,
                joinTime: joinTime,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GroupMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupMembersTable,
      GroupMember,
      $$GroupMembersTableFilterComposer,
      $$GroupMembersTableOrderingComposer,
      $$GroupMembersTableAnnotationComposer,
      $$GroupMembersTableCreateCompanionBuilder,
      $$GroupMembersTableUpdateCompanionBuilder,
      (
        GroupMember,
        BaseReferences<_$AppDatabase, $GroupMembersTable, GroupMember>,
      ),
      GroupMember,
      PrefetchHooks Function()
    >;
typedef $$GroupJoinRequestsTableCreateCompanionBuilder =
    GroupJoinRequestsCompanion Function({
      Value<int> id,
      required String groupId,
      required String applicantUserId,
      Value<String?> message,
      Value<int> status,
      Value<String?> handledBy,
      Value<int?> handledAt,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });
typedef $$GroupJoinRequestsTableUpdateCompanionBuilder =
    GroupJoinRequestsCompanion Function({
      Value<int> id,
      Value<String> groupId,
      Value<String> applicantUserId,
      Value<String?> message,
      Value<int> status,
      Value<String?> handledBy,
      Value<int?> handledAt,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });

class $$GroupJoinRequestsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupJoinRequestsTable> {
  $$GroupJoinRequestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get applicantUserId => $composableBuilder(
    column: $table.applicantUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get handledBy => $composableBuilder(
    column: $table.handledBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get handledAt => $composableBuilder(
    column: $table.handledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GroupJoinRequestsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupJoinRequestsTable> {
  $$GroupJoinRequestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get applicantUserId => $composableBuilder(
    column: $table.applicantUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get handledBy => $composableBuilder(
    column: $table.handledBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get handledAt => $composableBuilder(
    column: $table.handledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupJoinRequestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupJoinRequestsTable> {
  $$GroupJoinRequestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get applicantUserId => $composableBuilder(
    column: $table.applicantUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get handledBy =>
      $composableBuilder(column: $table.handledBy, builder: (column) => column);

  GeneratedColumn<int> get handledAt =>
      $composableBuilder(column: $table.handledAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GroupJoinRequestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupJoinRequestsTable,
          GroupJoinRequest,
          $$GroupJoinRequestsTableFilterComposer,
          $$GroupJoinRequestsTableOrderingComposer,
          $$GroupJoinRequestsTableAnnotationComposer,
          $$GroupJoinRequestsTableCreateCompanionBuilder,
          $$GroupJoinRequestsTableUpdateCompanionBuilder,
          (
            GroupJoinRequest,
            BaseReferences<
              _$AppDatabase,
              $GroupJoinRequestsTable,
              GroupJoinRequest
            >,
          ),
          GroupJoinRequest,
          PrefetchHooks Function()
        > {
  $$GroupJoinRequestsTableTableManager(
    _$AppDatabase db,
    $GroupJoinRequestsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupJoinRequestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupJoinRequestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupJoinRequestsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> applicantUserId = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> handledBy = const Value.absent(),
                Value<int?> handledAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => GroupJoinRequestsCompanion(
                id: id,
                groupId: groupId,
                applicantUserId: applicantUserId,
                message: message,
                status: status,
                handledBy: handledBy,
                handledAt: handledAt,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String groupId,
                required String applicantUserId,
                Value<String?> message = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> handledBy = const Value.absent(),
                Value<int?> handledAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => GroupJoinRequestsCompanion.insert(
                id: id,
                groupId: groupId,
                applicantUserId: applicantUserId,
                message: message,
                status: status,
                handledBy: handledBy,
                handledAt: handledAt,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GroupJoinRequestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupJoinRequestsTable,
      GroupJoinRequest,
      $$GroupJoinRequestsTableFilterComposer,
      $$GroupJoinRequestsTableOrderingComposer,
      $$GroupJoinRequestsTableAnnotationComposer,
      $$GroupJoinRequestsTableCreateCompanionBuilder,
      $$GroupJoinRequestsTableUpdateCompanionBuilder,
      (
        GroupJoinRequest,
        BaseReferences<
          _$AppDatabase,
          $GroupJoinRequestsTable,
          GroupJoinRequest
        >,
      ),
      GroupJoinRequest,
      PrefetchHooks Function()
    >;
typedef $$GroupSyncStatusTableCreateCompanionBuilder =
    GroupSyncStatusCompanion Function({
      Value<int> id,
      required String groupId,
      required String module,
      Value<int> version,
      Value<int?> updatedAt,
    });
typedef $$GroupSyncStatusTableUpdateCompanionBuilder =
    GroupSyncStatusCompanion Function({
      Value<int> id,
      Value<String> groupId,
      Value<String> module,
      Value<int> version,
      Value<int?> updatedAt,
    });

class $$GroupSyncStatusTableFilterComposer
    extends Composer<_$AppDatabase, $GroupSyncStatusTable> {
  $$GroupSyncStatusTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GroupSyncStatusTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupSyncStatusTable> {
  $$GroupSyncStatusTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupSyncStatusTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupSyncStatusTable> {
  $$GroupSyncStatusTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get module =>
      $composableBuilder(column: $table.module, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GroupSyncStatusTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupSyncStatusTable,
          GroupSyncStatusData,
          $$GroupSyncStatusTableFilterComposer,
          $$GroupSyncStatusTableOrderingComposer,
          $$GroupSyncStatusTableAnnotationComposer,
          $$GroupSyncStatusTableCreateCompanionBuilder,
          $$GroupSyncStatusTableUpdateCompanionBuilder,
          (
            GroupSyncStatusData,
            BaseReferences<
              _$AppDatabase,
              $GroupSyncStatusTable,
              GroupSyncStatusData
            >,
          ),
          GroupSyncStatusData,
          PrefetchHooks Function()
        > {
  $$GroupSyncStatusTableTableManager(
    _$AppDatabase db,
    $GroupSyncStatusTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupSyncStatusTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupSyncStatusTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupSyncStatusTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> module = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => GroupSyncStatusCompanion(
                id: id,
                groupId: groupId,
                module: module,
                version: version,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String groupId,
                required String module,
                Value<int> version = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => GroupSyncStatusCompanion.insert(
                id: id,
                groupId: groupId,
                module: module,
                version: version,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GroupSyncStatusTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupSyncStatusTable,
      GroupSyncStatusData,
      $$GroupSyncStatusTableFilterComposer,
      $$GroupSyncStatusTableOrderingComposer,
      $$GroupSyncStatusTableAnnotationComposer,
      $$GroupSyncStatusTableCreateCompanionBuilder,
      $$GroupSyncStatusTableUpdateCompanionBuilder,
      (
        GroupSyncStatusData,
        BaseReferences<
          _$AppDatabase,
          $GroupSyncStatusTable,
          GroupSyncStatusData
        >,
      ),
      GroupSyncStatusData,
      PrefetchHooks Function()
    >;
typedef $$DatasyncTableCreateCompanionBuilder =
    DatasyncCompanion Function({
      Value<int> id,
      required String module,
      Value<int?> version,
      required int updatedAt,
    });
typedef $$DatasyncTableUpdateCompanionBuilder =
    DatasyncCompanion Function({
      Value<int> id,
      Value<String> module,
      Value<int?> version,
      Value<int> updatedAt,
    });

class $$DatasyncTableFilterComposer
    extends Composer<_$AppDatabase, $DatasyncTable> {
  $$DatasyncTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DatasyncTableOrderingComposer
    extends Composer<_$AppDatabase, $DatasyncTable> {
  $$DatasyncTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DatasyncTableAnnotationComposer
    extends Composer<_$AppDatabase, $DatasyncTable> {
  $$DatasyncTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get module =>
      $composableBuilder(column: $table.module, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DatasyncTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DatasyncTable,
          DatasyncData,
          $$DatasyncTableFilterComposer,
          $$DatasyncTableOrderingComposer,
          $$DatasyncTableAnnotationComposer,
          $$DatasyncTableCreateCompanionBuilder,
          $$DatasyncTableUpdateCompanionBuilder,
          (
            DatasyncData,
            BaseReferences<_$AppDatabase, $DatasyncTable, DatasyncData>,
          ),
          DatasyncData,
          PrefetchHooks Function()
        > {
  $$DatasyncTableTableManager(_$AppDatabase db, $DatasyncTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DatasyncTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DatasyncTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DatasyncTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> module = const Value.absent(),
                Value<int?> version = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => DatasyncCompanion(
                id: id,
                module: module,
                version: version,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String module,
                Value<int?> version = const Value.absent(),
                required int updatedAt,
              }) => DatasyncCompanion.insert(
                id: id,
                module: module,
                version: version,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DatasyncTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DatasyncTable,
      DatasyncData,
      $$DatasyncTableFilterComposer,
      $$DatasyncTableOrderingComposer,
      $$DatasyncTableAnnotationComposer,
      $$DatasyncTableCreateCompanionBuilder,
      $$DatasyncTableUpdateCompanionBuilder,
      (
        DatasyncData,
        BaseReferences<_$AppDatabase, $DatasyncTable, DatasyncData>,
      ),
      DatasyncData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$UserSyncStatusTableTableManager get userSyncStatus =>
      $$UserSyncStatusTableTableManager(_db, _db.userSyncStatus);
  $$ChatsTableTableManager get chats =>
      $$ChatsTableTableManager(_db, _db.chats);
  $$ChatConversationsTableTableManager get chatConversations =>
      $$ChatConversationsTableTableManager(_db, _db.chatConversations);
  $$ChatUserConversationsTableTableManager get chatUserConversations =>
      $$ChatUserConversationsTableTableManager(_db, _db.chatUserConversations);
  $$ChatSyncStatusTableTableManager get chatSyncStatus =>
      $$ChatSyncStatusTableTableManager(_db, _db.chatSyncStatus);
  $$FriendsTableTableManager get friends =>
      $$FriendsTableTableManager(_db, _db.friends);
  $$FriendVerifiesTableTableManager get friendVerifies =>
      $$FriendVerifiesTableTableManager(_db, _db.friendVerifies);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db, _db.groups);
  $$GroupMembersTableTableManager get groupMembers =>
      $$GroupMembersTableTableManager(_db, _db.groupMembers);
  $$GroupJoinRequestsTableTableManager get groupJoinRequests =>
      $$GroupJoinRequestsTableTableManager(_db, _db.groupJoinRequests);
  $$GroupSyncStatusTableTableManager get groupSyncStatus =>
      $$GroupSyncStatusTableTableManager(_db, _db.groupSyncStatus);
  $$DatasyncTableTableManager get datasync =>
      $$DatasyncTableTableManager(_db, _db.datasync);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
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
    title,
    avatar,
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
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
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
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      ),
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
  final String? title;
  final String? avatar;
  final int maxSeq;
  final String? lastMessage;
  final int version;
  final int? createdAt;
  final int? updatedAt;
  const ChatConversation({
    required this.id,
    required this.conversationId,
    required this.type,
    this.title,
    this.avatar,
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
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
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
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      avatar: avatar == null && nullToAbsent
          ? const Value.absent()
          : Value(avatar),
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
      title: serializer.fromJson<String?>(json['title']),
      avatar: serializer.fromJson<String?>(json['avatar']),
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
      'title': serializer.toJson<String?>(title),
      'avatar': serializer.toJson<String?>(avatar),
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
    Value<String?> title = const Value.absent(),
    Value<String?> avatar = const Value.absent(),
    int? maxSeq,
    Value<String?> lastMessage = const Value.absent(),
    int? version,
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => ChatConversation(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    type: type ?? this.type,
    title: title.present ? title.value : this.title,
    avatar: avatar.present ? avatar.value : this.avatar,
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
      title: data.title.present ? data.title.value : this.title,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
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
          ..write('title: $title, ')
          ..write('avatar: $avatar, ')
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
    title,
    avatar,
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
          other.title == this.title &&
          other.avatar == this.avatar &&
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
  final Value<String?> title;
  final Value<String?> avatar;
  final Value<int> maxSeq;
  final Value<String?> lastMessage;
  final Value<int> version;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  const ChatConversationsCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.avatar = const Value.absent(),
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
    this.title = const Value.absent(),
    this.avatar = const Value.absent(),
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
    Expression<String>? title,
    Expression<String>? avatar,
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
      if (title != null) 'title': title,
      if (avatar != null) 'avatar': avatar,
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
    Value<String?>? title,
    Value<String?>? avatar,
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
      title: title ?? this.title,
      avatar: avatar ?? this.avatar,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
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
          ..write('title: $title, ')
          ..write('avatar: $avatar, ')
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
    conversationId,
    isHidden,
    isPinned,
    isMuted,
    userReadSeq,
    version,
    createdAt,
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
  final int? createdAt;
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
    this.createdAt,
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
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
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
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
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
      'conversationId': serializer.toJson<String>(conversationId),
      'isHidden': serializer.toJson<int>(isHidden),
      'isPinned': serializer.toJson<int>(isPinned),
      'isMuted': serializer.toJson<int>(isMuted),
      'userReadSeq': serializer.toJson<int>(userReadSeq),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<int?>(createdAt),
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
    Value<int?> createdAt = const Value.absent(),
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
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
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
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
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
          ..write('createdAt: $createdAt, ')
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
    createdAt,
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
          other.createdAt == this.createdAt &&
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
  final Value<int?> createdAt;
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
    this.createdAt = const Value.absent(),
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
    this.createdAt = const Value.absent(),
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
    Expression<int>? createdAt,
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
      if (createdAt != null) 'created_at': createdAt,
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
    Value<int?>? createdAt,
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
    return (StringBuffer('ChatUserConversationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('conversationId: $conversationId, ')
          ..write('isHidden: $isHidden, ')
          ..write('isPinned: $isPinned, ')
          ..write('isMuted: $isMuted, ')
          ..write('userReadSeq: $userReadSeq, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
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
  Set<GeneratedColumn> get $primaryKey => {conversationId, module};
  @override
  ChatSyncStatusData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatSyncStatusData(
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
  final String conversationId;
  final String module;
  final int seq;
  final int version;
  final int? updatedAt;
  const ChatSyncStatusData({
    required this.conversationId,
    required this.module,
    required this.seq,
    required this.version,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
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
      'conversationId': serializer.toJson<String>(conversationId),
      'module': serializer.toJson<String>(module),
      'seq': serializer.toJson<int>(seq),
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  ChatSyncStatusData copyWith({
    String? conversationId,
    String? module,
    int? seq,
    int? version,
    Value<int?> updatedAt = const Value.absent(),
  }) => ChatSyncStatusData(
    conversationId: conversationId ?? this.conversationId,
    module: module ?? this.module,
    seq: seq ?? this.seq,
    version: version ?? this.version,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ChatSyncStatusData copyWithCompanion(ChatSyncStatusCompanion data) {
    return ChatSyncStatusData(
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
      Object.hash(conversationId, module, seq, version, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatSyncStatusData &&
          other.conversationId == this.conversationId &&
          other.module == this.module &&
          other.seq == this.seq &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt);
}

class ChatSyncStatusCompanion extends UpdateCompanion<ChatSyncStatusData> {
  final Value<String> conversationId;
  final Value<String> module;
  final Value<int> seq;
  final Value<int> version;
  final Value<int?> updatedAt;
  final Value<int> rowid;
  const ChatSyncStatusCompanion({
    this.conversationId = const Value.absent(),
    this.module = const Value.absent(),
    this.seq = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatSyncStatusCompanion.insert({
    required String conversationId,
    required String module,
    this.seq = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : conversationId = Value(conversationId),
       module = Value(module);
  static Insertable<ChatSyncStatusData> custom({
    Expression<String>? conversationId,
    Expression<String>? module,
    Expression<int>? seq,
    Expression<int>? version,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (conversationId != null) 'conversation_id': conversationId,
      if (module != null) 'module': module,
      if (seq != null) 'seq': seq,
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatSyncStatusCompanion copyWith({
    Value<String>? conversationId,
    Value<String>? module,
    Value<int>? seq,
    Value<int>? version,
    Value<int?>? updatedAt,
    Value<int>? rowid,
  }) {
    return ChatSyncStatusCompanion(
      conversationId: conversationId ?? this.conversationId,
      module: module ?? this.module,
      seq: seq ?? this.seq,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatSyncStatusCompanion(')
          ..write('conversationId: $conversationId, ')
          ..write('module: $module, ')
          ..write('seq: $seq, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
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
  static const VerificationMeta _nickNameMeta = const VerificationMeta(
    'nickName',
  );
  @override
  late final GeneratedColumn<String> nickName = GeneratedColumn<String>(
    'nick_name',
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
    nickName,
    avatar,
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
    if (data.containsKey('nick_name')) {
      context.handle(
        _nickNameMeta,
        nickName.isAcceptableOrUnknown(data['nick_name']!, _nickNameMeta),
      );
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
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
      nickName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nick_name'],
      ),
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      ),
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
  final String? nickName;
  final String? avatar;
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
    this.nickName,
    this.avatar,
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
    if (!nullToAbsent || nickName != null) {
      map['nick_name'] = Variable<String>(nickName);
    }
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
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
      nickName: nickName == null && nullToAbsent
          ? const Value.absent()
          : Value(nickName),
      avatar: avatar == null && nullToAbsent
          ? const Value.absent()
          : Value(avatar),
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
      nickName: serializer.fromJson<String?>(json['nickName']),
      avatar: serializer.fromJson<String?>(json['avatar']),
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
      'nickName': serializer.toJson<String?>(nickName),
      'avatar': serializer.toJson<String?>(avatar),
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
    Value<String?> nickName = const Value.absent(),
    Value<String?> avatar = const Value.absent(),
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
    nickName: nickName.present ? nickName.value : this.nickName,
    avatar: avatar.present ? avatar.value : this.avatar,
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
      nickName: data.nickName.present ? data.nickName.value : this.nickName,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
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
          ..write('nickName: $nickName, ')
          ..write('avatar: $avatar, ')
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
    nickName,
    avatar,
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
          other.nickName == this.nickName &&
          other.avatar == this.avatar &&
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
  final Value<String?> nickName;
  final Value<String?> avatar;
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
    this.nickName = const Value.absent(),
    this.avatar = const Value.absent(),
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
    this.nickName = const Value.absent(),
    this.avatar = const Value.absent(),
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
    Expression<String>? nickName,
    Expression<String>? avatar,
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
      if (nickName != null) 'nick_name': nickName,
      if (avatar != null) 'avatar': avatar,
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
    Value<String?>? nickName,
    Value<String?>? avatar,
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
      nickName: nickName ?? this.nickName,
      avatar: avatar ?? this.avatar,
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
    if (nickName.present) {
      map['nick_name'] = Variable<String>(nickName.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
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
          ..write('nickName: $nickName, ')
          ..write('avatar: $avatar, ')
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

class $EmojisTable extends Emojis with TableInfo<$EmojisTable, Emoji> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmojisTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _emojiIdMeta = const VerificationMeta(
    'emojiId',
  );
  @override
  late final GeneratedColumn<String> emojiId = GeneratedColumn<String>(
    'emoji_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileKeyMeta = const VerificationMeta(
    'fileKey',
  );
  @override
  late final GeneratedColumn<String> fileKey = GeneratedColumn<String>(
    'file_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _emojiInfoMeta = const VerificationMeta(
    'emojiInfo',
  );
  @override
  late final GeneratedColumn<String> emojiInfo = GeneratedColumn<String>(
    'emoji_info',
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
    emojiId,
    fileKey,
    title,
    emojiInfo,
    status,
    version,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emojis';
  @override
  VerificationContext validateIntegrity(
    Insertable<Emoji> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('emoji_id')) {
      context.handle(
        _emojiIdMeta,
        emojiId.isAcceptableOrUnknown(data['emoji_id']!, _emojiIdMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiIdMeta);
    }
    if (data.containsKey('file_key')) {
      context.handle(
        _fileKeyMeta,
        fileKey.isAcceptableOrUnknown(data['file_key']!, _fileKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_fileKeyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('emoji_info')) {
      context.handle(
        _emojiInfoMeta,
        emojiInfo.isAcceptableOrUnknown(data['emoji_info']!, _emojiInfoMeta),
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
  Emoji map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Emoji(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      emojiId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji_id'],
      )!,
      fileKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_key'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      emojiInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji_info'],
      ),
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
  $EmojisTable createAlias(String alias) {
    return $EmojisTable(attachedDatabase, alias);
  }
}

class Emoji extends DataClass implements Insertable<Emoji> {
  final int id;
  final String emojiId;
  final String fileKey;
  final String title;
  final String? emojiInfo;
  final int status;
  final int version;
  final int? createdAt;
  final int? updatedAt;
  const Emoji({
    required this.id,
    required this.emojiId,
    required this.fileKey,
    required this.title,
    this.emojiInfo,
    required this.status,
    required this.version,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['emoji_id'] = Variable<String>(emojiId);
    map['file_key'] = Variable<String>(fileKey);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || emojiInfo != null) {
      map['emoji_info'] = Variable<String>(emojiInfo);
    }
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

  EmojisCompanion toCompanion(bool nullToAbsent) {
    return EmojisCompanion(
      id: Value(id),
      emojiId: Value(emojiId),
      fileKey: Value(fileKey),
      title: Value(title),
      emojiInfo: emojiInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(emojiInfo),
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

  factory Emoji.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Emoji(
      id: serializer.fromJson<int>(json['id']),
      emojiId: serializer.fromJson<String>(json['emojiId']),
      fileKey: serializer.fromJson<String>(json['fileKey']),
      title: serializer.fromJson<String>(json['title']),
      emojiInfo: serializer.fromJson<String?>(json['emojiInfo']),
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
      'emojiId': serializer.toJson<String>(emojiId),
      'fileKey': serializer.toJson<String>(fileKey),
      'title': serializer.toJson<String>(title),
      'emojiInfo': serializer.toJson<String?>(emojiInfo),
      'status': serializer.toJson<int>(status),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  Emoji copyWith({
    int? id,
    String? emojiId,
    String? fileKey,
    String? title,
    Value<String?> emojiInfo = const Value.absent(),
    int? status,
    int? version,
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => Emoji(
    id: id ?? this.id,
    emojiId: emojiId ?? this.emojiId,
    fileKey: fileKey ?? this.fileKey,
    title: title ?? this.title,
    emojiInfo: emojiInfo.present ? emojiInfo.value : this.emojiInfo,
    status: status ?? this.status,
    version: version ?? this.version,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Emoji copyWithCompanion(EmojisCompanion data) {
    return Emoji(
      id: data.id.present ? data.id.value : this.id,
      emojiId: data.emojiId.present ? data.emojiId.value : this.emojiId,
      fileKey: data.fileKey.present ? data.fileKey.value : this.fileKey,
      title: data.title.present ? data.title.value : this.title,
      emojiInfo: data.emojiInfo.present ? data.emojiInfo.value : this.emojiInfo,
      status: data.status.present ? data.status.value : this.status,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Emoji(')
          ..write('id: $id, ')
          ..write('emojiId: $emojiId, ')
          ..write('fileKey: $fileKey, ')
          ..write('title: $title, ')
          ..write('emojiInfo: $emojiInfo, ')
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
    emojiId,
    fileKey,
    title,
    emojiInfo,
    status,
    version,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Emoji &&
          other.id == this.id &&
          other.emojiId == this.emojiId &&
          other.fileKey == this.fileKey &&
          other.title == this.title &&
          other.emojiInfo == this.emojiInfo &&
          other.status == this.status &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmojisCompanion extends UpdateCompanion<Emoji> {
  final Value<int> id;
  final Value<String> emojiId;
  final Value<String> fileKey;
  final Value<String> title;
  final Value<String?> emojiInfo;
  final Value<int> status;
  final Value<int> version;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  const EmojisCompanion({
    this.id = const Value.absent(),
    this.emojiId = const Value.absent(),
    this.fileKey = const Value.absent(),
    this.title = const Value.absent(),
    this.emojiInfo = const Value.absent(),
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EmojisCompanion.insert({
    this.id = const Value.absent(),
    required String emojiId,
    required String fileKey,
    required String title,
    this.emojiInfo = const Value.absent(),
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : emojiId = Value(emojiId),
       fileKey = Value(fileKey),
       title = Value(title);
  static Insertable<Emoji> custom({
    Expression<int>? id,
    Expression<String>? emojiId,
    Expression<String>? fileKey,
    Expression<String>? title,
    Expression<String>? emojiInfo,
    Expression<int>? status,
    Expression<int>? version,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (emojiId != null) 'emoji_id': emojiId,
      if (fileKey != null) 'file_key': fileKey,
      if (title != null) 'title': title,
      if (emojiInfo != null) 'emoji_info': emojiInfo,
      if (status != null) 'status': status,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EmojisCompanion copyWith({
    Value<int>? id,
    Value<String>? emojiId,
    Value<String>? fileKey,
    Value<String>? title,
    Value<String?>? emojiInfo,
    Value<int>? status,
    Value<int>? version,
    Value<int?>? createdAt,
    Value<int?>? updatedAt,
  }) {
    return EmojisCompanion(
      id: id ?? this.id,
      emojiId: emojiId ?? this.emojiId,
      fileKey: fileKey ?? this.fileKey,
      title: title ?? this.title,
      emojiInfo: emojiInfo ?? this.emojiInfo,
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
    if (emojiId.present) {
      map['emoji_id'] = Variable<String>(emojiId.value);
    }
    if (fileKey.present) {
      map['file_key'] = Variable<String>(fileKey.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (emojiInfo.present) {
      map['emoji_info'] = Variable<String>(emojiInfo.value);
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
    return (StringBuffer('EmojisCompanion(')
          ..write('id: $id, ')
          ..write('emojiId: $emojiId, ')
          ..write('fileKey: $fileKey, ')
          ..write('title: $title, ')
          ..write('emojiInfo: $emojiInfo, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $EmojiCollectTableTable extends EmojiCollectTable
    with TableInfo<$EmojiCollectTableTable, EmojiCollectTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmojiCollectTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _emojiCollectIdMeta = const VerificationMeta(
    'emojiCollectId',
  );
  @override
  late final GeneratedColumn<String> emojiCollectId = GeneratedColumn<String>(
    'emoji_collect_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _emojiIdMeta = const VerificationMeta(
    'emojiId',
  );
  @override
  late final GeneratedColumn<String> emojiId = GeneratedColumn<String>(
    'emoji_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packageIdMeta = const VerificationMeta(
    'packageId',
  );
  @override
  late final GeneratedColumn<String> packageId = GeneratedColumn<String>(
    'package_id',
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
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    emojiCollectId,
    userId,
    emojiId,
    packageId,
    isDeleted,
    version,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emoji_collect_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmojiCollectTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('emoji_collect_id')) {
      context.handle(
        _emojiCollectIdMeta,
        emojiCollectId.isAcceptableOrUnknown(
          data['emoji_collect_id']!,
          _emojiCollectIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_emojiCollectIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('emoji_id')) {
      context.handle(
        _emojiIdMeta,
        emojiId.isAcceptableOrUnknown(data['emoji_id']!, _emojiIdMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiIdMeta);
    }
    if (data.containsKey('package_id')) {
      context.handle(
        _packageIdMeta,
        packageId.isAcceptableOrUnknown(data['package_id']!, _packageIdMeta),
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
  EmojiCollectTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmojiCollectTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      emojiCollectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji_collect_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      emojiId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji_id'],
      )!,
      packageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_id'],
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
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EmojiCollectTableTable createAlias(String alias) {
    return $EmojiCollectTableTable(attachedDatabase, alias);
  }
}

class EmojiCollectTableData extends DataClass
    implements Insertable<EmojiCollectTableData> {
  final int id;
  final String emojiCollectId;
  final String userId;
  final String emojiId;
  final String? packageId;
  final int isDeleted;
  final int version;
  final int createdAt;
  final int updatedAt;
  const EmojiCollectTableData({
    required this.id,
    required this.emojiCollectId,
    required this.userId,
    required this.emojiId,
    this.packageId,
    required this.isDeleted,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['emoji_collect_id'] = Variable<String>(emojiCollectId);
    map['user_id'] = Variable<String>(userId);
    map['emoji_id'] = Variable<String>(emojiId);
    if (!nullToAbsent || packageId != null) {
      map['package_id'] = Variable<String>(packageId);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  EmojiCollectTableCompanion toCompanion(bool nullToAbsent) {
    return EmojiCollectTableCompanion(
      id: Value(id),
      emojiCollectId: Value(emojiCollectId),
      userId: Value(userId),
      emojiId: Value(emojiId),
      packageId: packageId == null && nullToAbsent
          ? const Value.absent()
          : Value(packageId),
      isDeleted: Value(isDeleted),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EmojiCollectTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmojiCollectTableData(
      id: serializer.fromJson<int>(json['id']),
      emojiCollectId: serializer.fromJson<String>(json['emojiCollectId']),
      userId: serializer.fromJson<String>(json['userId']),
      emojiId: serializer.fromJson<String>(json['emojiId']),
      packageId: serializer.fromJson<String?>(json['packageId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'emojiCollectId': serializer.toJson<String>(emojiCollectId),
      'userId': serializer.toJson<String>(userId),
      'emojiId': serializer.toJson<String>(emojiId),
      'packageId': serializer.toJson<String?>(packageId),
      'isDeleted': serializer.toJson<int>(isDeleted),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  EmojiCollectTableData copyWith({
    int? id,
    String? emojiCollectId,
    String? userId,
    String? emojiId,
    Value<String?> packageId = const Value.absent(),
    int? isDeleted,
    int? version,
    int? createdAt,
    int? updatedAt,
  }) => EmojiCollectTableData(
    id: id ?? this.id,
    emojiCollectId: emojiCollectId ?? this.emojiCollectId,
    userId: userId ?? this.userId,
    emojiId: emojiId ?? this.emojiId,
    packageId: packageId.present ? packageId.value : this.packageId,
    isDeleted: isDeleted ?? this.isDeleted,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EmojiCollectTableData copyWithCompanion(EmojiCollectTableCompanion data) {
    return EmojiCollectTableData(
      id: data.id.present ? data.id.value : this.id,
      emojiCollectId: data.emojiCollectId.present
          ? data.emojiCollectId.value
          : this.emojiCollectId,
      userId: data.userId.present ? data.userId.value : this.userId,
      emojiId: data.emojiId.present ? data.emojiId.value : this.emojiId,
      packageId: data.packageId.present ? data.packageId.value : this.packageId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmojiCollectTableData(')
          ..write('id: $id, ')
          ..write('emojiCollectId: $emojiCollectId, ')
          ..write('userId: $userId, ')
          ..write('emojiId: $emojiId, ')
          ..write('packageId: $packageId, ')
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
    emojiCollectId,
    userId,
    emojiId,
    packageId,
    isDeleted,
    version,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmojiCollectTableData &&
          other.id == this.id &&
          other.emojiCollectId == this.emojiCollectId &&
          other.userId == this.userId &&
          other.emojiId == this.emojiId &&
          other.packageId == this.packageId &&
          other.isDeleted == this.isDeleted &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmojiCollectTableCompanion
    extends UpdateCompanion<EmojiCollectTableData> {
  final Value<int> id;
  final Value<String> emojiCollectId;
  final Value<String> userId;
  final Value<String> emojiId;
  final Value<String?> packageId;
  final Value<int> isDeleted;
  final Value<int> version;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const EmojiCollectTableCompanion({
    this.id = const Value.absent(),
    this.emojiCollectId = const Value.absent(),
    this.userId = const Value.absent(),
    this.emojiId = const Value.absent(),
    this.packageId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EmojiCollectTableCompanion.insert({
    this.id = const Value.absent(),
    required String emojiCollectId,
    required String userId,
    required String emojiId,
    this.packageId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : emojiCollectId = Value(emojiCollectId),
       userId = Value(userId),
       emojiId = Value(emojiId);
  static Insertable<EmojiCollectTableData> custom({
    Expression<int>? id,
    Expression<String>? emojiCollectId,
    Expression<String>? userId,
    Expression<String>? emojiId,
    Expression<String>? packageId,
    Expression<int>? isDeleted,
    Expression<int>? version,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (emojiCollectId != null) 'emoji_collect_id': emojiCollectId,
      if (userId != null) 'user_id': userId,
      if (emojiId != null) 'emoji_id': emojiId,
      if (packageId != null) 'package_id': packageId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EmojiCollectTableCompanion copyWith({
    Value<int>? id,
    Value<String>? emojiCollectId,
    Value<String>? userId,
    Value<String>? emojiId,
    Value<String?>? packageId,
    Value<int>? isDeleted,
    Value<int>? version,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return EmojiCollectTableCompanion(
      id: id ?? this.id,
      emojiCollectId: emojiCollectId ?? this.emojiCollectId,
      userId: userId ?? this.userId,
      emojiId: emojiId ?? this.emojiId,
      packageId: packageId ?? this.packageId,
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
    if (emojiCollectId.present) {
      map['emoji_collect_id'] = Variable<String>(emojiCollectId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (emojiId.present) {
      map['emoji_id'] = Variable<String>(emojiId.value);
    }
    if (packageId.present) {
      map['package_id'] = Variable<String>(packageId.value);
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
    return (StringBuffer('EmojiCollectTableCompanion(')
          ..write('id: $id, ')
          ..write('emojiCollectId: $emojiCollectId, ')
          ..write('userId: $userId, ')
          ..write('emojiId: $emojiId, ')
          ..write('packageId: $packageId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $EmojiPackageTableTable extends EmojiPackageTable
    with TableInfo<$EmojiPackageTableTable, EmojiPackageTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmojiPackageTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _packageIdMeta = const VerificationMeta(
    'packageId',
  );
  @override
  late final GeneratedColumn<String> packageId = GeneratedColumn<String>(
    'package_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _coverFileMeta = const VerificationMeta(
    'coverFile',
  );
  @override
  late final GeneratedColumn<String> coverFile = GeneratedColumn<String>(
    'cover_file',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packageId,
    title,
    coverFile,
    userId,
    description,
    type,
    status,
    version,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emoji_package_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmojiPackageTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('package_id')) {
      context.handle(
        _packageIdMeta,
        packageId.isAcceptableOrUnknown(data['package_id']!, _packageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packageIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('cover_file')) {
      context.handle(
        _coverFileMeta,
        coverFile.isAcceptableOrUnknown(data['cover_file']!, _coverFileMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
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
  EmojiPackageTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmojiPackageTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      packageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      coverFile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_file'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
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
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EmojiPackageTableTable createAlias(String alias) {
    return $EmojiPackageTableTable(attachedDatabase, alias);
  }
}

class EmojiPackageTableData extends DataClass
    implements Insertable<EmojiPackageTableData> {
  final int id;
  final String packageId;
  final String title;
  final String? coverFile;
  final String userId;
  final String? description;
  final String type;
  final int status;
  final int version;
  final int createdAt;
  final int updatedAt;
  const EmojiPackageTableData({
    required this.id,
    required this.packageId,
    required this.title,
    this.coverFile,
    required this.userId,
    this.description,
    required this.type,
    required this.status,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['package_id'] = Variable<String>(packageId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || coverFile != null) {
      map['cover_file'] = Variable<String>(coverFile);
    }
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['type'] = Variable<String>(type);
    map['status'] = Variable<int>(status);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  EmojiPackageTableCompanion toCompanion(bool nullToAbsent) {
    return EmojiPackageTableCompanion(
      id: Value(id),
      packageId: Value(packageId),
      title: Value(title),
      coverFile: coverFile == null && nullToAbsent
          ? const Value.absent()
          : Value(coverFile),
      userId: Value(userId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      type: Value(type),
      status: Value(status),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EmojiPackageTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmojiPackageTableData(
      id: serializer.fromJson<int>(json['id']),
      packageId: serializer.fromJson<String>(json['packageId']),
      title: serializer.fromJson<String>(json['title']),
      coverFile: serializer.fromJson<String?>(json['coverFile']),
      userId: serializer.fromJson<String>(json['userId']),
      description: serializer.fromJson<String?>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<int>(json['status']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packageId': serializer.toJson<String>(packageId),
      'title': serializer.toJson<String>(title),
      'coverFile': serializer.toJson<String?>(coverFile),
      'userId': serializer.toJson<String>(userId),
      'description': serializer.toJson<String?>(description),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<int>(status),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  EmojiPackageTableData copyWith({
    int? id,
    String? packageId,
    String? title,
    Value<String?> coverFile = const Value.absent(),
    String? userId,
    Value<String?> description = const Value.absent(),
    String? type,
    int? status,
    int? version,
    int? createdAt,
    int? updatedAt,
  }) => EmojiPackageTableData(
    id: id ?? this.id,
    packageId: packageId ?? this.packageId,
    title: title ?? this.title,
    coverFile: coverFile.present ? coverFile.value : this.coverFile,
    userId: userId ?? this.userId,
    description: description.present ? description.value : this.description,
    type: type ?? this.type,
    status: status ?? this.status,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EmojiPackageTableData copyWithCompanion(EmojiPackageTableCompanion data) {
    return EmojiPackageTableData(
      id: data.id.present ? data.id.value : this.id,
      packageId: data.packageId.present ? data.packageId.value : this.packageId,
      title: data.title.present ? data.title.value : this.title,
      coverFile: data.coverFile.present ? data.coverFile.value : this.coverFile,
      userId: data.userId.present ? data.userId.value : this.userId,
      description: data.description.present
          ? data.description.value
          : this.description,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmojiPackageTableData(')
          ..write('id: $id, ')
          ..write('packageId: $packageId, ')
          ..write('title: $title, ')
          ..write('coverFile: $coverFile, ')
          ..write('userId: $userId, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
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
    packageId,
    title,
    coverFile,
    userId,
    description,
    type,
    status,
    version,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmojiPackageTableData &&
          other.id == this.id &&
          other.packageId == this.packageId &&
          other.title == this.title &&
          other.coverFile == this.coverFile &&
          other.userId == this.userId &&
          other.description == this.description &&
          other.type == this.type &&
          other.status == this.status &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmojiPackageTableCompanion
    extends UpdateCompanion<EmojiPackageTableData> {
  final Value<int> id;
  final Value<String> packageId;
  final Value<String> title;
  final Value<String?> coverFile;
  final Value<String> userId;
  final Value<String?> description;
  final Value<String> type;
  final Value<int> status;
  final Value<int> version;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const EmojiPackageTableCompanion({
    this.id = const Value.absent(),
    this.packageId = const Value.absent(),
    this.title = const Value.absent(),
    this.coverFile = const Value.absent(),
    this.userId = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EmojiPackageTableCompanion.insert({
    this.id = const Value.absent(),
    required String packageId,
    required String title,
    this.coverFile = const Value.absent(),
    required String userId,
    this.description = const Value.absent(),
    required String type,
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : packageId = Value(packageId),
       title = Value(title),
       userId = Value(userId),
       type = Value(type);
  static Insertable<EmojiPackageTableData> custom({
    Expression<int>? id,
    Expression<String>? packageId,
    Expression<String>? title,
    Expression<String>? coverFile,
    Expression<String>? userId,
    Expression<String>? description,
    Expression<String>? type,
    Expression<int>? status,
    Expression<int>? version,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packageId != null) 'package_id': packageId,
      if (title != null) 'title': title,
      if (coverFile != null) 'cover_file': coverFile,
      if (userId != null) 'user_id': userId,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EmojiPackageTableCompanion copyWith({
    Value<int>? id,
    Value<String>? packageId,
    Value<String>? title,
    Value<String?>? coverFile,
    Value<String>? userId,
    Value<String?>? description,
    Value<String>? type,
    Value<int>? status,
    Value<int>? version,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return EmojiPackageTableCompanion(
      id: id ?? this.id,
      packageId: packageId ?? this.packageId,
      title: title ?? this.title,
      coverFile: coverFile ?? this.coverFile,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      type: type ?? this.type,
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
    if (packageId.present) {
      map['package_id'] = Variable<String>(packageId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (coverFile.present) {
      map['cover_file'] = Variable<String>(coverFile.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
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
    return (StringBuffer('EmojiPackageTableCompanion(')
          ..write('id: $id, ')
          ..write('packageId: $packageId, ')
          ..write('title: $title, ')
          ..write('coverFile: $coverFile, ')
          ..write('userId: $userId, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $EmojiPackageCollectTableTable extends EmojiPackageCollectTable
    with
        TableInfo<
          $EmojiPackageCollectTableTable,
          EmojiPackageCollectTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmojiPackageCollectTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _packageCollectIdMeta = const VerificationMeta(
    'packageCollectId',
  );
  @override
  late final GeneratedColumn<String> packageCollectId = GeneratedColumn<String>(
    'package_collect_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _packageIdMeta = const VerificationMeta(
    'packageId',
  );
  @override
  late final GeneratedColumn<String> packageId = GeneratedColumn<String>(
    'package_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packageCollectId,
    userId,
    packageId,
    isDeleted,
    version,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emoji_package_collect_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmojiPackageCollectTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('package_collect_id')) {
      context.handle(
        _packageCollectIdMeta,
        packageCollectId.isAcceptableOrUnknown(
          data['package_collect_id']!,
          _packageCollectIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageCollectIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('package_id')) {
      context.handle(
        _packageIdMeta,
        packageId.isAcceptableOrUnknown(data['package_id']!, _packageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packageIdMeta);
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
  EmojiPackageCollectTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmojiPackageCollectTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      packageCollectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_collect_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      packageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_id'],
      )!,
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
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EmojiPackageCollectTableTable createAlias(String alias) {
    return $EmojiPackageCollectTableTable(attachedDatabase, alias);
  }
}

class EmojiPackageCollectTableData extends DataClass
    implements Insertable<EmojiPackageCollectTableData> {
  final int id;
  final String packageCollectId;
  final String userId;
  final String packageId;
  final int isDeleted;
  final int version;
  final int createdAt;
  final int updatedAt;
  const EmojiPackageCollectTableData({
    required this.id,
    required this.packageCollectId,
    required this.userId,
    required this.packageId,
    required this.isDeleted,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['package_collect_id'] = Variable<String>(packageCollectId);
    map['user_id'] = Variable<String>(userId);
    map['package_id'] = Variable<String>(packageId);
    map['is_deleted'] = Variable<int>(isDeleted);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  EmojiPackageCollectTableCompanion toCompanion(bool nullToAbsent) {
    return EmojiPackageCollectTableCompanion(
      id: Value(id),
      packageCollectId: Value(packageCollectId),
      userId: Value(userId),
      packageId: Value(packageId),
      isDeleted: Value(isDeleted),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EmojiPackageCollectTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmojiPackageCollectTableData(
      id: serializer.fromJson<int>(json['id']),
      packageCollectId: serializer.fromJson<String>(json['packageCollectId']),
      userId: serializer.fromJson<String>(json['userId']),
      packageId: serializer.fromJson<String>(json['packageId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packageCollectId': serializer.toJson<String>(packageCollectId),
      'userId': serializer.toJson<String>(userId),
      'packageId': serializer.toJson<String>(packageId),
      'isDeleted': serializer.toJson<int>(isDeleted),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  EmojiPackageCollectTableData copyWith({
    int? id,
    String? packageCollectId,
    String? userId,
    String? packageId,
    int? isDeleted,
    int? version,
    int? createdAt,
    int? updatedAt,
  }) => EmojiPackageCollectTableData(
    id: id ?? this.id,
    packageCollectId: packageCollectId ?? this.packageCollectId,
    userId: userId ?? this.userId,
    packageId: packageId ?? this.packageId,
    isDeleted: isDeleted ?? this.isDeleted,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EmojiPackageCollectTableData copyWithCompanion(
    EmojiPackageCollectTableCompanion data,
  ) {
    return EmojiPackageCollectTableData(
      id: data.id.present ? data.id.value : this.id,
      packageCollectId: data.packageCollectId.present
          ? data.packageCollectId.value
          : this.packageCollectId,
      userId: data.userId.present ? data.userId.value : this.userId,
      packageId: data.packageId.present ? data.packageId.value : this.packageId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmojiPackageCollectTableData(')
          ..write('id: $id, ')
          ..write('packageCollectId: $packageCollectId, ')
          ..write('userId: $userId, ')
          ..write('packageId: $packageId, ')
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
    packageCollectId,
    userId,
    packageId,
    isDeleted,
    version,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmojiPackageCollectTableData &&
          other.id == this.id &&
          other.packageCollectId == this.packageCollectId &&
          other.userId == this.userId &&
          other.packageId == this.packageId &&
          other.isDeleted == this.isDeleted &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmojiPackageCollectTableCompanion
    extends UpdateCompanion<EmojiPackageCollectTableData> {
  final Value<int> id;
  final Value<String> packageCollectId;
  final Value<String> userId;
  final Value<String> packageId;
  final Value<int> isDeleted;
  final Value<int> version;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const EmojiPackageCollectTableCompanion({
    this.id = const Value.absent(),
    this.packageCollectId = const Value.absent(),
    this.userId = const Value.absent(),
    this.packageId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EmojiPackageCollectTableCompanion.insert({
    this.id = const Value.absent(),
    required String packageCollectId,
    required String userId,
    required String packageId,
    this.isDeleted = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : packageCollectId = Value(packageCollectId),
       userId = Value(userId),
       packageId = Value(packageId);
  static Insertable<EmojiPackageCollectTableData> custom({
    Expression<int>? id,
    Expression<String>? packageCollectId,
    Expression<String>? userId,
    Expression<String>? packageId,
    Expression<int>? isDeleted,
    Expression<int>? version,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packageCollectId != null) 'package_collect_id': packageCollectId,
      if (userId != null) 'user_id': userId,
      if (packageId != null) 'package_id': packageId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EmojiPackageCollectTableCompanion copyWith({
    Value<int>? id,
    Value<String>? packageCollectId,
    Value<String>? userId,
    Value<String>? packageId,
    Value<int>? isDeleted,
    Value<int>? version,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return EmojiPackageCollectTableCompanion(
      id: id ?? this.id,
      packageCollectId: packageCollectId ?? this.packageCollectId,
      userId: userId ?? this.userId,
      packageId: packageId ?? this.packageId,
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
    if (packageCollectId.present) {
      map['package_collect_id'] = Variable<String>(packageCollectId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (packageId.present) {
      map['package_id'] = Variable<String>(packageId.value);
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
    return (StringBuffer('EmojiPackageCollectTableCompanion(')
          ..write('id: $id, ')
          ..write('packageCollectId: $packageCollectId, ')
          ..write('userId: $userId, ')
          ..write('packageId: $packageId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $EmojiPackageEmojiTableTable extends EmojiPackageEmojiTable
    with TableInfo<$EmojiPackageEmojiTableTable, EmojiPackageEmojiTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmojiPackageEmojiTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _relationIdMeta = const VerificationMeta(
    'relationId',
  );
  @override
  late final GeneratedColumn<String> relationId = GeneratedColumn<String>(
    'relation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _packageIdMeta = const VerificationMeta(
    'packageId',
  );
  @override
  late final GeneratedColumn<String> packageId = GeneratedColumn<String>(
    'package_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiIdMeta = const VerificationMeta(
    'emojiId',
  );
  @override
  late final GeneratedColumn<String> emojiId = GeneratedColumn<String>(
    'emoji_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
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
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    relationId,
    packageId,
    emojiId,
    sortOrder,
    version,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emoji_package_emoji_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmojiPackageEmojiTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('relation_id')) {
      context.handle(
        _relationIdMeta,
        relationId.isAcceptableOrUnknown(data['relation_id']!, _relationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_relationIdMeta);
    }
    if (data.containsKey('package_id')) {
      context.handle(
        _packageIdMeta,
        packageId.isAcceptableOrUnknown(data['package_id']!, _packageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packageIdMeta);
    }
    if (data.containsKey('emoji_id')) {
      context.handle(
        _emojiIdMeta,
        emojiId.isAcceptableOrUnknown(data['emoji_id']!, _emojiIdMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
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
  EmojiPackageEmojiTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmojiPackageEmojiTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      relationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation_id'],
      )!,
      packageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_id'],
      )!,
      emojiId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EmojiPackageEmojiTableTable createAlias(String alias) {
    return $EmojiPackageEmojiTableTable(attachedDatabase, alias);
  }
}

class EmojiPackageEmojiTableData extends DataClass
    implements Insertable<EmojiPackageEmojiTableData> {
  final int id;
  final String relationId;
  final String packageId;
  final String emojiId;
  final int sortOrder;
  final int version;
  final int createdAt;
  final int updatedAt;
  const EmojiPackageEmojiTableData({
    required this.id,
    required this.relationId,
    required this.packageId,
    required this.emojiId,
    required this.sortOrder,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['relation_id'] = Variable<String>(relationId);
    map['package_id'] = Variable<String>(packageId);
    map['emoji_id'] = Variable<String>(emojiId);
    map['sort_order'] = Variable<int>(sortOrder);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  EmojiPackageEmojiTableCompanion toCompanion(bool nullToAbsent) {
    return EmojiPackageEmojiTableCompanion(
      id: Value(id),
      relationId: Value(relationId),
      packageId: Value(packageId),
      emojiId: Value(emojiId),
      sortOrder: Value(sortOrder),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EmojiPackageEmojiTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmojiPackageEmojiTableData(
      id: serializer.fromJson<int>(json['id']),
      relationId: serializer.fromJson<String>(json['relationId']),
      packageId: serializer.fromJson<String>(json['packageId']),
      emojiId: serializer.fromJson<String>(json['emojiId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'relationId': serializer.toJson<String>(relationId),
      'packageId': serializer.toJson<String>(packageId),
      'emojiId': serializer.toJson<String>(emojiId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  EmojiPackageEmojiTableData copyWith({
    int? id,
    String? relationId,
    String? packageId,
    String? emojiId,
    int? sortOrder,
    int? version,
    int? createdAt,
    int? updatedAt,
  }) => EmojiPackageEmojiTableData(
    id: id ?? this.id,
    relationId: relationId ?? this.relationId,
    packageId: packageId ?? this.packageId,
    emojiId: emojiId ?? this.emojiId,
    sortOrder: sortOrder ?? this.sortOrder,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EmojiPackageEmojiTableData copyWithCompanion(
    EmojiPackageEmojiTableCompanion data,
  ) {
    return EmojiPackageEmojiTableData(
      id: data.id.present ? data.id.value : this.id,
      relationId: data.relationId.present
          ? data.relationId.value
          : this.relationId,
      packageId: data.packageId.present ? data.packageId.value : this.packageId,
      emojiId: data.emojiId.present ? data.emojiId.value : this.emojiId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmojiPackageEmojiTableData(')
          ..write('id: $id, ')
          ..write('relationId: $relationId, ')
          ..write('packageId: $packageId, ')
          ..write('emojiId: $emojiId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    relationId,
    packageId,
    emojiId,
    sortOrder,
    version,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmojiPackageEmojiTableData &&
          other.id == this.id &&
          other.relationId == this.relationId &&
          other.packageId == this.packageId &&
          other.emojiId == this.emojiId &&
          other.sortOrder == this.sortOrder &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmojiPackageEmojiTableCompanion
    extends UpdateCompanion<EmojiPackageEmojiTableData> {
  final Value<int> id;
  final Value<String> relationId;
  final Value<String> packageId;
  final Value<String> emojiId;
  final Value<int> sortOrder;
  final Value<int> version;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const EmojiPackageEmojiTableCompanion({
    this.id = const Value.absent(),
    this.relationId = const Value.absent(),
    this.packageId = const Value.absent(),
    this.emojiId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EmojiPackageEmojiTableCompanion.insert({
    this.id = const Value.absent(),
    required String relationId,
    required String packageId,
    required String emojiId,
    this.sortOrder = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : relationId = Value(relationId),
       packageId = Value(packageId),
       emojiId = Value(emojiId);
  static Insertable<EmojiPackageEmojiTableData> custom({
    Expression<int>? id,
    Expression<String>? relationId,
    Expression<String>? packageId,
    Expression<String>? emojiId,
    Expression<int>? sortOrder,
    Expression<int>? version,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (relationId != null) 'relation_id': relationId,
      if (packageId != null) 'package_id': packageId,
      if (emojiId != null) 'emoji_id': emojiId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EmojiPackageEmojiTableCompanion copyWith({
    Value<int>? id,
    Value<String>? relationId,
    Value<String>? packageId,
    Value<String>? emojiId,
    Value<int>? sortOrder,
    Value<int>? version,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return EmojiPackageEmojiTableCompanion(
      id: id ?? this.id,
      relationId: relationId ?? this.relationId,
      packageId: packageId ?? this.packageId,
      emojiId: emojiId ?? this.emojiId,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (relationId.present) {
      map['relation_id'] = Variable<String>(relationId.value);
    }
    if (packageId.present) {
      map['package_id'] = Variable<String>(packageId.value);
    }
    if (emojiId.present) {
      map['emoji_id'] = Variable<String>(emojiId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
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
    return (StringBuffer('EmojiPackageEmojiTableCompanion(')
          ..write('id: $id, ')
          ..write('relationId: $relationId, ')
          ..write('packageId: $packageId, ')
          ..write('emojiId: $emojiId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MediaTableTable extends MediaTable
    with TableInfo<$MediaTableTable, MediaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _fileKeyMeta = const VerificationMeta(
    'fileKey',
  );
  @override
  late final GeneratedColumn<String> fileKey = GeneratedColumn<String>(
    'file_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fileKey,
    path,
    type,
    size,
    createdAt,
    updatedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('file_key')) {
      context.handle(
        _fileKeyMeta,
        fileKey.isAcceptableOrUnknown(data['file_key']!, _fileKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_fileKeyMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
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
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fileKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_key'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $MediaTableTable createAlias(String alias) {
    return $MediaTableTable(attachedDatabase, alias);
  }
}

class MediaTableData extends DataClass implements Insertable<MediaTableData> {
  final int id;
  final String fileKey;
  final String path;
  final String type;
  final int? size;
  final int createdAt;
  final int updatedAt;
  final int isDeleted;
  const MediaTableData({
    required this.id,
    required this.fileKey,
    required this.path,
    required this.type,
    this.size,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['file_key'] = Variable<String>(fileKey);
    map['path'] = Variable<String>(path);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<int>(size);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  MediaTableCompanion toCompanion(bool nullToAbsent) {
    return MediaTableCompanion(
      id: Value(id),
      fileKey: Value(fileKey),
      path: Value(path),
      type: Value(type),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory MediaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaTableData(
      id: serializer.fromJson<int>(json['id']),
      fileKey: serializer.fromJson<String>(json['fileKey']),
      path: serializer.fromJson<String>(json['path']),
      type: serializer.fromJson<String>(json['type']),
      size: serializer.fromJson<int?>(json['size']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fileKey': serializer.toJson<String>(fileKey),
      'path': serializer.toJson<String>(path),
      'type': serializer.toJson<String>(type),
      'size': serializer.toJson<int?>(size),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  MediaTableData copyWith({
    int? id,
    String? fileKey,
    String? path,
    String? type,
    Value<int?> size = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    int? isDeleted,
  }) => MediaTableData(
    id: id ?? this.id,
    fileKey: fileKey ?? this.fileKey,
    path: path ?? this.path,
    type: type ?? this.type,
    size: size.present ? size.value : this.size,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  MediaTableData copyWithCompanion(MediaTableCompanion data) {
    return MediaTableData(
      id: data.id.present ? data.id.value : this.id,
      fileKey: data.fileKey.present ? data.fileKey.value : this.fileKey,
      path: data.path.present ? data.path.value : this.path,
      type: data.type.present ? data.type.value : this.type,
      size: data.size.present ? data.size.value : this.size,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaTableData(')
          ..write('id: $id, ')
          ..write('fileKey: $fileKey, ')
          ..write('path: $path, ')
          ..write('type: $type, ')
          ..write('size: $size, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fileKey,
    path,
    type,
    size,
    createdAt,
    updatedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaTableData &&
          other.id == this.id &&
          other.fileKey == this.fileKey &&
          other.path == this.path &&
          other.type == this.type &&
          other.size == this.size &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class MediaTableCompanion extends UpdateCompanion<MediaTableData> {
  final Value<int> id;
  final Value<String> fileKey;
  final Value<String> path;
  final Value<String> type;
  final Value<int?> size;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> isDeleted;
  const MediaTableCompanion({
    this.id = const Value.absent(),
    this.fileKey = const Value.absent(),
    this.path = const Value.absent(),
    this.type = const Value.absent(),
    this.size = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  MediaTableCompanion.insert({
    this.id = const Value.absent(),
    required String fileKey,
    required String path,
    required String type,
    this.size = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : fileKey = Value(fileKey),
       path = Value(path),
       type = Value(type);
  static Insertable<MediaTableData> custom({
    Expression<int>? id,
    Expression<String>? fileKey,
    Expression<String>? path,
    Expression<String>? type,
    Expression<int>? size,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fileKey != null) 'file_key': fileKey,
      if (path != null) 'path': path,
      if (type != null) 'type': type,
      if (size != null) 'size': size,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  MediaTableCompanion copyWith({
    Value<int>? id,
    Value<String>? fileKey,
    Value<String>? path,
    Value<String>? type,
    Value<int?>? size,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? isDeleted,
  }) {
    return MediaTableCompanion(
      id: id ?? this.id,
      fileKey: fileKey ?? this.fileKey,
      path: path ?? this.path,
      type: type ?? this.type,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fileKey.present) {
      map['file_key'] = Variable<String>(fileKey.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaTableCompanion(')
          ..write('id: $id, ')
          ..write('fileKey: $fileKey, ')
          ..write('path: $path, ')
          ..write('type: $type, ')
          ..write('size: $size, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $NotificationEventsTable extends NotificationEvents
    with TableInfo<$NotificationEventsTable, NotificationEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationEventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
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
  static const VerificationMeta _fromUserIdMeta = const VerificationMeta(
    'fromUserId',
  );
  @override
  late final GeneratedColumn<String> fromUserId = GeneratedColumn<String>(
    'from_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
    'target_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetTypeMeta = const VerificationMeta(
    'targetType',
  );
  @override
  late final GeneratedColumn<String> targetType = GeneratedColumn<String>(
    'target_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
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
  static const VerificationMeta _dedupHashMeta = const VerificationMeta(
    'dedupHash',
  );
  @override
  late final GeneratedColumn<String> dedupHash = GeneratedColumn<String>(
    'dedup_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    eventId,
    eventType,
    category,
    version,
    fromUserId,
    targetId,
    targetType,
    payload,
    priority,
    status,
    dedupHash,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('from_user_id')) {
      context.handle(
        _fromUserIdMeta,
        fromUserId.isAcceptableOrUnknown(
          data['from_user_id']!,
          _fromUserIdMeta,
        ),
      );
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    }
    if (data.containsKey('target_type')) {
      context.handle(
        _targetTypeMeta,
        targetType.isAcceptableOrUnknown(data['target_type']!, _targetTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_targetTypeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('dedup_hash')) {
      context.handle(
        _dedupHashMeta,
        dedupHash.isAcceptableOrUnknown(data['dedup_hash']!, _dedupHashMeta),
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
  NotificationEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      fromUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_user_id'],
      ),
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_id'],
      ),
      targetType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      dedupHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dedup_hash'],
      ),
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
  $NotificationEventsTable createAlias(String alias) {
    return $NotificationEventsTable(attachedDatabase, alias);
  }
}

class NotificationEvent extends DataClass
    implements Insertable<NotificationEvent> {
  final int id;
  final String eventId;
  final String eventType;
  final String category;
  final int version;
  final String? fromUserId;
  final String? targetId;
  final String targetType;
  final String? payload;
  final int priority;
  final int status;
  final String? dedupHash;
  final int? createdAt;
  final int? updatedAt;
  const NotificationEvent({
    required this.id,
    required this.eventId,
    required this.eventType,
    required this.category,
    required this.version,
    this.fromUserId,
    this.targetId,
    required this.targetType,
    this.payload,
    required this.priority,
    required this.status,
    this.dedupHash,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<String>(eventId);
    map['event_type'] = Variable<String>(eventType);
    map['category'] = Variable<String>(category);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || fromUserId != null) {
      map['from_user_id'] = Variable<String>(fromUserId);
    }
    if (!nullToAbsent || targetId != null) {
      map['target_id'] = Variable<String>(targetId);
    }
    map['target_type'] = Variable<String>(targetType);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['priority'] = Variable<int>(priority);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || dedupHash != null) {
      map['dedup_hash'] = Variable<String>(dedupHash);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  NotificationEventsCompanion toCompanion(bool nullToAbsent) {
    return NotificationEventsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      eventType: Value(eventType),
      category: Value(category),
      version: Value(version),
      fromUserId: fromUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromUserId),
      targetId: targetId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetId),
      targetType: Value(targetType),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      priority: Value(priority),
      status: Value(status),
      dedupHash: dedupHash == null && nullToAbsent
          ? const Value.absent()
          : Value(dedupHash),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory NotificationEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationEvent(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      category: serializer.fromJson<String>(json['category']),
      version: serializer.fromJson<int>(json['version']),
      fromUserId: serializer.fromJson<String?>(json['fromUserId']),
      targetId: serializer.fromJson<String?>(json['targetId']),
      targetType: serializer.fromJson<String>(json['targetType']),
      payload: serializer.fromJson<String?>(json['payload']),
      priority: serializer.fromJson<int>(json['priority']),
      status: serializer.fromJson<int>(json['status']),
      dedupHash: serializer.fromJson<String?>(json['dedupHash']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<String>(eventId),
      'eventType': serializer.toJson<String>(eventType),
      'category': serializer.toJson<String>(category),
      'version': serializer.toJson<int>(version),
      'fromUserId': serializer.toJson<String?>(fromUserId),
      'targetId': serializer.toJson<String?>(targetId),
      'targetType': serializer.toJson<String>(targetType),
      'payload': serializer.toJson<String?>(payload),
      'priority': serializer.toJson<int>(priority),
      'status': serializer.toJson<int>(status),
      'dedupHash': serializer.toJson<String?>(dedupHash),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  NotificationEvent copyWith({
    int? id,
    String? eventId,
    String? eventType,
    String? category,
    int? version,
    Value<String?> fromUserId = const Value.absent(),
    Value<String?> targetId = const Value.absent(),
    String? targetType,
    Value<String?> payload = const Value.absent(),
    int? priority,
    int? status,
    Value<String?> dedupHash = const Value.absent(),
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => NotificationEvent(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    eventType: eventType ?? this.eventType,
    category: category ?? this.category,
    version: version ?? this.version,
    fromUserId: fromUserId.present ? fromUserId.value : this.fromUserId,
    targetId: targetId.present ? targetId.value : this.targetId,
    targetType: targetType ?? this.targetType,
    payload: payload.present ? payload.value : this.payload,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    dedupHash: dedupHash.present ? dedupHash.value : this.dedupHash,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  NotificationEvent copyWithCompanion(NotificationEventsCompanion data) {
    return NotificationEvent(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      category: data.category.present ? data.category.value : this.category,
      version: data.version.present ? data.version.value : this.version,
      fromUserId: data.fromUserId.present
          ? data.fromUserId.value
          : this.fromUserId,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      payload: data.payload.present ? data.payload.value : this.payload,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      dedupHash: data.dedupHash.present ? data.dedupHash.value : this.dedupHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationEvent(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('eventType: $eventType, ')
          ..write('category: $category, ')
          ..write('version: $version, ')
          ..write('fromUserId: $fromUserId, ')
          ..write('targetId: $targetId, ')
          ..write('targetType: $targetType, ')
          ..write('payload: $payload, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('dedupHash: $dedupHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventId,
    eventType,
    category,
    version,
    fromUserId,
    targetId,
    targetType,
    payload,
    priority,
    status,
    dedupHash,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationEvent &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.eventType == this.eventType &&
          other.category == this.category &&
          other.version == this.version &&
          other.fromUserId == this.fromUserId &&
          other.targetId == this.targetId &&
          other.targetType == this.targetType &&
          other.payload == this.payload &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.dedupHash == this.dedupHash &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotificationEventsCompanion extends UpdateCompanion<NotificationEvent> {
  final Value<int> id;
  final Value<String> eventId;
  final Value<String> eventType;
  final Value<String> category;
  final Value<int> version;
  final Value<String?> fromUserId;
  final Value<String?> targetId;
  final Value<String> targetType;
  final Value<String?> payload;
  final Value<int> priority;
  final Value<int> status;
  final Value<String?> dedupHash;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  const NotificationEventsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.category = const Value.absent(),
    this.version = const Value.absent(),
    this.fromUserId = const Value.absent(),
    this.targetId = const Value.absent(),
    this.targetType = const Value.absent(),
    this.payload = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.dedupHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotificationEventsCompanion.insert({
    this.id = const Value.absent(),
    required String eventId,
    required String eventType,
    required String category,
    this.version = const Value.absent(),
    this.fromUserId = const Value.absent(),
    this.targetId = const Value.absent(),
    required String targetType,
    this.payload = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.dedupHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : eventId = Value(eventId),
       eventType = Value(eventType),
       category = Value(category),
       targetType = Value(targetType);
  static Insertable<NotificationEvent> custom({
    Expression<int>? id,
    Expression<String>? eventId,
    Expression<String>? eventType,
    Expression<String>? category,
    Expression<int>? version,
    Expression<String>? fromUserId,
    Expression<String>? targetId,
    Expression<String>? targetType,
    Expression<String>? payload,
    Expression<int>? priority,
    Expression<int>? status,
    Expression<String>? dedupHash,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (eventType != null) 'event_type': eventType,
      if (category != null) 'category': category,
      if (version != null) 'version': version,
      if (fromUserId != null) 'from_user_id': fromUserId,
      if (targetId != null) 'target_id': targetId,
      if (targetType != null) 'target_type': targetType,
      if (payload != null) 'payload': payload,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (dedupHash != null) 'dedup_hash': dedupHash,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotificationEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? eventId,
    Value<String>? eventType,
    Value<String>? category,
    Value<int>? version,
    Value<String?>? fromUserId,
    Value<String?>? targetId,
    Value<String>? targetType,
    Value<String?>? payload,
    Value<int>? priority,
    Value<int>? status,
    Value<String?>? dedupHash,
    Value<int?>? createdAt,
    Value<int?>? updatedAt,
  }) {
    return NotificationEventsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      eventType: eventType ?? this.eventType,
      category: category ?? this.category,
      version: version ?? this.version,
      fromUserId: fromUserId ?? this.fromUserId,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      payload: payload ?? this.payload,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dedupHash: dedupHash ?? this.dedupHash,
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
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (fromUserId.present) {
      map['from_user_id'] = Variable<String>(fromUserId.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(targetType.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (dedupHash.present) {
      map['dedup_hash'] = Variable<String>(dedupHash.value);
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
    return (StringBuffer('NotificationEventsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('eventType: $eventType, ')
          ..write('category: $category, ')
          ..write('version: $version, ')
          ..write('fromUserId: $fromUserId, ')
          ..write('targetId: $targetId, ')
          ..write('targetType: $targetType, ')
          ..write('payload: $payload, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('dedupHash: $dedupHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $NotificationInboxTableTable extends NotificationInboxTable
    with TableInfo<$NotificationInboxTableTable, NotificationInboxTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationInboxTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
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
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<int> isRead = GeneratedColumn<int>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<int> readAt = GeneratedColumn<int>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    defaultValue: const Constant(1),
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
  static const VerificationMeta _silentMeta = const VerificationMeta('silent');
  @override
  late final GeneratedColumn<int> silent = GeneratedColumn<int>(
    'silent',
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
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    eventId,
    eventType,
    category,
    version,
    isRead,
    readAt,
    status,
    isDeleted,
    silent,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_inbox_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationInboxTableData> instance, {
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
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('silent')) {
      context.handle(
        _silentMeta,
        silent.isAcceptableOrUnknown(data['silent']!, _silentMeta),
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
  NotificationInboxTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationInboxTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_read'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}read_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_deleted'],
      )!,
      silent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}silent'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotificationInboxTableTable createAlias(String alias) {
    return $NotificationInboxTableTable(attachedDatabase, alias);
  }
}

class NotificationInboxTableData extends DataClass
    implements Insertable<NotificationInboxTableData> {
  final int id;
  final String userId;
  final String eventId;
  final String eventType;
  final String category;
  final int version;
  final int isRead;
  final int? readAt;
  final int status;
  final int isDeleted;
  final int silent;
  final int createdAt;
  final int updatedAt;
  const NotificationInboxTableData({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.eventType,
    required this.category,
    required this.version,
    required this.isRead,
    this.readAt,
    required this.status,
    required this.isDeleted,
    required this.silent,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['event_id'] = Variable<String>(eventId);
    map['event_type'] = Variable<String>(eventType);
    map['category'] = Variable<String>(category);
    map['version'] = Variable<int>(version);
    map['is_read'] = Variable<int>(isRead);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<int>(readAt);
    }
    map['status'] = Variable<int>(status);
    map['is_deleted'] = Variable<int>(isDeleted);
    map['silent'] = Variable<int>(silent);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  NotificationInboxTableCompanion toCompanion(bool nullToAbsent) {
    return NotificationInboxTableCompanion(
      id: Value(id),
      userId: Value(userId),
      eventId: Value(eventId),
      eventType: Value(eventType),
      category: Value(category),
      version: Value(version),
      isRead: Value(isRead),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
      status: Value(status),
      isDeleted: Value(isDeleted),
      silent: Value(silent),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NotificationInboxTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationInboxTableData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      eventId: serializer.fromJson<String>(json['eventId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      category: serializer.fromJson<String>(json['category']),
      version: serializer.fromJson<int>(json['version']),
      isRead: serializer.fromJson<int>(json['isRead']),
      readAt: serializer.fromJson<int?>(json['readAt']),
      status: serializer.fromJson<int>(json['status']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
      silent: serializer.fromJson<int>(json['silent']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'eventId': serializer.toJson<String>(eventId),
      'eventType': serializer.toJson<String>(eventType),
      'category': serializer.toJson<String>(category),
      'version': serializer.toJson<int>(version),
      'isRead': serializer.toJson<int>(isRead),
      'readAt': serializer.toJson<int?>(readAt),
      'status': serializer.toJson<int>(status),
      'isDeleted': serializer.toJson<int>(isDeleted),
      'silent': serializer.toJson<int>(silent),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  NotificationInboxTableData copyWith({
    int? id,
    String? userId,
    String? eventId,
    String? eventType,
    String? category,
    int? version,
    int? isRead,
    Value<int?> readAt = const Value.absent(),
    int? status,
    int? isDeleted,
    int? silent,
    int? createdAt,
    int? updatedAt,
  }) => NotificationInboxTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    eventId: eventId ?? this.eventId,
    eventType: eventType ?? this.eventType,
    category: category ?? this.category,
    version: version ?? this.version,
    isRead: isRead ?? this.isRead,
    readAt: readAt.present ? readAt.value : this.readAt,
    status: status ?? this.status,
    isDeleted: isDeleted ?? this.isDeleted,
    silent: silent ?? this.silent,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NotificationInboxTableData copyWithCompanion(
    NotificationInboxTableCompanion data,
  ) {
    return NotificationInboxTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      category: data.category.present ? data.category.value : this.category,
      version: data.version.present ? data.version.value : this.version,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
      status: data.status.present ? data.status.value : this.status,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      silent: data.silent.present ? data.silent.value : this.silent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationInboxTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('eventId: $eventId, ')
          ..write('eventType: $eventType, ')
          ..write('category: $category, ')
          ..write('version: $version, ')
          ..write('isRead: $isRead, ')
          ..write('readAt: $readAt, ')
          ..write('status: $status, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('silent: $silent, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    eventId,
    eventType,
    category,
    version,
    isRead,
    readAt,
    status,
    isDeleted,
    silent,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationInboxTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.eventId == this.eventId &&
          other.eventType == this.eventType &&
          other.category == this.category &&
          other.version == this.version &&
          other.isRead == this.isRead &&
          other.readAt == this.readAt &&
          other.status == this.status &&
          other.isDeleted == this.isDeleted &&
          other.silent == this.silent &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotificationInboxTableCompanion
    extends UpdateCompanion<NotificationInboxTableData> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> eventId;
  final Value<String> eventType;
  final Value<String> category;
  final Value<int> version;
  final Value<int> isRead;
  final Value<int?> readAt;
  final Value<int> status;
  final Value<int> isDeleted;
  final Value<int> silent;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const NotificationInboxTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.eventId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.category = const Value.absent(),
    this.version = const Value.absent(),
    this.isRead = const Value.absent(),
    this.readAt = const Value.absent(),
    this.status = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.silent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotificationInboxTableCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String eventId,
    required String eventType,
    required String category,
    this.version = const Value.absent(),
    this.isRead = const Value.absent(),
    this.readAt = const Value.absent(),
    this.status = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.silent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId),
       eventId = Value(eventId),
       eventType = Value(eventType),
       category = Value(category);
  static Insertable<NotificationInboxTableData> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? eventId,
    Expression<String>? eventType,
    Expression<String>? category,
    Expression<int>? version,
    Expression<int>? isRead,
    Expression<int>? readAt,
    Expression<int>? status,
    Expression<int>? isDeleted,
    Expression<int>? silent,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (eventId != null) 'event_id': eventId,
      if (eventType != null) 'event_type': eventType,
      if (category != null) 'category': category,
      if (version != null) 'version': version,
      if (isRead != null) 'is_read': isRead,
      if (readAt != null) 'read_at': readAt,
      if (status != null) 'status': status,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (silent != null) 'silent': silent,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotificationInboxTableCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<String>? eventId,
    Value<String>? eventType,
    Value<String>? category,
    Value<int>? version,
    Value<int>? isRead,
    Value<int?>? readAt,
    Value<int>? status,
    Value<int>? isDeleted,
    Value<int>? silent,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return NotificationInboxTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      eventType: eventType ?? this.eventType,
      category: category ?? this.category,
      version: version ?? this.version,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      silent: silent ?? this.silent,
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
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<int>(isRead.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<int>(readAt.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    if (silent.present) {
      map['silent'] = Variable<int>(silent.value);
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
    return (StringBuffer('NotificationInboxTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('eventId: $eventId, ')
          ..write('eventType: $eventType, ')
          ..write('category: $category, ')
          ..write('version: $version, ')
          ..write('isRead: $isRead, ')
          ..write('readAt: $readAt, ')
          ..write('status: $status, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('silent: $silent, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $NotificationReadTableTable extends NotificationReadTable
    with TableInfo<$NotificationReadTableTable, NotificationReadTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationReadTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
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
  static const VerificationMeta _lastReadAtMeta = const VerificationMeta(
    'lastReadAt',
  );
  @override
  late final GeneratedColumn<int> lastReadAt = GeneratedColumn<int>(
    'last_read_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    category,
    version,
    lastReadAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_read_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationReadTableData> instance, {
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
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('last_read_at')) {
      context.handle(
        _lastReadAtMeta,
        lastReadAt.isAcceptableOrUnknown(
          data['last_read_at']!,
          _lastReadAtMeta,
        ),
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
  NotificationReadTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationReadTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      lastReadAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_read_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotificationReadTableTable createAlias(String alias) {
    return $NotificationReadTableTable(attachedDatabase, alias);
  }
}

class NotificationReadTableData extends DataClass
    implements Insertable<NotificationReadTableData> {
  final int id;
  final String userId;
  final String category;
  final int version;
  final int? lastReadAt;
  final int createdAt;
  final int updatedAt;
  const NotificationReadTableData({
    required this.id,
    required this.userId,
    required this.category,
    required this.version,
    this.lastReadAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['category'] = Variable<String>(category);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || lastReadAt != null) {
      map['last_read_at'] = Variable<int>(lastReadAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  NotificationReadTableCompanion toCompanion(bool nullToAbsent) {
    return NotificationReadTableCompanion(
      id: Value(id),
      userId: Value(userId),
      category: Value(category),
      version: Value(version),
      lastReadAt: lastReadAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReadAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NotificationReadTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationReadTableData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      category: serializer.fromJson<String>(json['category']),
      version: serializer.fromJson<int>(json['version']),
      lastReadAt: serializer.fromJson<int?>(json['lastReadAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'category': serializer.toJson<String>(category),
      'version': serializer.toJson<int>(version),
      'lastReadAt': serializer.toJson<int?>(lastReadAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  NotificationReadTableData copyWith({
    int? id,
    String? userId,
    String? category,
    int? version,
    Value<int?> lastReadAt = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => NotificationReadTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    category: category ?? this.category,
    version: version ?? this.version,
    lastReadAt: lastReadAt.present ? lastReadAt.value : this.lastReadAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NotificationReadTableData copyWithCompanion(
    NotificationReadTableCompanion data,
  ) {
    return NotificationReadTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      category: data.category.present ? data.category.value : this.category,
      version: data.version.present ? data.version.value : this.version,
      lastReadAt: data.lastReadAt.present
          ? data.lastReadAt.value
          : this.lastReadAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationReadTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('category: $category, ')
          ..write('version: $version, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    category,
    version,
    lastReadAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationReadTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.category == this.category &&
          other.version == this.version &&
          other.lastReadAt == this.lastReadAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotificationReadTableCompanion
    extends UpdateCompanion<NotificationReadTableData> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> category;
  final Value<int> version;
  final Value<int?> lastReadAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const NotificationReadTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.category = const Value.absent(),
    this.version = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotificationReadTableCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String category,
    this.version = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId),
       category = Value(category);
  static Insertable<NotificationReadTableData> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? category,
    Expression<int>? version,
    Expression<int>? lastReadAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (category != null) 'category': category,
      if (version != null) 'version': version,
      if (lastReadAt != null) 'last_read_at': lastReadAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotificationReadTableCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<String>? category,
    Value<int>? version,
    Value<int?>? lastReadAt,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return NotificationReadTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      version: version ?? this.version,
      lastReadAt: lastReadAt ?? this.lastReadAt,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (lastReadAt.present) {
      map['last_read_at'] = Variable<int>(lastReadAt.value);
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
    return (StringBuffer('NotificationReadTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('category: $category, ')
          ..write('version: $version, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('createdAt: $createdAt, ')
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
  late final $EmojisTable emojis = $EmojisTable(this);
  late final $EmojiCollectTableTable emojiCollectTable =
      $EmojiCollectTableTable(this);
  late final $EmojiPackageTableTable emojiPackageTable =
      $EmojiPackageTableTable(this);
  late final $EmojiPackageCollectTableTable emojiPackageCollectTable =
      $EmojiPackageCollectTableTable(this);
  late final $EmojiPackageEmojiTableTable emojiPackageEmojiTable =
      $EmojiPackageEmojiTableTable(this);
  late final $MediaTableTable mediaTable = $MediaTableTable(this);
  late final $NotificationEventsTable notificationEvents =
      $NotificationEventsTable(this);
  late final $NotificationInboxTableTable notificationInboxTable =
      $NotificationInboxTableTable(this);
  late final $NotificationReadTableTable notificationReadTable =
      $NotificationReadTableTable(this);
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
    emojis,
    emojiCollectTable,
    emojiPackageTable,
    emojiPackageCollectTable,
    emojiPackageEmojiTable,
    mediaTable,
    notificationEvents,
    notificationInboxTable,
    notificationReadTable,
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
      Value<String?> title,
      Value<String?> avatar,
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
      Value<String?> title,
      Value<String?> avatar,
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
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

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

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
                Value<String?> title = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<int> maxSeq = const Value.absent(),
                Value<String?> lastMessage = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => ChatConversationsCompanion(
                id: id,
                conversationId: conversationId,
                type: type,
                title: title,
                avatar: avatar,
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
                Value<String?> title = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<int> maxSeq = const Value.absent(),
                Value<String?> lastMessage = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => ChatConversationsCompanion.insert(
                id: id,
                conversationId: conversationId,
                type: type,
                title: title,
                avatar: avatar,
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
      Value<int?> createdAt,
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
      Value<int?> createdAt,
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

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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
                Value<int?> createdAt = const Value.absent(),
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
                createdAt: createdAt,
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
                Value<int?> createdAt = const Value.absent(),
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
      required String conversationId,
      required String module,
      Value<int> seq,
      Value<int> version,
      Value<int?> updatedAt,
      Value<int> rowid,
    });
typedef $$ChatSyncStatusTableUpdateCompanionBuilder =
    ChatSyncStatusCompanion Function({
      Value<String> conversationId,
      Value<String> module,
      Value<int> seq,
      Value<int> version,
      Value<int?> updatedAt,
      Value<int> rowid,
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
                Value<String> conversationId = const Value.absent(),
                Value<String> module = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatSyncStatusCompanion(
                conversationId: conversationId,
                module: module,
                seq: seq,
                version: version,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String conversationId,
                required String module,
                Value<int> seq = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatSyncStatusCompanion.insert(
                conversationId: conversationId,
                module: module,
                seq: seq,
                version: version,
                updatedAt: updatedAt,
                rowid: rowid,
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
      Value<String?> nickName,
      Value<String?> avatar,
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
      Value<String?> nickName,
      Value<String?> avatar,
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

  ColumnFilters<String> get nickName => $composableBuilder(
    column: $table.nickName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
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

  ColumnOrderings<String> get nickName => $composableBuilder(
    column: $table.nickName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
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

  GeneratedColumn<String> get nickName =>
      $composableBuilder(column: $table.nickName, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

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
                Value<String?> nickName = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
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
                nickName: nickName,
                avatar: avatar,
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
                Value<String?> nickName = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
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
                nickName: nickName,
                avatar: avatar,
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
typedef $$EmojisTableCreateCompanionBuilder =
    EmojisCompanion Function({
      Value<int> id,
      required String emojiId,
      required String fileKey,
      required String title,
      Value<String?> emojiInfo,
      Value<int> status,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });
typedef $$EmojisTableUpdateCompanionBuilder =
    EmojisCompanion Function({
      Value<int> id,
      Value<String> emojiId,
      Value<String> fileKey,
      Value<String> title,
      Value<String?> emojiInfo,
      Value<int> status,
      Value<int> version,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });

class $$EmojisTableFilterComposer
    extends Composer<_$AppDatabase, $EmojisTable> {
  $$EmojisTableFilterComposer({
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

  ColumnFilters<String> get emojiId => $composableBuilder(
    column: $table.emojiId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileKey => $composableBuilder(
    column: $table.fileKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emojiInfo => $composableBuilder(
    column: $table.emojiInfo,
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

class $$EmojisTableOrderingComposer
    extends Composer<_$AppDatabase, $EmojisTable> {
  $$EmojisTableOrderingComposer({
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

  ColumnOrderings<String> get emojiId => $composableBuilder(
    column: $table.emojiId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileKey => $composableBuilder(
    column: $table.fileKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emojiInfo => $composableBuilder(
    column: $table.emojiInfo,
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

class $$EmojisTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmojisTable> {
  $$EmojisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get emojiId =>
      $composableBuilder(column: $table.emojiId, builder: (column) => column);

  GeneratedColumn<String> get fileKey =>
      $composableBuilder(column: $table.fileKey, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get emojiInfo =>
      $composableBuilder(column: $table.emojiInfo, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EmojisTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmojisTable,
          Emoji,
          $$EmojisTableFilterComposer,
          $$EmojisTableOrderingComposer,
          $$EmojisTableAnnotationComposer,
          $$EmojisTableCreateCompanionBuilder,
          $$EmojisTableUpdateCompanionBuilder,
          (Emoji, BaseReferences<_$AppDatabase, $EmojisTable, Emoji>),
          Emoji,
          PrefetchHooks Function()
        > {
  $$EmojisTableTableManager(_$AppDatabase db, $EmojisTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmojisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmojisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmojisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> emojiId = const Value.absent(),
                Value<String> fileKey = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> emojiInfo = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => EmojisCompanion(
                id: id,
                emojiId: emojiId,
                fileKey: fileKey,
                title: title,
                emojiInfo: emojiInfo,
                status: status,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String emojiId,
                required String fileKey,
                required String title,
                Value<String?> emojiInfo = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => EmojisCompanion.insert(
                id: id,
                emojiId: emojiId,
                fileKey: fileKey,
                title: title,
                emojiInfo: emojiInfo,
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

typedef $$EmojisTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmojisTable,
      Emoji,
      $$EmojisTableFilterComposer,
      $$EmojisTableOrderingComposer,
      $$EmojisTableAnnotationComposer,
      $$EmojisTableCreateCompanionBuilder,
      $$EmojisTableUpdateCompanionBuilder,
      (Emoji, BaseReferences<_$AppDatabase, $EmojisTable, Emoji>),
      Emoji,
      PrefetchHooks Function()
    >;
typedef $$EmojiCollectTableTableCreateCompanionBuilder =
    EmojiCollectTableCompanion Function({
      Value<int> id,
      required String emojiCollectId,
      required String userId,
      required String emojiId,
      Value<String?> packageId,
      Value<int> isDeleted,
      Value<int> version,
      Value<int> createdAt,
      Value<int> updatedAt,
    });
typedef $$EmojiCollectTableTableUpdateCompanionBuilder =
    EmojiCollectTableCompanion Function({
      Value<int> id,
      Value<String> emojiCollectId,
      Value<String> userId,
      Value<String> emojiId,
      Value<String?> packageId,
      Value<int> isDeleted,
      Value<int> version,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$EmojiCollectTableTableFilterComposer
    extends Composer<_$AppDatabase, $EmojiCollectTableTable> {
  $$EmojiCollectTableTableFilterComposer({
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

  ColumnFilters<String> get emojiCollectId => $composableBuilder(
    column: $table.emojiCollectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emojiId => $composableBuilder(
    column: $table.emojiId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageId => $composableBuilder(
    column: $table.packageId,
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

class $$EmojiCollectTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EmojiCollectTableTable> {
  $$EmojiCollectTableTableOrderingComposer({
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

  ColumnOrderings<String> get emojiCollectId => $composableBuilder(
    column: $table.emojiCollectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emojiId => $composableBuilder(
    column: $table.emojiId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageId => $composableBuilder(
    column: $table.packageId,
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

class $$EmojiCollectTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmojiCollectTableTable> {
  $$EmojiCollectTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get emojiCollectId => $composableBuilder(
    column: $table.emojiCollectId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get emojiId =>
      $composableBuilder(column: $table.emojiId, builder: (column) => column);

  GeneratedColumn<String> get packageId =>
      $composableBuilder(column: $table.packageId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EmojiCollectTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmojiCollectTableTable,
          EmojiCollectTableData,
          $$EmojiCollectTableTableFilterComposer,
          $$EmojiCollectTableTableOrderingComposer,
          $$EmojiCollectTableTableAnnotationComposer,
          $$EmojiCollectTableTableCreateCompanionBuilder,
          $$EmojiCollectTableTableUpdateCompanionBuilder,
          (
            EmojiCollectTableData,
            BaseReferences<
              _$AppDatabase,
              $EmojiCollectTableTable,
              EmojiCollectTableData
            >,
          ),
          EmojiCollectTableData,
          PrefetchHooks Function()
        > {
  $$EmojiCollectTableTableTableManager(
    _$AppDatabase db,
    $EmojiCollectTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmojiCollectTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmojiCollectTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmojiCollectTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> emojiCollectId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> emojiId = const Value.absent(),
                Value<String?> packageId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => EmojiCollectTableCompanion(
                id: id,
                emojiCollectId: emojiCollectId,
                userId: userId,
                emojiId: emojiId,
                packageId: packageId,
                isDeleted: isDeleted,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String emojiCollectId,
                required String userId,
                required String emojiId,
                Value<String?> packageId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => EmojiCollectTableCompanion.insert(
                id: id,
                emojiCollectId: emojiCollectId,
                userId: userId,
                emojiId: emojiId,
                packageId: packageId,
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

typedef $$EmojiCollectTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmojiCollectTableTable,
      EmojiCollectTableData,
      $$EmojiCollectTableTableFilterComposer,
      $$EmojiCollectTableTableOrderingComposer,
      $$EmojiCollectTableTableAnnotationComposer,
      $$EmojiCollectTableTableCreateCompanionBuilder,
      $$EmojiCollectTableTableUpdateCompanionBuilder,
      (
        EmojiCollectTableData,
        BaseReferences<
          _$AppDatabase,
          $EmojiCollectTableTable,
          EmojiCollectTableData
        >,
      ),
      EmojiCollectTableData,
      PrefetchHooks Function()
    >;
typedef $$EmojiPackageTableTableCreateCompanionBuilder =
    EmojiPackageTableCompanion Function({
      Value<int> id,
      required String packageId,
      required String title,
      Value<String?> coverFile,
      required String userId,
      Value<String?> description,
      required String type,
      Value<int> status,
      Value<int> version,
      Value<int> createdAt,
      Value<int> updatedAt,
    });
typedef $$EmojiPackageTableTableUpdateCompanionBuilder =
    EmojiPackageTableCompanion Function({
      Value<int> id,
      Value<String> packageId,
      Value<String> title,
      Value<String?> coverFile,
      Value<String> userId,
      Value<String?> description,
      Value<String> type,
      Value<int> status,
      Value<int> version,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$EmojiPackageTableTableFilterComposer
    extends Composer<_$AppDatabase, $EmojiPackageTableTable> {
  $$EmojiPackageTableTableFilterComposer({
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

  ColumnFilters<String> get packageId => $composableBuilder(
    column: $table.packageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverFile => $composableBuilder(
    column: $table.coverFile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
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

class $$EmojiPackageTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EmojiPackageTableTable> {
  $$EmojiPackageTableTableOrderingComposer({
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

  ColumnOrderings<String> get packageId => $composableBuilder(
    column: $table.packageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverFile => $composableBuilder(
    column: $table.coverFile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
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

class $$EmojiPackageTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmojiPackageTableTable> {
  $$EmojiPackageTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packageId =>
      $composableBuilder(column: $table.packageId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get coverFile =>
      $composableBuilder(column: $table.coverFile, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EmojiPackageTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmojiPackageTableTable,
          EmojiPackageTableData,
          $$EmojiPackageTableTableFilterComposer,
          $$EmojiPackageTableTableOrderingComposer,
          $$EmojiPackageTableTableAnnotationComposer,
          $$EmojiPackageTableTableCreateCompanionBuilder,
          $$EmojiPackageTableTableUpdateCompanionBuilder,
          (
            EmojiPackageTableData,
            BaseReferences<
              _$AppDatabase,
              $EmojiPackageTableTable,
              EmojiPackageTableData
            >,
          ),
          EmojiPackageTableData,
          PrefetchHooks Function()
        > {
  $$EmojiPackageTableTableTableManager(
    _$AppDatabase db,
    $EmojiPackageTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmojiPackageTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmojiPackageTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmojiPackageTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> packageId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> coverFile = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => EmojiPackageTableCompanion(
                id: id,
                packageId: packageId,
                title: title,
                coverFile: coverFile,
                userId: userId,
                description: description,
                type: type,
                status: status,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String packageId,
                required String title,
                Value<String?> coverFile = const Value.absent(),
                required String userId,
                Value<String?> description = const Value.absent(),
                required String type,
                Value<int> status = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => EmojiPackageTableCompanion.insert(
                id: id,
                packageId: packageId,
                title: title,
                coverFile: coverFile,
                userId: userId,
                description: description,
                type: type,
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

typedef $$EmojiPackageTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmojiPackageTableTable,
      EmojiPackageTableData,
      $$EmojiPackageTableTableFilterComposer,
      $$EmojiPackageTableTableOrderingComposer,
      $$EmojiPackageTableTableAnnotationComposer,
      $$EmojiPackageTableTableCreateCompanionBuilder,
      $$EmojiPackageTableTableUpdateCompanionBuilder,
      (
        EmojiPackageTableData,
        BaseReferences<
          _$AppDatabase,
          $EmojiPackageTableTable,
          EmojiPackageTableData
        >,
      ),
      EmojiPackageTableData,
      PrefetchHooks Function()
    >;
typedef $$EmojiPackageCollectTableTableCreateCompanionBuilder =
    EmojiPackageCollectTableCompanion Function({
      Value<int> id,
      required String packageCollectId,
      required String userId,
      required String packageId,
      Value<int> isDeleted,
      Value<int> version,
      Value<int> createdAt,
      Value<int> updatedAt,
    });
typedef $$EmojiPackageCollectTableTableUpdateCompanionBuilder =
    EmojiPackageCollectTableCompanion Function({
      Value<int> id,
      Value<String> packageCollectId,
      Value<String> userId,
      Value<String> packageId,
      Value<int> isDeleted,
      Value<int> version,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$EmojiPackageCollectTableTableFilterComposer
    extends Composer<_$AppDatabase, $EmojiPackageCollectTableTable> {
  $$EmojiPackageCollectTableTableFilterComposer({
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

  ColumnFilters<String> get packageCollectId => $composableBuilder(
    column: $table.packageCollectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageId => $composableBuilder(
    column: $table.packageId,
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

class $$EmojiPackageCollectTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EmojiPackageCollectTableTable> {
  $$EmojiPackageCollectTableTableOrderingComposer({
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

  ColumnOrderings<String> get packageCollectId => $composableBuilder(
    column: $table.packageCollectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageId => $composableBuilder(
    column: $table.packageId,
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

class $$EmojiPackageCollectTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmojiPackageCollectTableTable> {
  $$EmojiPackageCollectTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packageCollectId => $composableBuilder(
    column: $table.packageCollectId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get packageId =>
      $composableBuilder(column: $table.packageId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EmojiPackageCollectTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmojiPackageCollectTableTable,
          EmojiPackageCollectTableData,
          $$EmojiPackageCollectTableTableFilterComposer,
          $$EmojiPackageCollectTableTableOrderingComposer,
          $$EmojiPackageCollectTableTableAnnotationComposer,
          $$EmojiPackageCollectTableTableCreateCompanionBuilder,
          $$EmojiPackageCollectTableTableUpdateCompanionBuilder,
          (
            EmojiPackageCollectTableData,
            BaseReferences<
              _$AppDatabase,
              $EmojiPackageCollectTableTable,
              EmojiPackageCollectTableData
            >,
          ),
          EmojiPackageCollectTableData,
          PrefetchHooks Function()
        > {
  $$EmojiPackageCollectTableTableTableManager(
    _$AppDatabase db,
    $EmojiPackageCollectTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmojiPackageCollectTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EmojiPackageCollectTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EmojiPackageCollectTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> packageCollectId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> packageId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => EmojiPackageCollectTableCompanion(
                id: id,
                packageCollectId: packageCollectId,
                userId: userId,
                packageId: packageId,
                isDeleted: isDeleted,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String packageCollectId,
                required String userId,
                required String packageId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => EmojiPackageCollectTableCompanion.insert(
                id: id,
                packageCollectId: packageCollectId,
                userId: userId,
                packageId: packageId,
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

typedef $$EmojiPackageCollectTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmojiPackageCollectTableTable,
      EmojiPackageCollectTableData,
      $$EmojiPackageCollectTableTableFilterComposer,
      $$EmojiPackageCollectTableTableOrderingComposer,
      $$EmojiPackageCollectTableTableAnnotationComposer,
      $$EmojiPackageCollectTableTableCreateCompanionBuilder,
      $$EmojiPackageCollectTableTableUpdateCompanionBuilder,
      (
        EmojiPackageCollectTableData,
        BaseReferences<
          _$AppDatabase,
          $EmojiPackageCollectTableTable,
          EmojiPackageCollectTableData
        >,
      ),
      EmojiPackageCollectTableData,
      PrefetchHooks Function()
    >;
typedef $$EmojiPackageEmojiTableTableCreateCompanionBuilder =
    EmojiPackageEmojiTableCompanion Function({
      Value<int> id,
      required String relationId,
      required String packageId,
      required String emojiId,
      Value<int> sortOrder,
      Value<int> version,
      Value<int> createdAt,
      Value<int> updatedAt,
    });
typedef $$EmojiPackageEmojiTableTableUpdateCompanionBuilder =
    EmojiPackageEmojiTableCompanion Function({
      Value<int> id,
      Value<String> relationId,
      Value<String> packageId,
      Value<String> emojiId,
      Value<int> sortOrder,
      Value<int> version,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$EmojiPackageEmojiTableTableFilterComposer
    extends Composer<_$AppDatabase, $EmojiPackageEmojiTableTable> {
  $$EmojiPackageEmojiTableTableFilterComposer({
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

  ColumnFilters<String> get relationId => $composableBuilder(
    column: $table.relationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageId => $composableBuilder(
    column: $table.packageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emojiId => $composableBuilder(
    column: $table.emojiId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

class $$EmojiPackageEmojiTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EmojiPackageEmojiTableTable> {
  $$EmojiPackageEmojiTableTableOrderingComposer({
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

  ColumnOrderings<String> get relationId => $composableBuilder(
    column: $table.relationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageId => $composableBuilder(
    column: $table.packageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emojiId => $composableBuilder(
    column: $table.emojiId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

class $$EmojiPackageEmojiTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmojiPackageEmojiTableTable> {
  $$EmojiPackageEmojiTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get relationId => $composableBuilder(
    column: $table.relationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get packageId =>
      $composableBuilder(column: $table.packageId, builder: (column) => column);

  GeneratedColumn<String> get emojiId =>
      $composableBuilder(column: $table.emojiId, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EmojiPackageEmojiTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmojiPackageEmojiTableTable,
          EmojiPackageEmojiTableData,
          $$EmojiPackageEmojiTableTableFilterComposer,
          $$EmojiPackageEmojiTableTableOrderingComposer,
          $$EmojiPackageEmojiTableTableAnnotationComposer,
          $$EmojiPackageEmojiTableTableCreateCompanionBuilder,
          $$EmojiPackageEmojiTableTableUpdateCompanionBuilder,
          (
            EmojiPackageEmojiTableData,
            BaseReferences<
              _$AppDatabase,
              $EmojiPackageEmojiTableTable,
              EmojiPackageEmojiTableData
            >,
          ),
          EmojiPackageEmojiTableData,
          PrefetchHooks Function()
        > {
  $$EmojiPackageEmojiTableTableTableManager(
    _$AppDatabase db,
    $EmojiPackageEmojiTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmojiPackageEmojiTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EmojiPackageEmojiTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EmojiPackageEmojiTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> relationId = const Value.absent(),
                Value<String> packageId = const Value.absent(),
                Value<String> emojiId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => EmojiPackageEmojiTableCompanion(
                id: id,
                relationId: relationId,
                packageId: packageId,
                emojiId: emojiId,
                sortOrder: sortOrder,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String relationId,
                required String packageId,
                required String emojiId,
                Value<int> sortOrder = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => EmojiPackageEmojiTableCompanion.insert(
                id: id,
                relationId: relationId,
                packageId: packageId,
                emojiId: emojiId,
                sortOrder: sortOrder,
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

typedef $$EmojiPackageEmojiTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmojiPackageEmojiTableTable,
      EmojiPackageEmojiTableData,
      $$EmojiPackageEmojiTableTableFilterComposer,
      $$EmojiPackageEmojiTableTableOrderingComposer,
      $$EmojiPackageEmojiTableTableAnnotationComposer,
      $$EmojiPackageEmojiTableTableCreateCompanionBuilder,
      $$EmojiPackageEmojiTableTableUpdateCompanionBuilder,
      (
        EmojiPackageEmojiTableData,
        BaseReferences<
          _$AppDatabase,
          $EmojiPackageEmojiTableTable,
          EmojiPackageEmojiTableData
        >,
      ),
      EmojiPackageEmojiTableData,
      PrefetchHooks Function()
    >;
typedef $$MediaTableTableCreateCompanionBuilder =
    MediaTableCompanion Function({
      Value<int> id,
      required String fileKey,
      required String path,
      required String type,
      Value<int?> size,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> isDeleted,
    });
typedef $$MediaTableTableUpdateCompanionBuilder =
    MediaTableCompanion Function({
      Value<int> id,
      Value<String> fileKey,
      Value<String> path,
      Value<String> type,
      Value<int?> size,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> isDeleted,
    });

class $$MediaTableTableFilterComposer
    extends Composer<_$AppDatabase, $MediaTableTable> {
  $$MediaTableTableFilterComposer({
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

  ColumnFilters<String> get fileKey => $composableBuilder(
    column: $table.fileKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get size => $composableBuilder(
    column: $table.size,
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

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MediaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaTableTable> {
  $$MediaTableTableOrderingComposer({
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

  ColumnOrderings<String> get fileKey => $composableBuilder(
    column: $table.fileKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get size => $composableBuilder(
    column: $table.size,
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

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaTableTable> {
  $$MediaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileKey =>
      $composableBuilder(column: $table.fileKey, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$MediaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaTableTable,
          MediaTableData,
          $$MediaTableTableFilterComposer,
          $$MediaTableTableOrderingComposer,
          $$MediaTableTableAnnotationComposer,
          $$MediaTableTableCreateCompanionBuilder,
          $$MediaTableTableUpdateCompanionBuilder,
          (
            MediaTableData,
            BaseReferences<_$AppDatabase, $MediaTableTable, MediaTableData>,
          ),
          MediaTableData,
          PrefetchHooks Function()
        > {
  $$MediaTableTableTableManager(_$AppDatabase db, $MediaTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fileKey = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> size = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
              }) => MediaTableCompanion(
                id: id,
                fileKey: fileKey,
                path: path,
                type: type,
                size: size,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fileKey,
                required String path,
                required String type,
                Value<int?> size = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
              }) => MediaTableCompanion.insert(
                id: id,
                fileKey: fileKey,
                path: path,
                type: type,
                size: size,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MediaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaTableTable,
      MediaTableData,
      $$MediaTableTableFilterComposer,
      $$MediaTableTableOrderingComposer,
      $$MediaTableTableAnnotationComposer,
      $$MediaTableTableCreateCompanionBuilder,
      $$MediaTableTableUpdateCompanionBuilder,
      (
        MediaTableData,
        BaseReferences<_$AppDatabase, $MediaTableTable, MediaTableData>,
      ),
      MediaTableData,
      PrefetchHooks Function()
    >;
typedef $$NotificationEventsTableCreateCompanionBuilder =
    NotificationEventsCompanion Function({
      Value<int> id,
      required String eventId,
      required String eventType,
      required String category,
      Value<int> version,
      Value<String?> fromUserId,
      Value<String?> targetId,
      required String targetType,
      Value<String?> payload,
      Value<int> priority,
      Value<int> status,
      Value<String?> dedupHash,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });
typedef $$NotificationEventsTableUpdateCompanionBuilder =
    NotificationEventsCompanion Function({
      Value<int> id,
      Value<String> eventId,
      Value<String> eventType,
      Value<String> category,
      Value<int> version,
      Value<String?> fromUserId,
      Value<String?> targetId,
      Value<String> targetType,
      Value<String?> payload,
      Value<int> priority,
      Value<int> status,
      Value<String?> dedupHash,
      Value<int?> createdAt,
      Value<int?> updatedAt,
    });

class $$NotificationEventsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationEventsTable> {
  $$NotificationEventsTableFilterComposer({
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

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromUserId => $composableBuilder(
    column: $table.fromUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dedupHash => $composableBuilder(
    column: $table.dedupHash,
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

class $$NotificationEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationEventsTable> {
  $$NotificationEventsTableOrderingComposer({
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

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromUserId => $composableBuilder(
    column: $table.fromUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dedupHash => $composableBuilder(
    column: $table.dedupHash,
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

class $$NotificationEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationEventsTable> {
  $$NotificationEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get fromUserId => $composableBuilder(
    column: $table.fromUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get dedupHash =>
      $composableBuilder(column: $table.dedupHash, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotificationEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationEventsTable,
          NotificationEvent,
          $$NotificationEventsTableFilterComposer,
          $$NotificationEventsTableOrderingComposer,
          $$NotificationEventsTableAnnotationComposer,
          $$NotificationEventsTableCreateCompanionBuilder,
          $$NotificationEventsTableUpdateCompanionBuilder,
          (
            NotificationEvent,
            BaseReferences<
              _$AppDatabase,
              $NotificationEventsTable,
              NotificationEvent
            >,
          ),
          NotificationEvent,
          PrefetchHooks Function()
        > {
  $$NotificationEventsTableTableManager(
    _$AppDatabase db,
    $NotificationEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String?> fromUserId = const Value.absent(),
                Value<String?> targetId = const Value.absent(),
                Value<String> targetType = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> dedupHash = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => NotificationEventsCompanion(
                id: id,
                eventId: eventId,
                eventType: eventType,
                category: category,
                version: version,
                fromUserId: fromUserId,
                targetId: targetId,
                targetType: targetType,
                payload: payload,
                priority: priority,
                status: status,
                dedupHash: dedupHash,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String eventId,
                required String eventType,
                required String category,
                Value<int> version = const Value.absent(),
                Value<String?> fromUserId = const Value.absent(),
                Value<String?> targetId = const Value.absent(),
                required String targetType,
                Value<String?> payload = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> dedupHash = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
              }) => NotificationEventsCompanion.insert(
                id: id,
                eventId: eventId,
                eventType: eventType,
                category: category,
                version: version,
                fromUserId: fromUserId,
                targetId: targetId,
                targetType: targetType,
                payload: payload,
                priority: priority,
                status: status,
                dedupHash: dedupHash,
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

typedef $$NotificationEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationEventsTable,
      NotificationEvent,
      $$NotificationEventsTableFilterComposer,
      $$NotificationEventsTableOrderingComposer,
      $$NotificationEventsTableAnnotationComposer,
      $$NotificationEventsTableCreateCompanionBuilder,
      $$NotificationEventsTableUpdateCompanionBuilder,
      (
        NotificationEvent,
        BaseReferences<
          _$AppDatabase,
          $NotificationEventsTable,
          NotificationEvent
        >,
      ),
      NotificationEvent,
      PrefetchHooks Function()
    >;
typedef $$NotificationInboxTableTableCreateCompanionBuilder =
    NotificationInboxTableCompanion Function({
      Value<int> id,
      required String userId,
      required String eventId,
      required String eventType,
      required String category,
      Value<int> version,
      Value<int> isRead,
      Value<int?> readAt,
      Value<int> status,
      Value<int> isDeleted,
      Value<int> silent,
      Value<int> createdAt,
      Value<int> updatedAt,
    });
typedef $$NotificationInboxTableTableUpdateCompanionBuilder =
    NotificationInboxTableCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<String> eventId,
      Value<String> eventType,
      Value<String> category,
      Value<int> version,
      Value<int> isRead,
      Value<int?> readAt,
      Value<int> status,
      Value<int> isDeleted,
      Value<int> silent,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$NotificationInboxTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationInboxTableTable> {
  $$NotificationInboxTableTableFilterComposer({
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

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get silent => $composableBuilder(
    column: $table.silent,
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

class $$NotificationInboxTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationInboxTableTable> {
  $$NotificationInboxTableTableOrderingComposer({
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

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get silent => $composableBuilder(
    column: $table.silent,
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

class $$NotificationInboxTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationInboxTableTable> {
  $$NotificationInboxTableTableAnnotationComposer({
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

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<int> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get silent =>
      $composableBuilder(column: $table.silent, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotificationInboxTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationInboxTableTable,
          NotificationInboxTableData,
          $$NotificationInboxTableTableFilterComposer,
          $$NotificationInboxTableTableOrderingComposer,
          $$NotificationInboxTableTableAnnotationComposer,
          $$NotificationInboxTableTableCreateCompanionBuilder,
          $$NotificationInboxTableTableUpdateCompanionBuilder,
          (
            NotificationInboxTableData,
            BaseReferences<
              _$AppDatabase,
              $NotificationInboxTableTable,
              NotificationInboxTableData
            >,
          ),
          NotificationInboxTableData,
          PrefetchHooks Function()
        > {
  $$NotificationInboxTableTableTableManager(
    _$AppDatabase db,
    $NotificationInboxTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationInboxTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$NotificationInboxTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationInboxTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> isRead = const Value.absent(),
                Value<int?> readAt = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> silent = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => NotificationInboxTableCompanion(
                id: id,
                userId: userId,
                eventId: eventId,
                eventType: eventType,
                category: category,
                version: version,
                isRead: isRead,
                readAt: readAt,
                status: status,
                isDeleted: isDeleted,
                silent: silent,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required String eventId,
                required String eventType,
                required String category,
                Value<int> version = const Value.absent(),
                Value<int> isRead = const Value.absent(),
                Value<int?> readAt = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> silent = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => NotificationInboxTableCompanion.insert(
                id: id,
                userId: userId,
                eventId: eventId,
                eventType: eventType,
                category: category,
                version: version,
                isRead: isRead,
                readAt: readAt,
                status: status,
                isDeleted: isDeleted,
                silent: silent,
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

typedef $$NotificationInboxTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationInboxTableTable,
      NotificationInboxTableData,
      $$NotificationInboxTableTableFilterComposer,
      $$NotificationInboxTableTableOrderingComposer,
      $$NotificationInboxTableTableAnnotationComposer,
      $$NotificationInboxTableTableCreateCompanionBuilder,
      $$NotificationInboxTableTableUpdateCompanionBuilder,
      (
        NotificationInboxTableData,
        BaseReferences<
          _$AppDatabase,
          $NotificationInboxTableTable,
          NotificationInboxTableData
        >,
      ),
      NotificationInboxTableData,
      PrefetchHooks Function()
    >;
typedef $$NotificationReadTableTableCreateCompanionBuilder =
    NotificationReadTableCompanion Function({
      Value<int> id,
      required String userId,
      required String category,
      Value<int> version,
      Value<int?> lastReadAt,
      Value<int> createdAt,
      Value<int> updatedAt,
    });
typedef $$NotificationReadTableTableUpdateCompanionBuilder =
    NotificationReadTableCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<String> category,
      Value<int> version,
      Value<int?> lastReadAt,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$NotificationReadTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationReadTableTable> {
  $$NotificationReadTableTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
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

class $$NotificationReadTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationReadTableTable> {
  $$NotificationReadTableTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
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

class $$NotificationReadTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationReadTableTable> {
  $$NotificationReadTableTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotificationReadTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationReadTableTable,
          NotificationReadTableData,
          $$NotificationReadTableTableFilterComposer,
          $$NotificationReadTableTableOrderingComposer,
          $$NotificationReadTableTableAnnotationComposer,
          $$NotificationReadTableTableCreateCompanionBuilder,
          $$NotificationReadTableTableUpdateCompanionBuilder,
          (
            NotificationReadTableData,
            BaseReferences<
              _$AppDatabase,
              $NotificationReadTableTable,
              NotificationReadTableData
            >,
          ),
          NotificationReadTableData,
          PrefetchHooks Function()
        > {
  $$NotificationReadTableTableTableManager(
    _$AppDatabase db,
    $NotificationReadTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationReadTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$NotificationReadTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationReadTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> lastReadAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => NotificationReadTableCompanion(
                id: id,
                userId: userId,
                category: category,
                version: version,
                lastReadAt: lastReadAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required String category,
                Value<int> version = const Value.absent(),
                Value<int?> lastReadAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => NotificationReadTableCompanion.insert(
                id: id,
                userId: userId,
                category: category,
                version: version,
                lastReadAt: lastReadAt,
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

typedef $$NotificationReadTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationReadTableTable,
      NotificationReadTableData,
      $$NotificationReadTableTableFilterComposer,
      $$NotificationReadTableTableOrderingComposer,
      $$NotificationReadTableTableAnnotationComposer,
      $$NotificationReadTableTableCreateCompanionBuilder,
      $$NotificationReadTableTableUpdateCompanionBuilder,
      (
        NotificationReadTableData,
        BaseReferences<
          _$AppDatabase,
          $NotificationReadTableTable,
          NotificationReadTableData
        >,
      ),
      NotificationReadTableData,
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
  $$EmojisTableTableManager get emojis =>
      $$EmojisTableTableManager(_db, _db.emojis);
  $$EmojiCollectTableTableTableManager get emojiCollectTable =>
      $$EmojiCollectTableTableTableManager(_db, _db.emojiCollectTable);
  $$EmojiPackageTableTableTableManager get emojiPackageTable =>
      $$EmojiPackageTableTableTableManager(_db, _db.emojiPackageTable);
  $$EmojiPackageCollectTableTableTableManager get emojiPackageCollectTable =>
      $$EmojiPackageCollectTableTableTableManager(
        _db,
        _db.emojiPackageCollectTable,
      );
  $$EmojiPackageEmojiTableTableTableManager get emojiPackageEmojiTable =>
      $$EmojiPackageEmojiTableTableTableManager(
        _db,
        _db.emojiPackageEmojiTable,
      );
  $$MediaTableTableTableManager get mediaTable =>
      $$MediaTableTableTableManager(_db, _db.mediaTable);
  $$NotificationEventsTableTableManager get notificationEvents =>
      $$NotificationEventsTableTableManager(_db, _db.notificationEvents);
  $$NotificationInboxTableTableTableManager get notificationInboxTable =>
      $$NotificationInboxTableTableTableManager(
        _db,
        _db.notificationInboxTable,
      );
  $$NotificationReadTableTableTableManager get notificationReadTable =>
      $$NotificationReadTableTableTableManager(_db, _db.notificationReadTable);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LevelsTable extends Levels with TableInfo<$LevelsTable, Level> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _levelIDMeta =
      const VerificationMeta('levelID');
  @override
  late final GeneratedColumn<int> levelID = GeneratedColumn<int>(
      'level_i_d', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _cachedTitleMeta =
      const VerificationMeta('cachedTitle');
  @override
  late final GeneratedColumn<String> cachedTitle = GeneratedColumn<String>(
      'cached_title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cachedVersionMeta =
      const VerificationMeta('cachedVersion');
  @override
  late final GeneratedColumn<int> cachedVersion = GeneratedColumn<int>(
      'cached_version', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cachedStarsMeta =
      const VerificationMeta('cachedStars');
  @override
  late final GeneratedColumn<int> cachedStars = GeneratedColumn<int>(
      'cached_stars', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastCacheUpdateAtMeta =
      const VerificationMeta('lastCacheUpdateAt');
  @override
  late final GeneratedColumn<DateTime> lastCacheUpdateAt =
      GeneratedColumn<DateTime>('last_cache_update_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _accessesMeta =
      const VerificationMeta('accesses');
  @override
  late final GeneratedColumn<int> accesses = GeneratedColumn<int>(
      'accesses', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        levelID,
        cachedTitle,
        cachedVersion,
        cachedStars,
        lastCacheUpdateAt,
        accesses
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'levels';
  @override
  VerificationContext validateIntegrity(Insertable<Level> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('level_i_d')) {
      context.handle(_levelIDMeta,
          levelID.isAcceptableOrUnknown(data['level_i_d']!, _levelIDMeta));
    } else if (isInserting) {
      context.missing(_levelIDMeta);
    }
    if (data.containsKey('cached_title')) {
      context.handle(
          _cachedTitleMeta,
          cachedTitle.isAcceptableOrUnknown(
              data['cached_title']!, _cachedTitleMeta));
    } else if (isInserting) {
      context.missing(_cachedTitleMeta);
    }
    if (data.containsKey('cached_version')) {
      context.handle(
          _cachedVersionMeta,
          cachedVersion.isAcceptableOrUnknown(
              data['cached_version']!, _cachedVersionMeta));
    }
    if (data.containsKey('cached_stars')) {
      context.handle(
          _cachedStarsMeta,
          cachedStars.isAcceptableOrUnknown(
              data['cached_stars']!, _cachedStarsMeta));
    }
    if (data.containsKey('last_cache_update_at')) {
      context.handle(
          _lastCacheUpdateAtMeta,
          lastCacheUpdateAt.isAcceptableOrUnknown(
              data['last_cache_update_at']!, _lastCacheUpdateAtMeta));
    } else if (isInserting) {
      context.missing(_lastCacheUpdateAtMeta);
    }
    if (data.containsKey('accesses')) {
      context.handle(_accessesMeta,
          accesses.isAcceptableOrUnknown(data['accesses']!, _accessesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Level map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Level(
      levelID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level_i_d'])!,
      cachedTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cached_title'])!,
      cachedVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cached_version']),
      cachedStars: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cached_stars']),
      lastCacheUpdateAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_cache_update_at'])!,
      accesses: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}accesses'])!,
    );
  }

  @override
  $LevelsTable createAlias(String alias) {
    return $LevelsTable(attachedDatabase, alias);
  }
}

class Level extends DataClass implements Insertable<Level> {
  final int levelID;
  final String cachedTitle;
  final int? cachedVersion;
  final int? cachedStars;
  final DateTime lastCacheUpdateAt;
  final int accesses;
  const Level(
      {required this.levelID,
      required this.cachedTitle,
      this.cachedVersion,
      this.cachedStars,
      required this.lastCacheUpdateAt,
      required this.accesses});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['level_i_d'] = Variable<int>(levelID);
    map['cached_title'] = Variable<String>(cachedTitle);
    if (!nullToAbsent || cachedVersion != null) {
      map['cached_version'] = Variable<int>(cachedVersion);
    }
    if (!nullToAbsent || cachedStars != null) {
      map['cached_stars'] = Variable<int>(cachedStars);
    }
    map['last_cache_update_at'] = Variable<DateTime>(lastCacheUpdateAt);
    map['accesses'] = Variable<int>(accesses);
    return map;
  }

  LevelsCompanion toCompanion(bool nullToAbsent) {
    return LevelsCompanion(
      levelID: Value(levelID),
      cachedTitle: Value(cachedTitle),
      cachedVersion: cachedVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(cachedVersion),
      cachedStars: cachedStars == null && nullToAbsent
          ? const Value.absent()
          : Value(cachedStars),
      lastCacheUpdateAt: Value(lastCacheUpdateAt),
      accesses: Value(accesses),
    );
  }

  factory Level.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Level(
      levelID: serializer.fromJson<int>(json['levelID']),
      cachedTitle: serializer.fromJson<String>(json['cachedTitle']),
      cachedVersion: serializer.fromJson<int?>(json['cachedVersion']),
      cachedStars: serializer.fromJson<int?>(json['cachedStars']),
      lastCacheUpdateAt:
          serializer.fromJson<DateTime>(json['lastCacheUpdateAt']),
      accesses: serializer.fromJson<int>(json['accesses']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'levelID': serializer.toJson<int>(levelID),
      'cachedTitle': serializer.toJson<String>(cachedTitle),
      'cachedVersion': serializer.toJson<int?>(cachedVersion),
      'cachedStars': serializer.toJson<int?>(cachedStars),
      'lastCacheUpdateAt': serializer.toJson<DateTime>(lastCacheUpdateAt),
      'accesses': serializer.toJson<int>(accesses),
    };
  }

  Level copyWith(
          {int? levelID,
          String? cachedTitle,
          Value<int?> cachedVersion = const Value.absent(),
          Value<int?> cachedStars = const Value.absent(),
          DateTime? lastCacheUpdateAt,
          int? accesses}) =>
      Level(
        levelID: levelID ?? this.levelID,
        cachedTitle: cachedTitle ?? this.cachedTitle,
        cachedVersion:
            cachedVersion.present ? cachedVersion.value : this.cachedVersion,
        cachedStars: cachedStars.present ? cachedStars.value : this.cachedStars,
        lastCacheUpdateAt: lastCacheUpdateAt ?? this.lastCacheUpdateAt,
        accesses: accesses ?? this.accesses,
      );
  Level copyWithCompanion(LevelsCompanion data) {
    return Level(
      levelID: data.levelID.present ? data.levelID.value : this.levelID,
      cachedTitle:
          data.cachedTitle.present ? data.cachedTitle.value : this.cachedTitle,
      cachedVersion: data.cachedVersion.present
          ? data.cachedVersion.value
          : this.cachedVersion,
      cachedStars:
          data.cachedStars.present ? data.cachedStars.value : this.cachedStars,
      lastCacheUpdateAt: data.lastCacheUpdateAt.present
          ? data.lastCacheUpdateAt.value
          : this.lastCacheUpdateAt,
      accesses: data.accesses.present ? data.accesses.value : this.accesses,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Level(')
          ..write('levelID: $levelID, ')
          ..write('cachedTitle: $cachedTitle, ')
          ..write('cachedVersion: $cachedVersion, ')
          ..write('cachedStars: $cachedStars, ')
          ..write('lastCacheUpdateAt: $lastCacheUpdateAt, ')
          ..write('accesses: $accesses')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(levelID, cachedTitle, cachedVersion,
      cachedStars, lastCacheUpdateAt, accesses);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Level &&
          other.levelID == this.levelID &&
          other.cachedTitle == this.cachedTitle &&
          other.cachedVersion == this.cachedVersion &&
          other.cachedStars == this.cachedStars &&
          other.lastCacheUpdateAt == this.lastCacheUpdateAt &&
          other.accesses == this.accesses);
}

class LevelsCompanion extends UpdateCompanion<Level> {
  final Value<int> levelID;
  final Value<String> cachedTitle;
  final Value<int?> cachedVersion;
  final Value<int?> cachedStars;
  final Value<DateTime> lastCacheUpdateAt;
  final Value<int> accesses;
  final Value<int> rowid;
  const LevelsCompanion({
    this.levelID = const Value.absent(),
    this.cachedTitle = const Value.absent(),
    this.cachedVersion = const Value.absent(),
    this.cachedStars = const Value.absent(),
    this.lastCacheUpdateAt = const Value.absent(),
    this.accesses = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LevelsCompanion.insert({
    required int levelID,
    required String cachedTitle,
    this.cachedVersion = const Value.absent(),
    this.cachedStars = const Value.absent(),
    required DateTime lastCacheUpdateAt,
    this.accesses = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : levelID = Value(levelID),
        cachedTitle = Value(cachedTitle),
        lastCacheUpdateAt = Value(lastCacheUpdateAt);
  static Insertable<Level> custom({
    Expression<int>? levelID,
    Expression<String>? cachedTitle,
    Expression<int>? cachedVersion,
    Expression<int>? cachedStars,
    Expression<DateTime>? lastCacheUpdateAt,
    Expression<int>? accesses,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (levelID != null) 'level_i_d': levelID,
      if (cachedTitle != null) 'cached_title': cachedTitle,
      if (cachedVersion != null) 'cached_version': cachedVersion,
      if (cachedStars != null) 'cached_stars': cachedStars,
      if (lastCacheUpdateAt != null) 'last_cache_update_at': lastCacheUpdateAt,
      if (accesses != null) 'accesses': accesses,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LevelsCompanion copyWith(
      {Value<int>? levelID,
      Value<String>? cachedTitle,
      Value<int?>? cachedVersion,
      Value<int?>? cachedStars,
      Value<DateTime>? lastCacheUpdateAt,
      Value<int>? accesses,
      Value<int>? rowid}) {
    return LevelsCompanion(
      levelID: levelID ?? this.levelID,
      cachedTitle: cachedTitle ?? this.cachedTitle,
      cachedVersion: cachedVersion ?? this.cachedVersion,
      cachedStars: cachedStars ?? this.cachedStars,
      lastCacheUpdateAt: lastCacheUpdateAt ?? this.lastCacheUpdateAt,
      accesses: accesses ?? this.accesses,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (levelID.present) {
      map['level_i_d'] = Variable<int>(levelID.value);
    }
    if (cachedTitle.present) {
      map['cached_title'] = Variable<String>(cachedTitle.value);
    }
    if (cachedVersion.present) {
      map['cached_version'] = Variable<int>(cachedVersion.value);
    }
    if (cachedStars.present) {
      map['cached_stars'] = Variable<int>(cachedStars.value);
    }
    if (lastCacheUpdateAt.present) {
      map['last_cache_update_at'] = Variable<DateTime>(lastCacheUpdateAt.value);
    }
    if (accesses.present) {
      map['accesses'] = Variable<int>(accesses.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelsCompanion(')
          ..write('levelID: $levelID, ')
          ..write('cachedTitle: $cachedTitle, ')
          ..write('cachedVersion: $cachedVersion, ')
          ..write('cachedStars: $cachedStars, ')
          ..write('lastCacheUpdateAt: $lastCacheUpdateAt, ')
          ..write('accesses: $accesses, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIDMeta =
      const VerificationMeta('accountID');
  @override
  late final GeneratedColumn<int> accountID = GeneratedColumn<int>(
      'account_i_d', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _cachedUsernameMeta =
      const VerificationMeta('cachedUsername');
  @override
  late final GeneratedColumn<String> cachedUsername = GeneratedColumn<String>(
      'cached_username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _badPointsMeta =
      const VerificationMeta('badPoints');
  @override
  late final GeneratedColumn<int> badPoints = GeneratedColumn<int>(
      'bad_points', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _badPointsLogMeta =
      const VerificationMeta('badPointsLog');
  @override
  late final GeneratedColumn<String> badPointsLog = GeneratedColumn<String>(
      'bad_points_log', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastCacheUpdateAtMeta =
      const VerificationMeta('lastCacheUpdateAt');
  @override
  late final GeneratedColumn<DateTime> lastCacheUpdateAt =
      GeneratedColumn<DateTime>('last_cache_update_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [accountID, cachedUsername, badPoints, badPointsLog, lastCacheUpdateAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_i_d')) {
      context.handle(
          _accountIDMeta,
          accountID.isAcceptableOrUnknown(
              data['account_i_d']!, _accountIDMeta));
    } else if (isInserting) {
      context.missing(_accountIDMeta);
    }
    if (data.containsKey('cached_username')) {
      context.handle(
          _cachedUsernameMeta,
          cachedUsername.isAcceptableOrUnknown(
              data['cached_username']!, _cachedUsernameMeta));
    } else if (isInserting) {
      context.missing(_cachedUsernameMeta);
    }
    if (data.containsKey('bad_points')) {
      context.handle(_badPointsMeta,
          badPoints.isAcceptableOrUnknown(data['bad_points']!, _badPointsMeta));
    } else if (isInserting) {
      context.missing(_badPointsMeta);
    }
    if (data.containsKey('bad_points_log')) {
      context.handle(
          _badPointsLogMeta,
          badPointsLog.isAcceptableOrUnknown(
              data['bad_points_log']!, _badPointsLogMeta));
    } else if (isInserting) {
      context.missing(_badPointsLogMeta);
    }
    if (data.containsKey('last_cache_update_at')) {
      context.handle(
          _lastCacheUpdateAtMeta,
          lastCacheUpdateAt.isAcceptableOrUnknown(
              data['last_cache_update_at']!, _lastCacheUpdateAtMeta));
    } else if (isInserting) {
      context.missing(_lastCacheUpdateAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      accountID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_i_d'])!,
      cachedUsername: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cached_username'])!,
      badPoints: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bad_points'])!,
      badPointsLog: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bad_points_log'])!,
      lastCacheUpdateAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_cache_update_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int accountID;
  final String cachedUsername;
  final int badPoints;
  final String badPointsLog;
  final DateTime lastCacheUpdateAt;
  const User(
      {required this.accountID,
      required this.cachedUsername,
      required this.badPoints,
      required this.badPointsLog,
      required this.lastCacheUpdateAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_i_d'] = Variable<int>(accountID);
    map['cached_username'] = Variable<String>(cachedUsername);
    map['bad_points'] = Variable<int>(badPoints);
    map['bad_points_log'] = Variable<String>(badPointsLog);
    map['last_cache_update_at'] = Variable<DateTime>(lastCacheUpdateAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      accountID: Value(accountID),
      cachedUsername: Value(cachedUsername),
      badPoints: Value(badPoints),
      badPointsLog: Value(badPointsLog),
      lastCacheUpdateAt: Value(lastCacheUpdateAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      accountID: serializer.fromJson<int>(json['accountID']),
      cachedUsername: serializer.fromJson<String>(json['cachedUsername']),
      badPoints: serializer.fromJson<int>(json['badPoints']),
      badPointsLog: serializer.fromJson<String>(json['badPointsLog']),
      lastCacheUpdateAt:
          serializer.fromJson<DateTime>(json['lastCacheUpdateAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountID': serializer.toJson<int>(accountID),
      'cachedUsername': serializer.toJson<String>(cachedUsername),
      'badPoints': serializer.toJson<int>(badPoints),
      'badPointsLog': serializer.toJson<String>(badPointsLog),
      'lastCacheUpdateAt': serializer.toJson<DateTime>(lastCacheUpdateAt),
    };
  }

  User copyWith(
          {int? accountID,
          String? cachedUsername,
          int? badPoints,
          String? badPointsLog,
          DateTime? lastCacheUpdateAt}) =>
      User(
        accountID: accountID ?? this.accountID,
        cachedUsername: cachedUsername ?? this.cachedUsername,
        badPoints: badPoints ?? this.badPoints,
        badPointsLog: badPointsLog ?? this.badPointsLog,
        lastCacheUpdateAt: lastCacheUpdateAt ?? this.lastCacheUpdateAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      accountID: data.accountID.present ? data.accountID.value : this.accountID,
      cachedUsername: data.cachedUsername.present
          ? data.cachedUsername.value
          : this.cachedUsername,
      badPoints: data.badPoints.present ? data.badPoints.value : this.badPoints,
      badPointsLog: data.badPointsLog.present
          ? data.badPointsLog.value
          : this.badPointsLog,
      lastCacheUpdateAt: data.lastCacheUpdateAt.present
          ? data.lastCacheUpdateAt.value
          : this.lastCacheUpdateAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('accountID: $accountID, ')
          ..write('cachedUsername: $cachedUsername, ')
          ..write('badPoints: $badPoints, ')
          ..write('badPointsLog: $badPointsLog, ')
          ..write('lastCacheUpdateAt: $lastCacheUpdateAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      accountID, cachedUsername, badPoints, badPointsLog, lastCacheUpdateAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.accountID == this.accountID &&
          other.cachedUsername == this.cachedUsername &&
          other.badPoints == this.badPoints &&
          other.badPointsLog == this.badPointsLog &&
          other.lastCacheUpdateAt == this.lastCacheUpdateAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> accountID;
  final Value<String> cachedUsername;
  final Value<int> badPoints;
  final Value<String> badPointsLog;
  final Value<DateTime> lastCacheUpdateAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.accountID = const Value.absent(),
    this.cachedUsername = const Value.absent(),
    this.badPoints = const Value.absent(),
    this.badPointsLog = const Value.absent(),
    this.lastCacheUpdateAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required int accountID,
    required String cachedUsername,
    required int badPoints,
    required String badPointsLog,
    required DateTime lastCacheUpdateAt,
    this.rowid = const Value.absent(),
  })  : accountID = Value(accountID),
        cachedUsername = Value(cachedUsername),
        badPoints = Value(badPoints),
        badPointsLog = Value(badPointsLog),
        lastCacheUpdateAt = Value(lastCacheUpdateAt);
  static Insertable<User> custom({
    Expression<int>? accountID,
    Expression<String>? cachedUsername,
    Expression<int>? badPoints,
    Expression<String>? badPointsLog,
    Expression<DateTime>? lastCacheUpdateAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountID != null) 'account_i_d': accountID,
      if (cachedUsername != null) 'cached_username': cachedUsername,
      if (badPoints != null) 'bad_points': badPoints,
      if (badPointsLog != null) 'bad_points_log': badPointsLog,
      if (lastCacheUpdateAt != null) 'last_cache_update_at': lastCacheUpdateAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? accountID,
      Value<String>? cachedUsername,
      Value<int>? badPoints,
      Value<String>? badPointsLog,
      Value<DateTime>? lastCacheUpdateAt,
      Value<int>? rowid}) {
    return UsersCompanion(
      accountID: accountID ?? this.accountID,
      cachedUsername: cachedUsername ?? this.cachedUsername,
      badPoints: badPoints ?? this.badPoints,
      badPointsLog: badPointsLog ?? this.badPointsLog,
      lastCacheUpdateAt: lastCacheUpdateAt ?? this.lastCacheUpdateAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountID.present) {
      map['account_i_d'] = Variable<int>(accountID.value);
    }
    if (cachedUsername.present) {
      map['cached_username'] = Variable<String>(cachedUsername.value);
    }
    if (badPoints.present) {
      map['bad_points'] = Variable<int>(badPoints.value);
    }
    if (badPointsLog.present) {
      map['bad_points_log'] = Variable<String>(badPointsLog.value);
    }
    if (lastCacheUpdateAt.present) {
      map['last_cache_update_at'] = Variable<DateTime>(lastCacheUpdateAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('accountID: $accountID, ')
          ..write('cachedUsername: $cachedUsername, ')
          ..write('badPoints: $badPoints, ')
          ..write('badPointsLog: $badPointsLog, ')
          ..write('lastCacheUpdateAt: $lastCacheUpdateAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubmissionsTable extends Submissions
    with TableInfo<$SubmissionsTable, Submission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubmissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _levelIDMeta =
      const VerificationMeta('levelID');
  @override
  late final GeneratedColumn<int> levelID = GeneratedColumn<int>(
      'level_i_d', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES levels (level_i_d)'));
  static const VerificationMeta _levelVersionMeta =
      const VerificationMeta('levelVersion');
  @override
  late final GeneratedColumn<int> levelVersion = GeneratedColumn<int>(
      'level_version', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<SubmissionStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<SubmissionStatus>($SubmissionsTable.$converterstatus);
  static const VerificationMeta _replayHashMeta =
      const VerificationMeta('replayHash');
  @override
  late final GeneratedColumn<Uint8List> replayHash = GeneratedColumn<Uint8List>(
      'replay_hash', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _replayDataMeta =
      const VerificationMeta('replayData');
  @override
  late final GeneratedColumn<Uint8List> replayData = GeneratedColumn<Uint8List>(
      'replay_data', aliasedName, true,
      type: DriftSqlType.blob, requiredDuringInsert: false);
  static const VerificationMeta _modVersionMeta =
      const VerificationMeta('modVersion');
  @override
  late final GeneratedColumn<String> modVersion = GeneratedColumn<String>(
      'mod_version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gdVersionMeta =
      const VerificationMeta('gdVersion');
  @override
  late final GeneratedColumn<String> gdVersion = GeneratedColumn<String>(
      'gd_version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gdAccountIDMeta =
      const VerificationMeta('gdAccountID');
  @override
  late final GeneratedColumn<int> gdAccountID = GeneratedColumn<int>(
      'gd_account_i_d', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (account_i_d)'));
  static const VerificationMeta _rejectionReasonMeta =
      const VerificationMeta('rejectionReason');
  @override
  late final GeneratedColumn<String> rejectionReason = GeneratedColumn<String>(
      'rejection_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reviewedAtMeta =
      const VerificationMeta('reviewedAt');
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
      'reviewed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _submittedAtMeta =
      const VerificationMeta('submittedAt');
  @override
  late final GeneratedColumn<DateTime> submittedAt = GeneratedColumn<DateTime>(
      'submitted_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        levelID,
        levelVersion,
        status,
        replayHash,
        replayData,
        modVersion,
        gdVersion,
        gdAccountID,
        rejectionReason,
        reviewedAt,
        submittedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'submissions';
  @override
  VerificationContext validateIntegrity(Insertable<Submission> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level_i_d')) {
      context.handle(_levelIDMeta,
          levelID.isAcceptableOrUnknown(data['level_i_d']!, _levelIDMeta));
    } else if (isInserting) {
      context.missing(_levelIDMeta);
    }
    if (data.containsKey('level_version')) {
      context.handle(
          _levelVersionMeta,
          levelVersion.isAcceptableOrUnknown(
              data['level_version']!, _levelVersionMeta));
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('replay_hash')) {
      context.handle(
          _replayHashMeta,
          replayHash.isAcceptableOrUnknown(
              data['replay_hash']!, _replayHashMeta));
    } else if (isInserting) {
      context.missing(_replayHashMeta);
    }
    if (data.containsKey('replay_data')) {
      context.handle(
          _replayDataMeta,
          replayData.isAcceptableOrUnknown(
              data['replay_data']!, _replayDataMeta));
    }
    if (data.containsKey('mod_version')) {
      context.handle(
          _modVersionMeta,
          modVersion.isAcceptableOrUnknown(
              data['mod_version']!, _modVersionMeta));
    } else if (isInserting) {
      context.missing(_modVersionMeta);
    }
    if (data.containsKey('gd_version')) {
      context.handle(_gdVersionMeta,
          gdVersion.isAcceptableOrUnknown(data['gd_version']!, _gdVersionMeta));
    } else if (isInserting) {
      context.missing(_gdVersionMeta);
    }
    if (data.containsKey('gd_account_i_d')) {
      context.handle(
          _gdAccountIDMeta,
          gdAccountID.isAcceptableOrUnknown(
              data['gd_account_i_d']!, _gdAccountIDMeta));
    } else if (isInserting) {
      context.missing(_gdAccountIDMeta);
    }
    if (data.containsKey('rejection_reason')) {
      context.handle(
          _rejectionReasonMeta,
          rejectionReason.isAcceptableOrUnknown(
              data['rejection_reason']!, _rejectionReasonMeta));
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
          _reviewedAtMeta,
          reviewedAt.isAcceptableOrUnknown(
              data['reviewed_at']!, _reviewedAtMeta));
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
          _submittedAtMeta,
          submittedAt.isAcceptableOrUnknown(
              data['submitted_at']!, _submittedAtMeta));
    } else if (isInserting) {
      context.missing(_submittedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Submission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Submission(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      levelID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level_i_d'])!,
      levelVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level_version']),
      status: $SubmissionsTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      replayHash: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}replay_hash'])!,
      replayData: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}replay_data']),
      modVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mod_version'])!,
      gdVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gd_version'])!,
      gdAccountID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gd_account_i_d'])!,
      rejectionReason: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}rejection_reason']),
      reviewedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reviewed_at']),
      submittedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}submitted_at'])!,
    );
  }

  @override
  $SubmissionsTable createAlias(String alias) {
    return $SubmissionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SubmissionStatus, int, int> $converterstatus =
      const EnumIndexConverter<SubmissionStatus>(SubmissionStatus.values);
}

class Submission extends DataClass implements Insertable<Submission> {
  final int id;
  final int levelID;
  final int? levelVersion;
  final SubmissionStatus status;
  final Uint8List replayHash;
  final Uint8List? replayData;
  final String modVersion;
  final String gdVersion;
  final int gdAccountID;
  final String? rejectionReason;
  final DateTime? reviewedAt;
  final DateTime submittedAt;
  const Submission(
      {required this.id,
      required this.levelID,
      this.levelVersion,
      required this.status,
      required this.replayHash,
      this.replayData,
      required this.modVersion,
      required this.gdVersion,
      required this.gdAccountID,
      this.rejectionReason,
      this.reviewedAt,
      required this.submittedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level_i_d'] = Variable<int>(levelID);
    if (!nullToAbsent || levelVersion != null) {
      map['level_version'] = Variable<int>(levelVersion);
    }
    {
      map['status'] =
          Variable<int>($SubmissionsTable.$converterstatus.toSql(status));
    }
    map['replay_hash'] = Variable<Uint8List>(replayHash);
    if (!nullToAbsent || replayData != null) {
      map['replay_data'] = Variable<Uint8List>(replayData);
    }
    map['mod_version'] = Variable<String>(modVersion);
    map['gd_version'] = Variable<String>(gdVersion);
    map['gd_account_i_d'] = Variable<int>(gdAccountID);
    if (!nullToAbsent || rejectionReason != null) {
      map['rejection_reason'] = Variable<String>(rejectionReason);
    }
    if (!nullToAbsent || reviewedAt != null) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    }
    map['submitted_at'] = Variable<DateTime>(submittedAt);
    return map;
  }

  SubmissionsCompanion toCompanion(bool nullToAbsent) {
    return SubmissionsCompanion(
      id: Value(id),
      levelID: Value(levelID),
      levelVersion: levelVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(levelVersion),
      status: Value(status),
      replayHash: Value(replayHash),
      replayData: replayData == null && nullToAbsent
          ? const Value.absent()
          : Value(replayData),
      modVersion: Value(modVersion),
      gdVersion: Value(gdVersion),
      gdAccountID: Value(gdAccountID),
      rejectionReason: rejectionReason == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectionReason),
      reviewedAt: reviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedAt),
      submittedAt: Value(submittedAt),
    );
  }

  factory Submission.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Submission(
      id: serializer.fromJson<int>(json['id']),
      levelID: serializer.fromJson<int>(json['levelID']),
      levelVersion: serializer.fromJson<int?>(json['levelVersion']),
      status: $SubmissionsTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      replayHash: serializer.fromJson<Uint8List>(json['replayHash']),
      replayData: serializer.fromJson<Uint8List?>(json['replayData']),
      modVersion: serializer.fromJson<String>(json['modVersion']),
      gdVersion: serializer.fromJson<String>(json['gdVersion']),
      gdAccountID: serializer.fromJson<int>(json['gdAccountID']),
      rejectionReason: serializer.fromJson<String?>(json['rejectionReason']),
      reviewedAt: serializer.fromJson<DateTime?>(json['reviewedAt']),
      submittedAt: serializer.fromJson<DateTime>(json['submittedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'levelID': serializer.toJson<int>(levelID),
      'levelVersion': serializer.toJson<int?>(levelVersion),
      'status': serializer
          .toJson<int>($SubmissionsTable.$converterstatus.toJson(status)),
      'replayHash': serializer.toJson<Uint8List>(replayHash),
      'replayData': serializer.toJson<Uint8List?>(replayData),
      'modVersion': serializer.toJson<String>(modVersion),
      'gdVersion': serializer.toJson<String>(gdVersion),
      'gdAccountID': serializer.toJson<int>(gdAccountID),
      'rejectionReason': serializer.toJson<String?>(rejectionReason),
      'reviewedAt': serializer.toJson<DateTime?>(reviewedAt),
      'submittedAt': serializer.toJson<DateTime>(submittedAt),
    };
  }

  Submission copyWith(
          {int? id,
          int? levelID,
          Value<int?> levelVersion = const Value.absent(),
          SubmissionStatus? status,
          Uint8List? replayHash,
          Value<Uint8List?> replayData = const Value.absent(),
          String? modVersion,
          String? gdVersion,
          int? gdAccountID,
          Value<String?> rejectionReason = const Value.absent(),
          Value<DateTime?> reviewedAt = const Value.absent(),
          DateTime? submittedAt}) =>
      Submission(
        id: id ?? this.id,
        levelID: levelID ?? this.levelID,
        levelVersion:
            levelVersion.present ? levelVersion.value : this.levelVersion,
        status: status ?? this.status,
        replayHash: replayHash ?? this.replayHash,
        replayData: replayData.present ? replayData.value : this.replayData,
        modVersion: modVersion ?? this.modVersion,
        gdVersion: gdVersion ?? this.gdVersion,
        gdAccountID: gdAccountID ?? this.gdAccountID,
        rejectionReason: rejectionReason.present
            ? rejectionReason.value
            : this.rejectionReason,
        reviewedAt: reviewedAt.present ? reviewedAt.value : this.reviewedAt,
        submittedAt: submittedAt ?? this.submittedAt,
      );
  Submission copyWithCompanion(SubmissionsCompanion data) {
    return Submission(
      id: data.id.present ? data.id.value : this.id,
      levelID: data.levelID.present ? data.levelID.value : this.levelID,
      levelVersion: data.levelVersion.present
          ? data.levelVersion.value
          : this.levelVersion,
      status: data.status.present ? data.status.value : this.status,
      replayHash:
          data.replayHash.present ? data.replayHash.value : this.replayHash,
      replayData:
          data.replayData.present ? data.replayData.value : this.replayData,
      modVersion:
          data.modVersion.present ? data.modVersion.value : this.modVersion,
      gdVersion: data.gdVersion.present ? data.gdVersion.value : this.gdVersion,
      gdAccountID:
          data.gdAccountID.present ? data.gdAccountID.value : this.gdAccountID,
      rejectionReason: data.rejectionReason.present
          ? data.rejectionReason.value
          : this.rejectionReason,
      reviewedAt:
          data.reviewedAt.present ? data.reviewedAt.value : this.reviewedAt,
      submittedAt:
          data.submittedAt.present ? data.submittedAt.value : this.submittedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Submission(')
          ..write('id: $id, ')
          ..write('levelID: $levelID, ')
          ..write('levelVersion: $levelVersion, ')
          ..write('status: $status, ')
          ..write('replayHash: $replayHash, ')
          ..write('replayData: $replayData, ')
          ..write('modVersion: $modVersion, ')
          ..write('gdVersion: $gdVersion, ')
          ..write('gdAccountID: $gdAccountID, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('submittedAt: $submittedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      levelID,
      levelVersion,
      status,
      $driftBlobEquality.hash(replayHash),
      $driftBlobEquality.hash(replayData),
      modVersion,
      gdVersion,
      gdAccountID,
      rejectionReason,
      reviewedAt,
      submittedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Submission &&
          other.id == this.id &&
          other.levelID == this.levelID &&
          other.levelVersion == this.levelVersion &&
          other.status == this.status &&
          $driftBlobEquality.equals(other.replayHash, this.replayHash) &&
          $driftBlobEquality.equals(other.replayData, this.replayData) &&
          other.modVersion == this.modVersion &&
          other.gdVersion == this.gdVersion &&
          other.gdAccountID == this.gdAccountID &&
          other.rejectionReason == this.rejectionReason &&
          other.reviewedAt == this.reviewedAt &&
          other.submittedAt == this.submittedAt);
}

class SubmissionsCompanion extends UpdateCompanion<Submission> {
  final Value<int> id;
  final Value<int> levelID;
  final Value<int?> levelVersion;
  final Value<SubmissionStatus> status;
  final Value<Uint8List> replayHash;
  final Value<Uint8List?> replayData;
  final Value<String> modVersion;
  final Value<String> gdVersion;
  final Value<int> gdAccountID;
  final Value<String?> rejectionReason;
  final Value<DateTime?> reviewedAt;
  final Value<DateTime> submittedAt;
  const SubmissionsCompanion({
    this.id = const Value.absent(),
    this.levelID = const Value.absent(),
    this.levelVersion = const Value.absent(),
    this.status = const Value.absent(),
    this.replayHash = const Value.absent(),
    this.replayData = const Value.absent(),
    this.modVersion = const Value.absent(),
    this.gdVersion = const Value.absent(),
    this.gdAccountID = const Value.absent(),
    this.rejectionReason = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.submittedAt = const Value.absent(),
  });
  SubmissionsCompanion.insert({
    this.id = const Value.absent(),
    required int levelID,
    this.levelVersion = const Value.absent(),
    required SubmissionStatus status,
    required Uint8List replayHash,
    this.replayData = const Value.absent(),
    required String modVersion,
    required String gdVersion,
    required int gdAccountID,
    this.rejectionReason = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    required DateTime submittedAt,
  })  : levelID = Value(levelID),
        status = Value(status),
        replayHash = Value(replayHash),
        modVersion = Value(modVersion),
        gdVersion = Value(gdVersion),
        gdAccountID = Value(gdAccountID),
        submittedAt = Value(submittedAt);
  static Insertable<Submission> custom({
    Expression<int>? id,
    Expression<int>? levelID,
    Expression<int>? levelVersion,
    Expression<int>? status,
    Expression<Uint8List>? replayHash,
    Expression<Uint8List>? replayData,
    Expression<String>? modVersion,
    Expression<String>? gdVersion,
    Expression<int>? gdAccountID,
    Expression<String>? rejectionReason,
    Expression<DateTime>? reviewedAt,
    Expression<DateTime>? submittedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (levelID != null) 'level_i_d': levelID,
      if (levelVersion != null) 'level_version': levelVersion,
      if (status != null) 'status': status,
      if (replayHash != null) 'replay_hash': replayHash,
      if (replayData != null) 'replay_data': replayData,
      if (modVersion != null) 'mod_version': modVersion,
      if (gdVersion != null) 'gd_version': gdVersion,
      if (gdAccountID != null) 'gd_account_i_d': gdAccountID,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (submittedAt != null) 'submitted_at': submittedAt,
    });
  }

  SubmissionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? levelID,
      Value<int?>? levelVersion,
      Value<SubmissionStatus>? status,
      Value<Uint8List>? replayHash,
      Value<Uint8List?>? replayData,
      Value<String>? modVersion,
      Value<String>? gdVersion,
      Value<int>? gdAccountID,
      Value<String?>? rejectionReason,
      Value<DateTime?>? reviewedAt,
      Value<DateTime>? submittedAt}) {
    return SubmissionsCompanion(
      id: id ?? this.id,
      levelID: levelID ?? this.levelID,
      levelVersion: levelVersion ?? this.levelVersion,
      status: status ?? this.status,
      replayHash: replayHash ?? this.replayHash,
      replayData: replayData ?? this.replayData,
      modVersion: modVersion ?? this.modVersion,
      gdVersion: gdVersion ?? this.gdVersion,
      gdAccountID: gdAccountID ?? this.gdAccountID,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (levelID.present) {
      map['level_i_d'] = Variable<int>(levelID.value);
    }
    if (levelVersion.present) {
      map['level_version'] = Variable<int>(levelVersion.value);
    }
    if (status.present) {
      map['status'] =
          Variable<int>($SubmissionsTable.$converterstatus.toSql(status.value));
    }
    if (replayHash.present) {
      map['replay_hash'] = Variable<Uint8List>(replayHash.value);
    }
    if (replayData.present) {
      map['replay_data'] = Variable<Uint8List>(replayData.value);
    }
    if (modVersion.present) {
      map['mod_version'] = Variable<String>(modVersion.value);
    }
    if (gdVersion.present) {
      map['gd_version'] = Variable<String>(gdVersion.value);
    }
    if (gdAccountID.present) {
      map['gd_account_i_d'] = Variable<int>(gdAccountID.value);
    }
    if (rejectionReason.present) {
      map['rejection_reason'] = Variable<String>(rejectionReason.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<DateTime>(submittedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionsCompanion(')
          ..write('id: $id, ')
          ..write('levelID: $levelID, ')
          ..write('levelVersion: $levelVersion, ')
          ..write('status: $status, ')
          ..write('replayHash: $replayHash, ')
          ..write('replayData: $replayData, ')
          ..write('modVersion: $modVersion, ')
          ..write('gdVersion: $gdVersion, ')
          ..write('gdAccountID: $gdAccountID, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('submittedAt: $submittedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$ShowcaseDatabase extends GeneratedDatabase {
  _$ShowcaseDatabase(QueryExecutor e) : super(e);
  $ShowcaseDatabaseManager get managers => $ShowcaseDatabaseManager(this);
  late final $LevelsTable levels = $LevelsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SubmissionsTable submissions = $SubmissionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [levels, users, submissions];
}

typedef $$LevelsTableCreateCompanionBuilder = LevelsCompanion Function({
  required int levelID,
  required String cachedTitle,
  Value<int?> cachedVersion,
  Value<int?> cachedStars,
  required DateTime lastCacheUpdateAt,
  Value<int> accesses,
  Value<int> rowid,
});
typedef $$LevelsTableUpdateCompanionBuilder = LevelsCompanion Function({
  Value<int> levelID,
  Value<String> cachedTitle,
  Value<int?> cachedVersion,
  Value<int?> cachedStars,
  Value<DateTime> lastCacheUpdateAt,
  Value<int> accesses,
  Value<int> rowid,
});

final class $$LevelsTableReferences
    extends BaseReferences<_$ShowcaseDatabase, $LevelsTable, Level> {
  $$LevelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SubmissionsTable, List<Submission>>
      _submissionsRefsTable(_$ShowcaseDatabase db) =>
          MultiTypedResultKey.fromTable(db.submissions,
              aliasName: $_aliasNameGenerator(
                  db.levels.levelID, db.submissions.levelID));

  $$SubmissionsTableProcessedTableManager get submissionsRefs {
    final manager = $$SubmissionsTableTableManager($_db, $_db.submissions)
        .filter((f) => f.levelID.levelID($_item.levelID));

    final cache = $_typedResult.readTableOrNull(_submissionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LevelsTableFilterComposer
    extends Composer<_$ShowcaseDatabase, $LevelsTable> {
  $$LevelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get levelID => $composableBuilder(
      column: $table.levelID, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cachedTitle => $composableBuilder(
      column: $table.cachedTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cachedVersion => $composableBuilder(
      column: $table.cachedVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cachedStars => $composableBuilder(
      column: $table.cachedStars, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastCacheUpdateAt => $composableBuilder(
      column: $table.lastCacheUpdateAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accesses => $composableBuilder(
      column: $table.accesses, builder: (column) => ColumnFilters(column));

  Expression<bool> submissionsRefs(
      Expression<bool> Function($$SubmissionsTableFilterComposer f) f) {
    final $$SubmissionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.levelID,
        referencedTable: $db.submissions,
        getReferencedColumn: (t) => t.levelID,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubmissionsTableFilterComposer(
              $db: $db,
              $table: $db.submissions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LevelsTableOrderingComposer
    extends Composer<_$ShowcaseDatabase, $LevelsTable> {
  $$LevelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get levelID => $composableBuilder(
      column: $table.levelID, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cachedTitle => $composableBuilder(
      column: $table.cachedTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cachedVersion => $composableBuilder(
      column: $table.cachedVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cachedStars => $composableBuilder(
      column: $table.cachedStars, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastCacheUpdateAt => $composableBuilder(
      column: $table.lastCacheUpdateAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accesses => $composableBuilder(
      column: $table.accesses, builder: (column) => ColumnOrderings(column));
}

class $$LevelsTableAnnotationComposer
    extends Composer<_$ShowcaseDatabase, $LevelsTable> {
  $$LevelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get levelID =>
      $composableBuilder(column: $table.levelID, builder: (column) => column);

  GeneratedColumn<String> get cachedTitle => $composableBuilder(
      column: $table.cachedTitle, builder: (column) => column);

  GeneratedColumn<int> get cachedVersion => $composableBuilder(
      column: $table.cachedVersion, builder: (column) => column);

  GeneratedColumn<int> get cachedStars => $composableBuilder(
      column: $table.cachedStars, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCacheUpdateAt => $composableBuilder(
      column: $table.lastCacheUpdateAt, builder: (column) => column);

  GeneratedColumn<int> get accesses =>
      $composableBuilder(column: $table.accesses, builder: (column) => column);

  Expression<T> submissionsRefs<T extends Object>(
      Expression<T> Function($$SubmissionsTableAnnotationComposer a) f) {
    final $$SubmissionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.levelID,
        referencedTable: $db.submissions,
        getReferencedColumn: (t) => t.levelID,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubmissionsTableAnnotationComposer(
              $db: $db,
              $table: $db.submissions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LevelsTableTableManager extends RootTableManager<
    _$ShowcaseDatabase,
    $LevelsTable,
    Level,
    $$LevelsTableFilterComposer,
    $$LevelsTableOrderingComposer,
    $$LevelsTableAnnotationComposer,
    $$LevelsTableCreateCompanionBuilder,
    $$LevelsTableUpdateCompanionBuilder,
    (Level, $$LevelsTableReferences),
    Level,
    PrefetchHooks Function({bool submissionsRefs})> {
  $$LevelsTableTableManager(_$ShowcaseDatabase db, $LevelsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> levelID = const Value.absent(),
            Value<String> cachedTitle = const Value.absent(),
            Value<int?> cachedVersion = const Value.absent(),
            Value<int?> cachedStars = const Value.absent(),
            Value<DateTime> lastCacheUpdateAt = const Value.absent(),
            Value<int> accesses = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LevelsCompanion(
            levelID: levelID,
            cachedTitle: cachedTitle,
            cachedVersion: cachedVersion,
            cachedStars: cachedStars,
            lastCacheUpdateAt: lastCacheUpdateAt,
            accesses: accesses,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int levelID,
            required String cachedTitle,
            Value<int?> cachedVersion = const Value.absent(),
            Value<int?> cachedStars = const Value.absent(),
            required DateTime lastCacheUpdateAt,
            Value<int> accesses = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LevelsCompanion.insert(
            levelID: levelID,
            cachedTitle: cachedTitle,
            cachedVersion: cachedVersion,
            cachedStars: cachedStars,
            lastCacheUpdateAt: lastCacheUpdateAt,
            accesses: accesses,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$LevelsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({submissionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (submissionsRefs) db.submissions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (submissionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$LevelsTableReferences._submissionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LevelsTableReferences(db, table, p0)
                                .submissionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.levelID == item.levelID),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LevelsTableProcessedTableManager = ProcessedTableManager<
    _$ShowcaseDatabase,
    $LevelsTable,
    Level,
    $$LevelsTableFilterComposer,
    $$LevelsTableOrderingComposer,
    $$LevelsTableAnnotationComposer,
    $$LevelsTableCreateCompanionBuilder,
    $$LevelsTableUpdateCompanionBuilder,
    (Level, $$LevelsTableReferences),
    Level,
    PrefetchHooks Function({bool submissionsRefs})>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required int accountID,
  required String cachedUsername,
  required int badPoints,
  required String badPointsLog,
  required DateTime lastCacheUpdateAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> accountID,
  Value<String> cachedUsername,
  Value<int> badPoints,
  Value<String> badPointsLog,
  Value<DateTime> lastCacheUpdateAt,
  Value<int> rowid,
});

final class $$UsersTableReferences
    extends BaseReferences<_$ShowcaseDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SubmissionsTable, List<Submission>>
      _submissionsRefsTable(_$ShowcaseDatabase db) =>
          MultiTypedResultKey.fromTable(db.submissions,
              aliasName: $_aliasNameGenerator(
                  db.users.accountID, db.submissions.gdAccountID));

  $$SubmissionsTableProcessedTableManager get submissionsRefs {
    final manager = $$SubmissionsTableTableManager($_db, $_db.submissions)
        .filter((f) => f.gdAccountID.accountID($_item.accountID));

    final cache = $_typedResult.readTableOrNull(_submissionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer
    extends Composer<_$ShowcaseDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get accountID => $composableBuilder(
      column: $table.accountID, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cachedUsername => $composableBuilder(
      column: $table.cachedUsername,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get badPoints => $composableBuilder(
      column: $table.badPoints, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get badPointsLog => $composableBuilder(
      column: $table.badPointsLog, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastCacheUpdateAt => $composableBuilder(
      column: $table.lastCacheUpdateAt,
      builder: (column) => ColumnFilters(column));

  Expression<bool> submissionsRefs(
      Expression<bool> Function($$SubmissionsTableFilterComposer f) f) {
    final $$SubmissionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountID,
        referencedTable: $db.submissions,
        getReferencedColumn: (t) => t.gdAccountID,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubmissionsTableFilterComposer(
              $db: $db,
              $table: $db.submissions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$ShowcaseDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get accountID => $composableBuilder(
      column: $table.accountID, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cachedUsername => $composableBuilder(
      column: $table.cachedUsername,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get badPoints => $composableBuilder(
      column: $table.badPoints, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get badPointsLog => $composableBuilder(
      column: $table.badPointsLog,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastCacheUpdateAt => $composableBuilder(
      column: $table.lastCacheUpdateAt,
      builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$ShowcaseDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get accountID =>
      $composableBuilder(column: $table.accountID, builder: (column) => column);

  GeneratedColumn<String> get cachedUsername => $composableBuilder(
      column: $table.cachedUsername, builder: (column) => column);

  GeneratedColumn<int> get badPoints =>
      $composableBuilder(column: $table.badPoints, builder: (column) => column);

  GeneratedColumn<String> get badPointsLog => $composableBuilder(
      column: $table.badPointsLog, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCacheUpdateAt => $composableBuilder(
      column: $table.lastCacheUpdateAt, builder: (column) => column);

  Expression<T> submissionsRefs<T extends Object>(
      Expression<T> Function($$SubmissionsTableAnnotationComposer a) f) {
    final $$SubmissionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountID,
        referencedTable: $db.submissions,
        getReferencedColumn: (t) => t.gdAccountID,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubmissionsTableAnnotationComposer(
              $db: $db,
              $table: $db.submissions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$ShowcaseDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool submissionsRefs})> {
  $$UsersTableTableManager(_$ShowcaseDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> accountID = const Value.absent(),
            Value<String> cachedUsername = const Value.absent(),
            Value<int> badPoints = const Value.absent(),
            Value<String> badPointsLog = const Value.absent(),
            Value<DateTime> lastCacheUpdateAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            accountID: accountID,
            cachedUsername: cachedUsername,
            badPoints: badPoints,
            badPointsLog: badPointsLog,
            lastCacheUpdateAt: lastCacheUpdateAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int accountID,
            required String cachedUsername,
            required int badPoints,
            required String badPointsLog,
            required DateTime lastCacheUpdateAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            accountID: accountID,
            cachedUsername: cachedUsername,
            badPoints: badPoints,
            badPointsLog: badPointsLog,
            lastCacheUpdateAt: lastCacheUpdateAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({submissionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (submissionsRefs) db.submissions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (submissionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._submissionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .submissionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.gdAccountID == item.accountID),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$ShowcaseDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool submissionsRefs})>;
typedef $$SubmissionsTableCreateCompanionBuilder = SubmissionsCompanion
    Function({
  Value<int> id,
  required int levelID,
  Value<int?> levelVersion,
  required SubmissionStatus status,
  required Uint8List replayHash,
  Value<Uint8List?> replayData,
  required String modVersion,
  required String gdVersion,
  required int gdAccountID,
  Value<String?> rejectionReason,
  Value<DateTime?> reviewedAt,
  required DateTime submittedAt,
});
typedef $$SubmissionsTableUpdateCompanionBuilder = SubmissionsCompanion
    Function({
  Value<int> id,
  Value<int> levelID,
  Value<int?> levelVersion,
  Value<SubmissionStatus> status,
  Value<Uint8List> replayHash,
  Value<Uint8List?> replayData,
  Value<String> modVersion,
  Value<String> gdVersion,
  Value<int> gdAccountID,
  Value<String?> rejectionReason,
  Value<DateTime?> reviewedAt,
  Value<DateTime> submittedAt,
});

final class $$SubmissionsTableReferences
    extends BaseReferences<_$ShowcaseDatabase, $SubmissionsTable, Submission> {
  $$SubmissionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LevelsTable _levelIDTable(_$ShowcaseDatabase db) =>
      db.levels.createAlias(
          $_aliasNameGenerator(db.submissions.levelID, db.levels.levelID));

  $$LevelsTableProcessedTableManager get levelID {
    final manager = $$LevelsTableTableManager($_db, $_db.levels)
        .filter((f) => f.levelID($_item.levelID!));
    final item = $_typedResult.readTableOrNull(_levelIDTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _gdAccountIDTable(_$ShowcaseDatabase db) =>
      db.users.createAlias(
          $_aliasNameGenerator(db.submissions.gdAccountID, db.users.accountID));

  $$UsersTableProcessedTableManager get gdAccountID {
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.accountID($_item.gdAccountID!));
    final item = $_typedResult.readTableOrNull(_gdAccountIDTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SubmissionsTableFilterComposer
    extends Composer<_$ShowcaseDatabase, $SubmissionsTable> {
  $$SubmissionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get levelVersion => $composableBuilder(
      column: $table.levelVersion, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SubmissionStatus, SubmissionStatus, int>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<Uint8List> get replayHash => $composableBuilder(
      column: $table.replayHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get replayData => $composableBuilder(
      column: $table.replayData, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modVersion => $composableBuilder(
      column: $table.modVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gdVersion => $composableBuilder(
      column: $table.gdVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get submittedAt => $composableBuilder(
      column: $table.submittedAt, builder: (column) => ColumnFilters(column));

  $$LevelsTableFilterComposer get levelID {
    final $$LevelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.levelID,
        referencedTable: $db.levels,
        getReferencedColumn: (t) => t.levelID,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LevelsTableFilterComposer(
              $db: $db,
              $table: $db.levels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get gdAccountID {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gdAccountID,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.accountID,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubmissionsTableOrderingComposer
    extends Composer<_$ShowcaseDatabase, $SubmissionsTable> {
  $$SubmissionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get levelVersion => $composableBuilder(
      column: $table.levelVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get replayHash => $composableBuilder(
      column: $table.replayHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get replayData => $composableBuilder(
      column: $table.replayData, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modVersion => $composableBuilder(
      column: $table.modVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gdVersion => $composableBuilder(
      column: $table.gdVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get submittedAt => $composableBuilder(
      column: $table.submittedAt, builder: (column) => ColumnOrderings(column));

  $$LevelsTableOrderingComposer get levelID {
    final $$LevelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.levelID,
        referencedTable: $db.levels,
        getReferencedColumn: (t) => t.levelID,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LevelsTableOrderingComposer(
              $db: $db,
              $table: $db.levels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get gdAccountID {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gdAccountID,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.accountID,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubmissionsTableAnnotationComposer
    extends Composer<_$ShowcaseDatabase, $SubmissionsTable> {
  $$SubmissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get levelVersion => $composableBuilder(
      column: $table.levelVersion, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SubmissionStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<Uint8List> get replayHash => $composableBuilder(
      column: $table.replayHash, builder: (column) => column);

  GeneratedColumn<Uint8List> get replayData => $composableBuilder(
      column: $table.replayData, builder: (column) => column);

  GeneratedColumn<String> get modVersion => $composableBuilder(
      column: $table.modVersion, builder: (column) => column);

  GeneratedColumn<String> get gdVersion =>
      $composableBuilder(column: $table.gdVersion, builder: (column) => column);

  GeneratedColumn<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason, builder: (column) => column);

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get submittedAt => $composableBuilder(
      column: $table.submittedAt, builder: (column) => column);

  $$LevelsTableAnnotationComposer get levelID {
    final $$LevelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.levelID,
        referencedTable: $db.levels,
        getReferencedColumn: (t) => t.levelID,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LevelsTableAnnotationComposer(
              $db: $db,
              $table: $db.levels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get gdAccountID {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gdAccountID,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.accountID,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubmissionsTableTableManager extends RootTableManager<
    _$ShowcaseDatabase,
    $SubmissionsTable,
    Submission,
    $$SubmissionsTableFilterComposer,
    $$SubmissionsTableOrderingComposer,
    $$SubmissionsTableAnnotationComposer,
    $$SubmissionsTableCreateCompanionBuilder,
    $$SubmissionsTableUpdateCompanionBuilder,
    (Submission, $$SubmissionsTableReferences),
    Submission,
    PrefetchHooks Function({bool levelID, bool gdAccountID})> {
  $$SubmissionsTableTableManager(_$ShowcaseDatabase db, $SubmissionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubmissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubmissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubmissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> levelID = const Value.absent(),
            Value<int?> levelVersion = const Value.absent(),
            Value<SubmissionStatus> status = const Value.absent(),
            Value<Uint8List> replayHash = const Value.absent(),
            Value<Uint8List?> replayData = const Value.absent(),
            Value<String> modVersion = const Value.absent(),
            Value<String> gdVersion = const Value.absent(),
            Value<int> gdAccountID = const Value.absent(),
            Value<String?> rejectionReason = const Value.absent(),
            Value<DateTime?> reviewedAt = const Value.absent(),
            Value<DateTime> submittedAt = const Value.absent(),
          }) =>
              SubmissionsCompanion(
            id: id,
            levelID: levelID,
            levelVersion: levelVersion,
            status: status,
            replayHash: replayHash,
            replayData: replayData,
            modVersion: modVersion,
            gdVersion: gdVersion,
            gdAccountID: gdAccountID,
            rejectionReason: rejectionReason,
            reviewedAt: reviewedAt,
            submittedAt: submittedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int levelID,
            Value<int?> levelVersion = const Value.absent(),
            required SubmissionStatus status,
            required Uint8List replayHash,
            Value<Uint8List?> replayData = const Value.absent(),
            required String modVersion,
            required String gdVersion,
            required int gdAccountID,
            Value<String?> rejectionReason = const Value.absent(),
            Value<DateTime?> reviewedAt = const Value.absent(),
            required DateTime submittedAt,
          }) =>
              SubmissionsCompanion.insert(
            id: id,
            levelID: levelID,
            levelVersion: levelVersion,
            status: status,
            replayHash: replayHash,
            replayData: replayData,
            modVersion: modVersion,
            gdVersion: gdVersion,
            gdAccountID: gdAccountID,
            rejectionReason: rejectionReason,
            reviewedAt: reviewedAt,
            submittedAt: submittedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SubmissionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({levelID = false, gdAccountID = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (levelID) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.levelID,
                    referencedTable:
                        $$SubmissionsTableReferences._levelIDTable(db),
                    referencedColumn:
                        $$SubmissionsTableReferences._levelIDTable(db).levelID,
                  ) as T;
                }
                if (gdAccountID) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.gdAccountID,
                    referencedTable:
                        $$SubmissionsTableReferences._gdAccountIDTable(db),
                    referencedColumn: $$SubmissionsTableReferences
                        ._gdAccountIDTable(db)
                        .accountID,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SubmissionsTableProcessedTableManager = ProcessedTableManager<
    _$ShowcaseDatabase,
    $SubmissionsTable,
    Submission,
    $$SubmissionsTableFilterComposer,
    $$SubmissionsTableOrderingComposer,
    $$SubmissionsTableAnnotationComposer,
    $$SubmissionsTableCreateCompanionBuilder,
    $$SubmissionsTableUpdateCompanionBuilder,
    (Submission, $$SubmissionsTableReferences),
    Submission,
    PrefetchHooks Function({bool levelID, bool gdAccountID})>;

class $ShowcaseDatabaseManager {
  final _$ShowcaseDatabase _db;
  $ShowcaseDatabaseManager(this._db);
  $$LevelsTableTableManager get levels =>
      $$LevelsTableTableManager(_db, _db.levels);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SubmissionsTableTableManager get submissions =>
      $$SubmissionsTableTableManager(_db, _db.submissions);
}

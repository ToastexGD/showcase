import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';

part 'database.g.dart';

enum SubmissionStatus {
  unknown,
  pendingReview,
  rejected,
  accepted,
}

class Submissions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get levelID => integer().references(Levels, #levelID)();
  IntColumn get status => intEnum<SubmissionStatus>()();
  BlobColumn get replayHash => blob()();
  BlobColumn get replayData => blob().nullable()();
  TextColumn get modVersion => text()();
  TextColumn get gdVersion => text()();
  IntColumn get gdAccountID => integer().references(Users, #accountID)();
  TextColumn get rejectionReason => text().nullable()();
  DateTimeColumn get reviewedAt => dateTime().nullable()();
  DateTimeColumn get submittedAt => dateTime()();
}

class Levels extends Table {
  IntColumn get levelID => integer().unique()();
  TextColumn get cachedTitle => text()();
  IntColumn get cachedStars => integer().nullable()();
  DateTimeColumn get lastCacheUpdateAt => dateTime()();
}

class Users extends Table {
  IntColumn get accountID => integer().unique()();
  TextColumn get cachedUsername => text()();
  IntColumn get badPoints => integer()();
  TextColumn get badPointsLog => text()();
  DateTimeColumn get lastCacheUpdateAt => dateTime()();
}

@DriftDatabase(tables: [Submissions, Levels, Users])
class ShowcaseDatabase extends _$ShowcaseDatabase {
  final File sqliteFile;
  ShowcaseDatabase({required this.sqliteFile})
      : super(NativeDatabase.createInBackground(sqliteFile));

  @override
  int get schemaVersion => 1;
}

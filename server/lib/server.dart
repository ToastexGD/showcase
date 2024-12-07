import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:convert/convert.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:crypto/crypto.dart';

import 'package:drift/drift.dart';
import 'package:server/models/requests.dart';
import 'package:server/models/database.dart';
import 'package:server/player.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

const gdVersion = "2.2074";
const modVersion = "1.0.0-alpha.1";
const maxReplayDataSize = 5 * 1024 * 1024; // 5MB
const maxBadPoints = 5;
const baseDashAuthUrl = "https://dashend.firee.dev/api/v1";
// const baseDashAuthUrl = "http://localhost:3002/api/v1";
const maxUserSubmissions = 10;

class ShowcaseServer {
  late final HttpServer server;
  late final ShowcaseDatabase db;
  late final ShowcasePlayer player;
  final Directory dataDir;
  final bool headless;

  Directory get winePrefixDir =>
      Directory(path.join(dataDir.path, "wine_prefix"));
  File get sqliteFile => File(path.join(dataDir.path, "db", "db.sqlite"));

  ShowcaseServer({
    required Directory gdDir,
    required this.dataDir,
    required this.headless,
  }) {
    winePrefixDir.create(recursive: true);
    sqliteFile.parent.create(recursive: true);

    db = ShowcaseDatabase(sqliteFile: sqliteFile);
    player = ShowcasePlayer(
      gdDir: gdDir,
      winePrefixDir: winePrefixDir,
      headless: headless,
    );

    final app = Router();

    app.post('/needed_submissions', (Request request) async {
      final jsonData = json.decode(await request.readAsString());

      final body = NeededSubmissionsRequest.fromJson(jsonData);

      final accountID = await authenticateUser(body.dashAuthToken);
      if (accountID == null) {
        return Response.unauthorized(null);
      }

      List<bool> wantReplay = [];

      for (final metadata in body.submissionsMetadata) {
        wantReplay.add(await isSubmissionNeeded(metadata, accountID));
      }

      return Response.ok(json.encode(wantReplay));
    });

    app.post('/upload_submissions', (Request request) async {
      final body = UploadSubmissionsRequest.fromJson(
          json.decode(await request.readAsString()));

      final accountID = await authenticateUser(body.dashAuthToken);
      if (accountID == null) {
        return Response.unauthorized(null);
      }

      // verify all the submissions are needed
      // if one isn't then return and add 1 BAD POINT to gd user
      for (final submission in body.submissions) {
        if (!await isSubmissionNeeded(submission.metadata, accountID)) {
          await addBadPoint(
            accountID,
            "Tried submitting a submission that isn't needed",
          );
          return Response.forbidden('Submission not needed');
        }
      }

      for (final submission in body.submissions) {
        Uint8List replayData = base64.decode(submission.dataBase64);

        if (replayData.length > maxReplayDataSize) {
          await addBadPoint(accountID, "Given Replay data was too large");
          return Response.forbidden('Replay data too large');
        }

        Uint8List recomputedReplayHash =
            Uint8List.fromList(sha256.convert(replayData).bytes);
        Function eq = const ListEquality().equals;
        if (!eq(recomputedReplayHash, submission.metadata.replayHashBytes)) {
          await addBadPoint(accountID,
              "Given Replay hash doesn't match the computed replay hash");
          return Response.forbidden('Replay hash mismatch');
        }

        print("Added submission for level ${submission.metadata.levelID} by $accountID");
        db.into(db.submissions).insert(SubmissionsCompanion(
              levelID: Value(submission.metadata.levelID),
              status: Value(SubmissionStatus.pendingReview),
              replayHash: Value(recomputedReplayHash),
              replayData: Value(replayData),
              modVersion: Value(modVersion),
              gdVersion: Value(gdVersion),
              gdAccountID: Value(accountID),
              rejectionReason: Value(null),
              submittedAt: Value(DateTime.now()),
            ));
      }
      return Response.ok(null);
    });

    app.post('/get_submission', (Request request) async {
      final body = GetSubmissionRequest.fromJson(
          json.decode(await request.readAsString()));
      if (body.gdVersion != gdVersion || body.modVersion != modVersion) {
        return Response.notFound("Bad gd/mod versions");
      }
      print("Getting replay for level: ${body.levelID}");
      final submission = await getSubmissionForLevel(body.levelID);
      if (submission == null) {
        return Response.notFound("No replay found for level");
      }
      print("Got valid replay");
      return Response.ok(base64.encode(submission.replayData!));
    });

    playLevelsLoop();

    io.serve(app.call, '127.0.0.1', 8080).then((server) {
      this.server = server;
      print('Serving public at http://${server.address.host}:${server.port}');
    });
  }

  Future<void> playLevelsLoop() async {
    while (true) {
      await Future.delayed(Duration(seconds: 2));

      final submission = await nextSubmissionInQueue();

      print("Checking submission ID: ${submission?.id} for level ${submission?.levelID}.");

      if (submission == null) {
        continue;
      }

      final feedback = await player.playReplay(
        levelID: submission.levelID,
        replayData: submission.replayData!,
        maxAttempts: 2,
      );
      print("Done replaying(levelID: ${submission.levelID}). Feedback: $feedback");
      switch (feedback) {
        case ReplayFeedback.success:
          await acceptSubmission(submission.id);
          break;
        case ReplayFeedback.userBadInput:
          await addBadPoint(
            submission.gdAccountID,
            "Bad point during replay check. Probably replay for an invalid level.",
          );
          await rejectSubmission(submission.id, "Bad point given.");
          break;
        case ReplayFeedback.replayFailed:
          await rejectSubmission(
              submission.id, "Tried to play replay and failed");
          break;
        case ReplayFeedback.unknown:
          await rejectSubmission(submission.id, "Unknown reason for failing.");
          break;
      }
    }
  }

  Future<void> acceptSubmission(int submissionID) async {
    await (db.update(db.submissions)
          ..where((tbl) => tbl.id.equals(submissionID)))
        .write(
      SubmissionsCompanion(
        status: Value(SubmissionStatus.accepted),
        reviewedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> rejectSubmission(int submissionID, String reason) async {
    final formattedReason = "\n\n${DateTime.now().toIso8601String()}: $reason";
    await (db.update(db.submissions)
          ..where((tbl) => tbl.id.equals(submissionID)))
        .write(
      SubmissionsCompanion.custom(
        status: Variable(SubmissionStatus.rejected.index),
        rejectionReason:
            db.submissions.rejectionReason + Variable(formattedReason),
        reviewedAt: Variable(DateTime.now()),
      ),
    );
  }

  Future<bool> isSubmissionNeeded(
    RequestSubmissionMetadata metadata,
    int accountID,
  ) async {
    if (metadata.gdVersion != gdVersion) return false;
    if (metadata.modVersion != modVersion) return false;

    final replayHashBytes = metadata.replayHashBytes;

    // not needed if hash already checked
    final sameHashSubmission = await (db.select(db.submissions)
          ..where((tbl) => tbl.replayHash.equals(replayHashBytes))
          ..limit(1))
        .get();
    if (sameHashSubmission.isNotEmpty) {
      return false;
    }

    // not needed if the level isn't needed
    final acceptedSubmission = await getSubmissionForLevel(metadata.levelID);
    if (acceptedSubmission != null) {
      return false;
    }

    // not needed if user already has 10 pending submissions
    final userSubmission = await (db.select(db.submissions)
          ..where((tbl) => tbl.status.equals(SubmissionStatus.pendingReview.index))
          ..where((tbl) => tbl.gdAccountID.equals(accountID))
          ..limit(maxUserSubmissions))
        .get();
    if (userSubmission.length >= maxUserSubmissions) {
      return false;
    }

    return true;
  }

  Future<int?> authenticateUser(String dashAuthToken) async {
    final client = http.Client();
    final dashAuthResponse = await client.post(
      Uri.parse("$baseDashAuthUrl/verify"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": dashAuthToken}),
    );

    if (dashAuthResponse.statusCode != 200) {
      return null;
    }

    final body = json.decode(dashAuthResponse.body) as Map<String, dynamic>;

    if (body["success"] != true || body["data"]["token"] != dashAuthToken) {
      return null;
    }

    final accountID = body["data"]["id"] as int;
    final username = body["data"]["username"] as String;

    final existingUser = await (db.select(db.users)
          ..where((tbl) => tbl.accountID.equals(accountID))
          ..limit(1))
        .get()
        .then((l) => l.firstOrNull);

    if (existingUser == null) {
      final insertUserQuery = await db.into(db.users).insert(UsersCompanion(
            accountID: Value(accountID),
            cachedUsername: Value(username),
            badPoints: Value(0),
            lastCacheUpdateAt: Value(DateTime.now()),
            badPointsLog: Value(""),
          ));
      if (insertUserQuery != 1) {
        return null;
      }
    } else {
      if (existingUser.badPoints > maxBadPoints) {
        return null;
      }

      final editUserQuery = await (db.update(db.users)
            ..where((tbl) => tbl.accountID.equals(accountID)))
          .write(UsersCompanion.custom(cachedUsername: Variable(username)));
      if (editUserQuery != 1) {
        return null;
      }
    }

    return accountID;
  }

  Future<Submission?> getSubmissionForLevel(int levelID) async {
    final queriedSubmission = await (db.select(db.submissions).join([
      innerJoin(
        db.users,
        db.users.accountID.equalsExp(db.submissions.gdAccountID),
      )
    ])
          ..limit(1)
          ..where(db.submissions.levelID.equals(levelID))
          ..where(db.submissions.status.equals(SubmissionStatus.accepted.index))
          ..where(db.submissions.modVersion.equals(modVersion))
          ..where(db.submissions.gdVersion.equals(gdVersion))
          ..where(db.submissions.replayData.isNotNull())
          ..where(db.users.badPoints.isSmallerOrEqualValue(5)))
        .get()
        .then((sub) => sub.firstOrNull?.readTable(db.submissions));
    return queriedSubmission;
  }

  Future<Submission?> nextSubmissionInQueue() async {
    final queriedSubmission = await (db.select(db.submissions).join([
      innerJoin(
        db.users,
        db.users.accountID.equalsExp(db.submissions.gdAccountID),
      )
    ])
          ..orderBy([
            OrderingTerm(
              expression: db.submissions.submittedAt,
            )
          ])
          ..limit(1)
          ..where(db.submissions.status
              .equals(SubmissionStatus.pendingReview.index))
          ..where(db.submissions.modVersion.equals(modVersion))
          ..where(db.submissions.gdVersion.equals(gdVersion))
          ..where(db.submissions.replayData.isNotNull())
          ..where(db.users.badPoints.isSmallerOrEqualValue(5)))
        .get()
        .then((sub) => sub.firstOrNull?.readTable(db.submissions));
    return queriedSubmission;
  }

  Future<void> addBadPoint(int accountID, String reason) async {
    final formattedReason = "\n\n${DateTime.now().toIso8601String()}: $reason";
    final editUserQuery = await (db.update(db.users)
          ..where((tbl) => tbl.accountID.equals(accountID)))
        .write(UsersCompanion.custom(
      badPoints: db.users.badPoints + Variable(1),
      badPointsLog: db.users.badPointsLog + Variable(formattedReason),
    ));
    if (editUserQuery != 1) {
      throw Exception("Failed to add bad point");
    }
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:json/json.dart';
import 'package:server/models/database.dart';

@JsonCodable()
class RequestSubmissionInfo {
  final int levelID;
  final int levelVersion;
  final String? dataBase64;
  final String modVersion;
  final String gdVersion;

  static RequestSubmissionInfo fromDBSubmission(Submission submission) {
    // TODO: JsonCodable doesn't create a regular constructor :(
    return RequestSubmissionInfo.fromJson({
      "levelID": submission.levelID,
      "levelVersion": submission.levelVersion,
      "dataBase64": submission.replayData != null
          ? base64Encode(submission.replayData!)
          : null,
      "modVersion": submission.modVersion,
      "gdVersion": submission.gdVersion,
    });
  }
}

@JsonCodable()
class NeededSubmissionsRequest {
  final String dashAuthToken;
  final List<RequestSubmissionInfo> submissions;
}

@JsonCodable()
class UploadSubmissionRequest {
  final String dashAuthToken;
  final RequestSubmissionInfo submission;
}

@JsonCodable()
class GetSubmissionRequest {
  final int levelID;
  final String modVersion;
  final String gdVersion;
}

import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:json/json.dart';

@JsonCodable()
class RequestSubmissionMetadata {
  final int levelID;
  final String replayHash;
  final String modVersion;
  final String gdVersion;

  Uint8List get replayHashBytes => Uint8List.fromList(hex.decode(replayHash));
}

@JsonCodable()
class RequestSubmission {
  final RequestSubmissionMetadata metadata;
  final String dataBase64;
}

@JsonCodable()
class NeededSubmissionsRequest {
  final String dashAuthToken;
  final List<RequestSubmissionMetadata> submissionsMetadata;
}

@JsonCodable()
class UploadSubmissionsRequest {
  final String dashAuthToken;
  final List<RequestSubmission> submissions;
}

@JsonCodable()
class GetSubmissionRequest {
  final int levelID;
  final String modVersion;
  final String gdVersion;
}

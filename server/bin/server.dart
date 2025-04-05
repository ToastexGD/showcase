import 'dart:io';
import 'package:args/args.dart';
import 'package:server/server.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption(
      'gd-dir',
      abbr: 'g',
      mandatory: true,
      help: 'Path to the Geometry Dash data directory.',
    )
    ..addOption(
      'pg-username',
      mandatory: true,
      help: 'Postgres username',
    )
    ..addOption(
      'pg-password',
      mandatory: true,
      help: 'Postgres password',
    )
    ..addOption(
      'pg-hostname',
      mandatory: true,
      help: 'Postgres hostname',
    )
    ..addOption(
      'pg-port',
      defaultsTo: '5432',
      help: 'Postgres port',
    )
    ..addOption(
      'pg-database-name',
      mandatory: true,
      help: 'Postgres database name',
    )
    ..addOption(
      'player-binary',
      mandatory: true,
      help: 'Path to the player binary.',
    )
    ..addOption(
      'http-port',
      defaultsTo: '8080',
      help: 'Port to listen on for HTTP requests.',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Display this help message.',
    );

  // Parse arguments
  final argResults = parser.parse(arguments);

  // Display help and exit if --help is provided
  if (argResults['help'] as bool) {
    print(parser.usage);
    exit(0);
  }

  // Retrieve options
  final gdDirPath = argResults['gd-dir'] as String;
  final pgUsername = argResults['pg-username'] as String;
  final pgPassword = argResults['pg-password'] as String;
  final pgHostname = argResults['pg-hostname'] as String;
  final pgPort = int.parse(argResults['pg-port'] as String);
  final pgDatabaseName = argResults['pg-database-name'] as String;
  final playerBinaryPath = argResults['player-binary'] as String;
  final httpPort = int.parse(argResults['http-port'] as String);

  // Create directories
  final gdDir = Directory(gdDirPath).absolute;
  final playerBinaryFile = File(playerBinaryPath).absolute;

  // Start the server
  ShowcaseServer(
    gdDir: gdDir,
    pgUsername: pgUsername,
    pgPassword: pgPassword,
    pgHostname: pgHostname,
    pgPort: pgPort,
    pgDatabaseName: pgDatabaseName,
    playerBinaryFile: playerBinaryFile,
    httpPort: httpPort,
  );
}

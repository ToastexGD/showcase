import 'dart:io';
import 'package:args/args.dart';
import 'package:server/server.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption(
      'gdDir',
      abbr: 'g',
      mandatory: true,
      help: 'Path to the Geometry Dash data directory.',
    )
    ..addOption(
      'dataDir',
      abbr: 'd',
      mandatory: true,
      help: 'Path to the data directory.',
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
    print('Usage: dart script.dart [options]');
    print(parser.usage);
    exit(0);
  }

  // Retrieve options
  final gdDirPath = argResults['gdDir'] as String;
  final dataDirPath = argResults['dataDir'] as String;

  // Create directories
  final gdDir = Directory(gdDirPath).absolute;
  final dataDir = Directory(dataDirPath).absolute;

  // Start the server
  ShowcaseServer(
    gdDir: gdDir,
    dataDir: dataDir,
  );
}

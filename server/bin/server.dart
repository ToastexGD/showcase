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
      'data-dir',
      abbr: 'd',
      mandatory: true,
      help: 'Path to the data directory.',
    )
    ..addFlag(
      'headless',
      negatable: true,
      defaultsTo: true,
      help: 'Run GD in headless mode.',
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

  // Retrieve flags
  final headless = argResults['headless'] as bool;

  // Retrieve options
  final gdDirPath = argResults['gd-dir'] as String;
  final dataDirPath = argResults['data-dir'] as String;

  // Create directories
  final gdDir = Directory(gdDirPath).absolute;
  final dataDir = Directory(dataDirPath).absolute;

  // Start the server
  ShowcaseServer(
    gdDir: gdDir,
    dataDir: dataDir,
    headless: headless,
  );
}

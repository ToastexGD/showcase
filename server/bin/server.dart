import 'dart:io';

import 'package:server/server.dart';

void main(List<String> arguments) {
  // print('Hello world: ${server.calculate()}!');
  ShowcaseServer(
    gdDir: Directory("/home/flafy/Games/data/windows/geometry-dash").absolute,
    dataDir: Directory("./data_dir").absolute,
  );
  // test();
}

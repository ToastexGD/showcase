{ lib, buildDartApplication }:

buildDartApplication rec {
  pname = "showcase-server";
  version = "1.0.0";

  src = ./..;
  # TODO
  # dartCompileCommand = "dart --enable-experiment=macros build";

  # pubspecLock = lib.importJSON ./pubspec.lock.json;
  autoPubspecLock = src + "/pubspec.lock";
}

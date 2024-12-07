{ lib, buildDartApplication }:

buildDartApplication rec {
  pname = "showcase-server";
  version = "1.0.0";

  src = ./..;

  dartCompileFlags = [
    "--enable-experiment=macros"
  ];

  # pubspecLock = lib.importJSON ./pubspec.lock.json;
  autoPubspecLock = src + "/pubspec.lock";
}

{ lib, buildDartApplication }:

buildDartApplication rec {
  pname = "showcase-server";
  version = "1.0.0";

  src = ./..;

  dartCompileFlags = [
    "--enable-experiment=macros"
  ];

  autoPubspecLock = src + "/pubspec.lock";
}

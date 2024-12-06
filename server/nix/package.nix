buildDartApplication rec {
  pname = "dart-sass";
  version = "1.62.1";

  src = ./.;

  pubspecLock = lib.importJSON ./pubspec.lock.json;
}

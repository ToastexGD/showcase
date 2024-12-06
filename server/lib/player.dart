import 'dart:async';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:server/utils/future_timeout.dart';

enum ReplayFeedback {
  success,
  userBadInput,
  replayFailed,
  unknown,
}

class ShowcasePlayer {
  final Directory gdDir;
  final Directory winePrefixDir;

  ServerSocket? _serverSocket;
  Socket? _clientSocket;
  StreamIterator<Uint8List>? _clientStreamIterator;
  Process? _gdProcess;

  ShowcasePlayer({
    required this.gdDir,
    required this.winePrefixDir,
  });

  File get _gdExecutableFile => File(path.join(gdDir.path, "GeometryDash.exe"));
  Directory get _winePrefixUserDir =>
      Directory(path.join(winePrefixDir.path, "drive_c/users/showcase"));

  File _getReplayQueueFile(int levelID) {
    return File(path.join(
        winePrefixDir.path,
        "drive_c/users/showcase/AppData/Local/GeometryDash/geode/mods/flafy.showcase/queue",
        "$levelID.gdr"));
  }

  Future<bool> _establishSocket() async {
    final serverSocket = await ServerSocket.bind("127.0.0.1", 8081);
    final clientSocket = await futureTimeout(
      serverSocket.first,
      Duration(seconds: 10),
    );
    if (clientSocket == null) {
      return false;
    }
    _serverSocket = serverSocket;
    _clientSocket = clientSocket;
    _clientStreamIterator = StreamIterator(clientSocket.asBroadcastStream());

    if (await _waitForCommand("client_connected") != 0) {
      return false;
    }

    return true;
  }

  Future<bool> _sendCommand(String commandName, Object arg) async {
    if (_clientSocket == null) return false;
    final sent = await futureTimeout(
      Future(() async {
        final strData = "$commandName ${json.encode(arg)}";
        final data = utf8.encode(strData);
        _clientSocket!.add(data);
        await _clientSocket!.flush();
        return true;
      }),
      const Duration(seconds: 5),
    );
    return sent == true;
  }

  Future<Object?> _waitForCommand(String commandName,
      [Duration timeout = const Duration(seconds: 10)]) async {
    if (_clientSocket == null) return null;
    return futureTimeout<Object?>(
      Future<Object?>(() async {
        while (true) {
          final dataArrived =
              await futureTimeout(_clientStreamIterator!.moveNext(), timeout);
          if (dataArrived != true) return null;

          final strData = utf8.decode(_clientStreamIterator!.current);
          print("GOT: $strData");
          final separatorIndex = strData.indexOf(" ");
          if (separatorIndex == -1) {
            continue;
          }
          final name = strData.substring(0, separatorIndex);
          if (name != commandName) {
            continue;
          }

          final arg = json.decode(strData.substring(separatorIndex + 1));
          return arg;
        }
      }),
      timeout,
    );
  }

  void _forceStopGD() {
    if (_gdProcess != null) {
      _gdProcess!.kill(ProcessSignal.sigkill);
      _gdProcess = null;
      _closeSocket();
    }
  }

  void _closeSocket() {
    _clientSocket?.close();
    _clientStreamIterator?.cancel();
    _serverSocket?.close();
    _clientSocket = null;
    _clientStreamIterator = null;
    _serverSocket = null;
  }

  Future<bool> _runGD({bool tryUseExisting = true}) async {
    if (_gdProcess != null &&
        _serverSocket != null &&
        _clientSocket != null &&
        _clientStreamIterator != null &&
        tryUseExisting) {
      final sent = await _sendCommand("server_ping", 0);
      if (sent) {
        final pong = await _waitForCommand(
          "client_pong",
          Duration(milliseconds: 500),
        );
        if (pong == 0) {
          return true;
        }
      }
    }

    _forceStopGD();

    if (await _winePrefixUserDir.exists()) {
      await _winePrefixUserDir.delete(recursive: true);
    }

    await winePrefixDir.create(recursive: true);

    _gdProcess = await Process.start(
      /// TODO don't hardcode this
      '/nix/store/9jd6ilmdyjbwk21lsk1qdraaj4hp18nr-cage-0.2.0/bin/cage',
      [
        '--',
        'sh',
        '-c',
        'echo WAYLAND:\$WAYLAND_DISPLAY && wine64 ${_gdExecutableFile.path}',
      ],
      workingDirectory: gdDir.path,
      environment: {
        // Wine
        "WINEPREFIX": winePrefixDir.path,
        "WINEDLLOVERRIDES": "XInput1_4.dll=n,b",
        "USER": "showcase", // Scary?
        // Headless
        "WLR_HEADLESS_OUTPUTS": "1",
        "WLR_BACKENDS": "headless",
        "WLR_LIBINPUT_NO_DEVICES": "1",
      },
    );

    _gdProcess!.stderr.listen((event) {
      // print(String.fromCharCodes(event));
    });
    _gdProcess!.stdout.listen((event) {
      final stdoutLines = String.fromCharCodes(event).split("\n");
      for (final line in stdoutLines) {
        if (line.contains("[showcase]")) {
          print(line);
        }
      }
    });

    if (!await _establishSocket()) {
      _forceStopGD();
      return false;
    }

    return true;
  }

  Future<ReplayFeedback> playReplay({
    required int levelID,
    required Uint8List replayData,
    int maxAttempts = 2,
  }) async {
    if (maxAttempts == 0) return ReplayFeedback.unknown;

    final feedback = await futureTimeout(
      _playReplayInternal(
        levelID: levelID,
        replayData: replayData,
      ),
      const Duration(seconds: 30),
    );

    if (feedback == null || feedback == ReplayFeedback.unknown) {
      return playReplay(
        levelID: levelID,
        replayData: replayData,
        maxAttempts: maxAttempts - 1,
      );
    }
    return feedback;
  }

  // Plays a replay and returns success
  Future<ReplayFeedback> _playReplayInternal({
    required int levelID,
    required Uint8List replayData,
  }) async {
    // Run GD and make sure it's ready
    if (!await _runGD()) {
      return ReplayFeedback.unknown;
    }

    // Tell the client the levelID
    if (!await _sendCommand("server_goto_level", {"levelID": levelID})) {
      return ReplayFeedback.unknown;
    }

    // Client tells if the level is valid for replay
    final levelValidInfo =
        await _waitForCommand("client_level_valid", const Duration(seconds: 20))
            as Map<String, dynamic>?;
    if (levelValidInfo == null || levelValidInfo["levelID"] != levelID) {
      return ReplayFeedback.unknown;
    }

    if (!(levelValidInfo["found"] as bool) ||
        !(levelValidInfo["valid"] as bool)) {
      return ReplayFeedback.userBadInput;
    }

    // Write GDR file
    final queueFile = _getReplayQueueFile(levelID);
    await queueFile.create(recursive: true);
    await queueFile.writeAsBytes(replayData);

    await Future.delayed(const Duration(seconds: 2));

    // Client plays level and returns if the replay was successful
    await _sendCommand("server_play_level", {"levelID": levelID});

    final replayResult =
        await _waitForCommand("client_replay_result", Duration(seconds: 10))
            as Map<String, dynamic>?;
    if (replayResult == null || (replayResult["levelID"] as int) != levelID) {
      return ReplayFeedback.unknown;
    }

    if ((replayResult["finished"] as bool) != true) {
      return ReplayFeedback.replayFailed;
    }

    return ReplayFeedback.success;
  }
}

// void test() async {
//   final a = ShowcasePlayer(
//     gdDir: Directory("/home/flafy/Games/data/windows/geometry-dash").absolute,
//     winePrefixDir: Directory("./wine-prefix-test").absolute,
//   );
//   final data = await File(
//           "/home/flafy/Games/wine-prefixes/geometry-dash/drive_c/users/flafy/AppData/Local/GeometryDash/geode/mods/flafy.showcase/queue/977287.gdr")
//       .readAsBytes();
//   final res = await a.playReplay(levelID: 977287, replayData: data);
//   print(res);
// }

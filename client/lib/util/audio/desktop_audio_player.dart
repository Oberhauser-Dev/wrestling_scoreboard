import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:libwinmedia/libwinmedia.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'audio.dart';
import 'mobile_audio_player.dart';

class DesktopAudioPlayer implements Playable {
  late Player player;

  DesktopAudioPlayer() {
    LWM.initialize();
    player = Player(id: 0);
  }

  @override
  Future<void> play() async {
    player.jump(0);
    player.play();
  }

  @override
  setSource(String url) async {
    // Create absolute file path to access it via the player
    Directory directory = await getTemporaryDirectory();
    final tmpPath = join(directory.path, url.split("/").last);
    final tmpFile = File(tmpPath);
    if (!await tmpFile.exists()) {
      ByteData data = await rootBundle.load(url);
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await tmpFile.writeAsBytes(bytes);
    }
    player.open([
      Media(uri: 'file://$tmpPath'),
    ]);
  }

  @override
  void dispose() {
    player.dispose();
  }
}

Playable getAudioPlayer() {
  // Load desktop audio player accordingly, but it cannot be excluded during compile time via conditional imports
  // Therefore DesktopAudioPlayer source code is compiled also for iOS, macOs and Android although it's never used.
  if (!kIsWeb && Platform.isLinux) {
    return DesktopAudioPlayer();
  } else {
    return MobileAudioPlayer();
  }
}

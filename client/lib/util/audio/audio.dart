import 'dart:io';

import 'package:flutter/foundation.dart';

import 'default_audio_player.dart';
import 'desktop_audio_player.dart';

class HornSound {
  static HornSound? _singleton;
  late Playable audioPlayer;
  late Future<void> isSourceSet;

  factory HornSound() {
    _singleton ??= HornSound._internal();
    return _singleton!;
  }

  Future<void> play() async {
    await isSourceSet;
    audioPlayer.play();
  }

  Future<void> dispose() async {
    await isSourceSet;
    audioPlayer.dispose();
    _singleton = null;
  }

  HornSound._internal() {
    if (!kIsWeb && Platform.isLinux || Platform.isWindows) {
      audioPlayer = DesktopAudioPlayer();
    } else {
      audioPlayer = DefaultAudioPlayer();
    }
    isSourceSet = audioPlayer.setSource('assets/audio/BoxingBell.mp3');
  }
}

abstract class Playable {
  Future<void> play();

  Future<void> setSource(String url);

  void dispose();
}

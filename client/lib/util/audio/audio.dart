import 'dart:io';

import 'default_audio_player.dart';
import 'desktop_audio_player.dart';

class HornSound {
  static final HornSound _singleton = HornSound._internal();
  late Playable audioPlayer;

  factory HornSound() {
    return _singleton;
  }

  play() {
    audioPlayer.play();
  }

  HornSound._internal() {
    try {
      if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        audioPlayer = DesktopAudioPlayer();
      } else {
        audioPlayer = DefaultAudioPlayer();
      }
    } catch (e) {
      audioPlayer = DefaultAudioPlayer();
    }
    audioPlayer.source = 'assets/audio/BoxingBell.mp3';
  }
}

abstract class Playable {
  void play();

  set source(String url);
}

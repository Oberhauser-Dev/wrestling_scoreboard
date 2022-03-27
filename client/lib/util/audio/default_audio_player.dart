import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'audio.dart';
import 'linux_audio_player.dart';

class DefaultAudioPlayer implements Playable {
  AudioPlayer player = AudioPlayer();
  Source? source;

  DefaultAudioPlayer();

  @override
  Future<void> play() async {
    if (source != null) player.play(source!);
  }

  @override
  Future<void> stop() async {
    await player.stop();
  }

  @override
  Future<void> setSource(String url) async {
    source = UrlSource(url);
  }

  @override
  Future<void> dispose() async {
    await player.dispose();
  }
}

Playable getAudioPlayer() {
  // Load desktop audio player accordingly, but it cannot be excluded during compile time via conditional imports
  // Therefore DesktopAudioPlayer source code is compiled also for iOS, macOs and Android although it's never used.
  if (!kIsWeb && Platform.isLinux) {
    return LinuxAudioPlayer();
  } else {
    return DefaultAudioPlayer();
  }
}

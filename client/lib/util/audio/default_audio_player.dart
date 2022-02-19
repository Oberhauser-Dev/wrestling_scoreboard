import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'audio.dart';
import 'linux_audio_player.dart';

class DefaultAudioPlayer implements Playable {
  static AudioCache audioCache = AudioCache(prefix: '');
  AudioPlayer? player;
  String url = '';

  DefaultAudioPlayer();

  @override
  Future<void> play() async {
    player = await audioCache.play(url);
    player?.onPlayerCompletion.listen((event) { 
      player?.dispose();
      player = null;
    });
  }

  @override
  Future<void> stop() async {
    await player?.stop();
  }

  @override
  Future<void> setSource(String url) async {
    this.url = url;
    audioCache.load(url);
  }

  @override
  Future<void> dispose() async {
    player?.dispose();
    player = null;
    await audioCache.clearAll();
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

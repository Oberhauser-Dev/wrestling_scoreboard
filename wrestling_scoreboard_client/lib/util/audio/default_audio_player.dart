import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:wrestling_scoreboard_client/util/audio/audio.dart';

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
    if (kIsWeb) {
      source = UrlSource(url);
    } else {
      source = AssetSource(url.replaceFirst('assets/', ''));
    }
  }

  @override
  Future<void> dispose() async {
    await player.dispose();
  }
}

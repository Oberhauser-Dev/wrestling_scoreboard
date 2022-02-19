import 'package:audioplayers/audioplayers.dart';

import 'audio.dart';

class WebAudioPlayer implements Playable {
  AudioPlayer player = AudioPlayer();
  String url = '';

  WebAudioPlayer();

  @override
  Future<void> play() async {
    player.play(url);
  }

  @override
  Future<void> stop() async {
    await player.stop();
  }

  @override
  Future<void> setSource(String url) async {
    this.url = 'assets/' + url; // Need to prefix assets folder as in web it's nested twice
  }

  @override
  Future<void> dispose() async {
    await player.dispose();
  }
}

Playable getAudioPlayer() => WebAudioPlayer();

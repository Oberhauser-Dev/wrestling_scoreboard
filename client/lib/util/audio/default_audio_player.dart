import 'package:audioplayers/audioplayers.dart';

import 'audio.dart';

class DefaultAudioPlayer implements Playable {
  AudioPlayer player = AudioPlayer();
  String url = '';

  DefaultAudioPlayer();

  @override
  Future<void> play() async {
    player.play(url);
  }

  @override
  Future<void> setSource(String url) async {
    this.url = url;
  }

  @override
  void dispose() {
    player.dispose();
  }
}

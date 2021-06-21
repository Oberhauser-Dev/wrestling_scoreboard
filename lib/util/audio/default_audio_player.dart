import 'package:audioplayers/audioplayers.dart';

import 'audio.dart';

class DefaultAudioPlayer implements Playable {
  AudioPlayer player = AudioPlayer();
  String url = '';

  DefaultAudioPlayer();

  @override
  void play() async {
    player.play(url);
  }

  @override
  set source(String url) {
    this.url = url;
  }
}

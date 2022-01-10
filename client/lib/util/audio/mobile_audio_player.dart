import 'package:audioplayers/audioplayers.dart';

import 'audio.dart';

class MobileAudioPlayer implements Playable {
  AudioCache player = AudioCache(prefix: '');
  String url = '';

  MobileAudioPlayer();

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
    player.clearAll();
  }
}

Playable getAudioPlayer() => MobileAudioPlayer();

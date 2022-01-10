import 'stub_audio_player.dart'
if (dart.library.js) 'web_audio_player.dart'
if (dart.library.io) 'desktop_audio_player.dart';

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
    audioPlayer = getAudioPlayer();
    isSourceSet = audioPlayer.setSource('assets/audio/BoxingBell.mp3');
  }
}

abstract class Playable {
  Future<void> play();

  Future<void> setSource(String url);

  void dispose();
}

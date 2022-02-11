import 'package:wrestling_scoreboard/ui/settings/preferences.dart';
import 'package:wrestling_scoreboard/util/environment.dart';

import 'stub_audio_player.dart'
    if (dart.library.js) 'web_audio_player.dart'
    if (dart.library.io) 'desktop_audio_player.dart';

class HornSound {
  static HornSound? _singleton;
  late Playable audioPlayer;
  late Future<void> isSourceSet;

  factory HornSound() {
    _singleton ??= HornSound._fromPreference();
    return _singleton!;
  }
  
  factory HornSound.source(String source) {
    _singleton ??= HornSound._fromSource(source);
    return _singleton!;
  }

  Future<void> play() async {
    await isSourceSet;
    await audioPlayer.play();
  }

  Future<void> dispose() async {
    await isSourceSet;
    audioPlayer.dispose();
    _singleton = null;
  }

  HornSound._fromSource(String source) {
    audioPlayer = getAudioPlayer();
    isSourceSet = audioPlayer.setSource(source);
  }
  
  HornSound._fromPreference() {
    audioPlayer = getAudioPlayer();
    isSourceSet = Preferences.getString(Preferences.keyBellSound)
        .then((value) => audioPlayer.setSource(value ?? env(bellSoundPath)));
    Preferences.onChangeBellSound.stream.listen((event) {
      isSourceSet = audioPlayer.setSource(event);
    });
  }
}

abstract class Playable {
  Future<void> play();

  Future<void> setSource(String url);

  void dispose();
}

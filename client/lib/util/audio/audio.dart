import 'package:wrestling_scoreboard/ui/settings/preferences.dart';
import 'package:wrestling_scoreboard/util/environment.dart';

import 'default_audio_player.dart';

class HornSound {
  late Playable audioPlayer;
  late Future<void> isSourceSet;

  factory HornSound() {
    return HornSound._fromPreference();
  }
  
  factory HornSound.source(String source) {
    return HornSound._fromSource(source);
  }

  Future<void> play() async {
    await isSourceSet;
    await audioPlayer.play();
  }

  Future<void> stop() async {
    await isSourceSet;
    await audioPlayer.stop();
  }

  Future<void> dispose() async {
    await isSourceSet;
    await audioPlayer.dispose();
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
  
  Future<void> stop();

  Future<void> setSource(String url);

  Future<void> dispose();
}

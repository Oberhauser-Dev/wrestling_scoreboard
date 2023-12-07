import 'package:audioplayers/audioplayers.dart';
import 'package:wrestling_scoreboard_client/ui/settings/preferences.dart';
import 'package:wrestling_scoreboard_client/util/environment.dart';

class HornSound {
  static AudioPlayer audioPlayer = AudioPlayer();

  static Future<void> init() async {
    final bellSound = await Preferences.getString(Preferences.keyBellSound);
    await audioPlayer.setSource(AssetSource(bellSound ?? Env.bellSoundPath.fromString()));
    Preferences.onChangeBellSound.stream.listen((path) async {
      await audioPlayer.setSource(AssetSource(path));
    });
  }

  static Future<void> play() async {
    await audioPlayer.resume();
  }

  static Future<void> stop() async {
    await audioPlayer.stop();
  }

  static Future<void> dispose() async {
    await audioPlayer.dispose();
  }
}

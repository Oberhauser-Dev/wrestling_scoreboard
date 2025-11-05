import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';

part 'audio_provider.g.dart';

@Riverpod(keepAlive: true)
class BellPlayerNotifier extends _$BellPlayerNotifier {
  @override
  Raw<Future<AudioPlayer>> build() async {
    final audioPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    ref.onDispose(() async {
      await audioPlayer.dispose();
    });

    final soundPath = await ref.watch(bellSoundProvider);
    await audioPlayer.setSource(AssetSource(soundPath));
    return audioPlayer;
  }
}

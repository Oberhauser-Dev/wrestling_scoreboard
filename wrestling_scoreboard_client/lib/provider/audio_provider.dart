import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';

part 'audio_provider.g.dart';

@Riverpod(keepAlive: true)
class BellPlayerNotifier extends _$BellPlayerNotifier {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Raw<Future<AudioPlayer>> build() async {
    ref.onDispose(() async {
      await _audioPlayer.dispose();
    });

    final soundPath = await ref.watch(bellSoundNotifierProvider);
    await _audioPlayer.setSource(AssetSource(soundPath));
    return _audioPlayer;
  }
}

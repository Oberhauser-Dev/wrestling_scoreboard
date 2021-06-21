// import 'package:dart_vlc/dart_vlc.dart';

import 'audio.dart';

class DesktopAudioPlayer implements Playable {
  // Player player = Player(id: 1337);

  DesktopAudioPlayer();

  @override
  void play() async {
    // player.play();
    throw UnimplementedError('Desktop Audio is not supported yet!');
  }

  @override
  set source(String url) {
    /*(() async {
      Media media = await Media.asset(url);
      player.open(media);
    })();*/
  }
}

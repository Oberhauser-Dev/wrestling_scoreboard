import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/mocks/mock_data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/util/environment.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_client/util/network/remote/rest.dart';
import 'package:wrestling_scoreboard_client/util/network/remote/web_socket.dart';

part 'network_provider.g.dart';

final _isMock = Env.appEnvironment.fromString() == 'mock';

@Riverpod(keepAlive: true)
class DataManagerNotifier extends _$DataManagerNotifier {
  @override
  Raw<Future<DataManager>> build() async {
    final apiUrl = await ref.watch(apiUrlNotifierProvider);
    final wsUrl = await ref.watch(webSocketUrlNotifierProvider);

    // TODO: override with mock via rivperpod overrides.
    final dataManager = _isMock ? MockDataManager() : RestDataManager(apiUrl: apiUrl, wsUrl: wsUrl);
    return dataManager;
  }
}

@Riverpod(keepAlive: true)
Stream<WebSocketConnectionState> webSocketStateStream(WebSocketStateStreamRef ref) async* {
  final dataManager = await ref.watch(dataManagerNotifierProvider);
  // TODO: integrate in updating websocket URL from stream provider
  final webSocketConnectionStream = dataManager.webSocketManager.onWebSocketConnection.stream
      .distinct()
      .where((event) => event == WebSocketConnectionState.disconnected || event == WebSocketConnectionState.connected);
  yield* webSocketConnectionStream;
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_client/util/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_client/mocks/mock_data_provider.dart';
import 'package:wrestling_scoreboard_client/util/environment.dart';
import 'package:wrestling_scoreboard_client/util/network/remote/rest.dart';

part 'network_provider.g.dart';

final _isMock = Env.appEnvironment.fromString() == 'mock';

@Riverpod(keepAlive: true)
class DataManager extends _$DataManager {
  @override
  Raw<DataProvider> build() {
    // TODO: override with mock via rivperpod overrides.
    final dataProvider = _isMock ? MockDataProvider() : RestDataProvider();
    return dataProvider;
  }
}

@Riverpod(keepAlive: true)
Stream<WebSocketConnectionState> webSocketStateStream(WebSocketStateStreamRef ref) {
  final dataManager = ref.watch(dataManagerProvider);
  // TODO: integrate in updating websocket URL from stream provider
  final webSocketConnectionStream = dataManager.webSocketManager.onWebSocketConnection.stream
      .distinct()
      .where((event) => event == WebSocketConnectionState.disconnected || event == WebSocketConnectionState.connected);
  return webSocketConnectionStream;
}



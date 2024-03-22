import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/mocks/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';

part 'network_provider.g.dart';

@Riverpod(keepAlive: true)
class MockDataManagerNotifier extends _$MockDataManagerNotifier implements DataManagerNotifier {
  @override
  Raw<Future<DataManager>> build() async {
    return MockDataManager();
  }
}

@Riverpod(keepAlive: true)
class MockWebsocketManagerNotifier extends _$MockWebsocketManagerNotifier implements WebSocketManagerNotifier {
  @override
  Raw<Future<WebSocketManager>> build() async {
    final dataManager = await ref.watch(mockDataManagerNotifierProvider);
    final webSocketManager = MockWebSocketManager(dataManager);
    dataManager.webSocketManager = webSocketManager;
    return webSocketManager;
  }
}

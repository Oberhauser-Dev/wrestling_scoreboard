import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/local/local_data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/local/local_web_socket.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_common/common.dart';

part 'local_providers.g.dart';

@Riverpod(keepAlive: true, dependencies: [DataManagerNotifier])
class LocalWebsocketManagerNotifier extends _$LocalWebsocketManagerNotifier implements WebSocketManagerNotifier {
  @override
  Raw<Future<WebSocketManager>> build() async {
    final dataManager = await ref.watch(dataManagerProvider);
    final webSocketManager = LocalWebSocketManager(dataManager);
    dataManager.webSocketManager = webSocketManager;
    return webSocketManager;
  }
}

/// [LocalDataManager] uses [LocalDataNotifier] internally, so need to list it as dependency.
@Riverpod(keepAlive: true, dependencies: [LocalDataNotifier])
class LocalDataManagerNotifier extends _$LocalDataManagerNotifier implements DataManagerNotifier {
  @override
  Raw<Future<DataManager>> build() async {
    return LocalDataManager(
      <T extends DataObject>() => ref.read(localDataProvider<T>().notifier),
      <T extends DataObject>() async => await ref.read(localDataProvider<T>()),
    );
  }
}

@Riverpod(keepAlive: true)
class LocalDataNotifier<T extends DataObject> extends _$LocalDataNotifier<T> {
  @override
  Raw<Future<List<Map<String, dynamic>>>> build() async {
    final jsonList = await Preferences.getStringList(getTableNameFromType(T) + Preferences.keyDataSuffix);
    final List<Map<String, dynamic>> result = [];
    if (jsonList != null) {
      result.addAll(jsonList.map((json) => jsonDecode(json)));
    }
    return result;
  }

  Future<void> setState(List<T>? val) async {
    final raw = val?.map((e) => e.toRaw()).toList();
    await setStateRaw(raw);
  }

  Future<void> setStateRaw(List<Map<String, dynamic>>? val) async {
    state = Future.value(val);
    final dataAsStr = val?.map((e) => jsonEncode(e)).toList();
    await Preferences.setStringList(getTableNameFromType(T) + Preferences.keyDataSuffix, dataAsStr);
  }
}

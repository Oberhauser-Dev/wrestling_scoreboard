import 'dart:convert';
import 'dart:math' as math;

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
    final dataManager = await ref.watch(dataManagerNotifierProvider);
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
      <T extends DataObject>() => ref.read(localDataNotifierProvider<T>().notifier),
      <T extends DataObject>() async => await ref.read(localDataNotifierProvider<T>()),
    );
  }
}

@Riverpod(keepAlive: true)
class LocalDataNotifier<T extends DataObject> extends _$LocalDataNotifier<T> {
  final organization = Organization(id: 0, name: 'Organization');
  late final person0 = Person(id: 0, prename: 'Red', surname: '');
  late final person1 = Person(id: 1, prename: 'Blue', surname: '');
  late final club0 = Club(id: 0, organization: organization, name: 'Home');
  late final club1 = Club(id: 1, organization: organization, name: 'Guest');
  late final membership0 = Membership(id: 0, club: club0, person: person0);
  late final membership1 = Membership(id: 1, club: club1, person: person1);
  late final athleteBoutState0 = AthleteBoutState(id: 0, membership: membership0);
  late final athleteBoutState1 = AthleteBoutState(id: 1, membership: membership1);
  late final bout = Bout(id: 0, r: athleteBoutState0, b: athleteBoutState1);
  late final weightClassFree = WeightClass(id: 0, weight: 0, style: WrestlingStyle.free);
  late final weightClassGreco = WeightClass(id: 1, weight: 0, style: WrestlingStyle.greco);

  final boutConfig = Competition.defaultBoutConfig.copyWithId(0);
  late final boutResultRules =
      Competition.defaultBoutResultRules.indexed.map((e) => e.$2.copyWith(id: e.$1, boutConfig: boutConfig)).toList();

  late final scratchBout = ScratchBout(id: 0, bout: bout, boutConfig: boutConfig, weightClass: weightClassFree);

  @override
  Raw<Future<List<Map<String, dynamic>>>> build() async {
    final jsonList = await Preferences.getStringList(getTableNameFromType(T) + Preferences.keyDataSuffix);
    final List<Map<String, dynamic>> result = [];
    if (jsonList != null) {
      result.addAll(jsonList.map((json) => jsonDecode(json)));
    }

    // Provide a set of default entities to create a scratch bout
    final List<T> defaultEntities = switch (T) {
      const (Bout) => [bout as T],
      const (Organization) => [organization as T],
      const (AthleteBoutState) => [athleteBoutState0 as T, athleteBoutState1 as T],
      const (Membership) => [membership0 as T, membership1 as T],
      const (Club) => [club0 as T, club1 as T],
      const (Person) => [person0 as T, person1 as T],
      const (BoutConfig) => [boutConfig as T],
      // Only add Bout Result Rule, if empty, otherwise it would add random rules which the user does not expect
      const (BoutResultRule) => result.isEmpty ? boutResultRules.cast<T>() : [],
      const (WeightClass) => [weightClassFree as T, weightClassGreco as T],
      const (ScratchBout) => [scratchBout as T],
      _ => [],
    };
    final diff = defaultEntities.map((e) => e.id).toSet().difference(result.map((e) => e['id']).toSet());
    if (diff.isNotEmpty) {
      // Always add default entities which were not saved yet.
      result.addAll(diff.map((id) => defaultEntities.singleWhere((e) => e.id == id).toRaw()));
    }
    LocalDataManager.idCounter[T] = result.fold(
      LocalDataManager.idCounter[T] ?? 0,
      (value, element) => math.max(value, element['id'] ?? 0),
    );
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

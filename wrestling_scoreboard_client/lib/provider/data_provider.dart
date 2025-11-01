// TODO: move util/network/data_provider into riverpod provider
// See for examples: https://riverpod.dev/docs/essentials/side_effects#updating-our-local-cache-to-match-the-api-response

import 'dart:async';

import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

part 'data_provider.g.dart';

/// Class to wrap equal single data for providers.
class SingleProviderData<T extends DataObject> {
  final int id;
  final T? initialData;

  SingleProviderData({required this.id, this.initialData});

  @override
  bool operator ==(Object other) => identical(this, other) || other is SingleProviderData<T> && id == other.id;

  @override
  int get hashCode => Object.hash(id, T);
}

@Riverpod(dependencies: [webSocketStateStream, DataManagerNotifier])
Stream<T> singleDataStream<T extends DataObject>(Ref ref, SingleProviderData<T> pData) async* {
  ref.cache();

  final dataManager = await ref.watch(dataManagerProvider);
  if (pData.initialData != null) {
    yield pData.initialData!;
  }

  final dataStream = dataManager.streamSingle<T>(pData.id, init: pData.initialData == null);

  // Reload, whenever the stream is connected
  final connectionStateStreamController = StreamController<T>();
  final sub = ref.listen(webSocketStateStreamProvider.future, (previous, next) async {
    final wsConnectionState = await next;
    if (wsConnectionState == WebSocketConnectionState.connected) {
      connectionStateStreamController.add(await dataManager.readSingle<T>(pData.id));
    } else if (wsConnectionState == WebSocketConnectionState.disconnected) {
      connectionStateStreamController.addError(
        Exception('Server disconnected\nSingleDataStreamProvider: $T (id: ${pData.id})'),
      );
    }
  });
  ref.onDispose(() => sub.close());

  yield* StreamGroup.merge([dataStream, connectionStateStreamController.stream]);
}

/// Class to wrap equal many data for providers.
class ManyProviderData<T extends DataObject, S extends DataObject?> {
  final S? filterObject;

  ManyProviderData({this.filterObject});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ManyProviderData<T, S> &&
            ((filterObject == null && other.filterObject == null) || (filterObject?.id == other.filterObject?.id));
  }

  @override
  int get hashCode => Object.hash(filterObject?.id, T, S);
}

@Riverpod(dependencies: [webSocketStateStream, DataManagerNotifier])
Stream<List<T>> manyDataStream<T extends DataObject, S extends DataObject?>(
  Ref ref,
  ManyProviderData<T, S> pData,
) async* {
  ref.cache();

  final dataManager = await ref.watch(dataManagerProvider);

  final dataStream = dataManager
      .streamMany<T, S>(filterObject: pData.filterObject)
      .map((event) => event.data);

  // Reload, whenever the stream is connected
  final connectionStateStreamController = StreamController<List<T>>();
  final sub = ref.listen(webSocketStateStreamProvider.future, (previous, next) async {
    final wsConnectionState = await next;
    if (wsConnectionState == WebSocketConnectionState.connected) {
      connectionStateStreamController.add(await dataManager.readMany<T, S>(filterObject: pData.filterObject));
    } else if (wsConnectionState == WebSocketConnectionState.disconnected) {
      connectionStateStreamController.addError(
        Exception('Server disconnected\nManyDataStreamProvider: $T, $S (filterObject: ${pData.filterObject})'),
      );
    }
  });
  ref.onDispose(() => sub.close());

  yield* StreamGroup.merge([dataStream, connectionStateStreamController.stream]);
}

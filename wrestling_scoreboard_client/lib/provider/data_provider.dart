// TODO: move util/network/data_provider into riverpod provider
// See for examples: https://riverpod.dev/docs/essentials/side_effects#updating-our-local-cache-to-match-the-api-response

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
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

@riverpod
Stream<T> singleDataStream<T extends DataObject>(
  SingleDataStreamRef ref, 
  SingleProviderData<T> pData,
) async* {
  // Reload, whenever the stream connects or disconnects
  // TODO: integrate in updating websocket URL from stream provider
  ref.watch(webSocketStateStreamProvider);

  // ref.onDispose(webSocketConnectionStream.close);
  // TODO: e.g. may be triggered twice
  if(pData.initialData != null) {
    yield pData.initialData!;
  }
  yield* dataProvider.streamSingle<T>(pData.id, init: pData.initialData == null);
}

/// Class to wrap equal many data for providers.
class ManyProviderData<T extends DataObject, S extends DataObject?> {
  final S? filterObject;
  final List<T>? initialData;

  ManyProviderData({this.filterObject, this.initialData});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ManyProviderData<T, S> &&
            (filterObject == null && other.filterObject == null || filterObject?.id == other.filterObject?.id);
  }

  @override
  int get hashCode => Object.hash(filterObject?.id, T, S);
}

@riverpod
Stream<List<T>> manyDataStream<T extends DataObject, S extends DataObject?>(
  ManyDataStreamRef ref, 
  ManyProviderData<T,S> pData,
) async* {
  // Reload, whenever the stream connects or disconnects
  // TODO: integrate in updating websocket URL from stream provider
  ref.watch(webSocketStateStreamProvider);

  // ref.onDispose(webSocketConnectionStream.close);
  // TODO: e.g. bout action event triggered twice
  if(pData.initialData != null) {
    yield pData.initialData!;
  }
  yield* dataProvider
      .streamMany<T, S>(filterObject: pData.filterObject, init: pData.initialData == null)
      .map((event) => event.data);
}

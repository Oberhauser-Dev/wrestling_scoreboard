// TODO: move util/network/data_provider into riverpod provider
// See for examples: https://riverpod.dev/docs/essentials/side_effects#updating-our-local-cache-to-match-the-api-response

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

part 'data_provider.g.dart';

@riverpod
Stream<T> singleDataStream<T extends DataObject>(
    SingleDataStreamRef ref, {
      required int id,
      T? initialData,
    }) {
  // Reload, whenever the stream connects or disconnects
  // TODO: integrate in updating websocket URL from stream provider
  ref.watch(webSocketStateStreamProvider);

  // ref.onDispose(webSocketConnectionStream.close);
  // TODO: e.g. may be triggered twice
  return dataProvider
      .streamSingle<T>(id, init: initialData == null);
}

@riverpod
Stream<List<T>> manyDataStream<T extends DataObject, S extends DataObject?>(
  ManyDataStreamRef ref, {
  S? filterObject,
  List<T>? initialData,
}) {
  // Reload, whenever the stream connects or disconnects
  // TODO: integrate in updating websocket URL from stream provider
  ref.watch(webSocketStateStreamProvider);

  // ref.onDispose(webSocketConnectionStream.close);
  // TODO: e.g. bout action event triggered twice
  return dataProvider
      .streamMany<T, S>(filterObject: filterObject, init: initialData == null)
      .map((event) => event.data);
}

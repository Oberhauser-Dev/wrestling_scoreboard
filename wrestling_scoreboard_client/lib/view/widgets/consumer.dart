import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_client/view/widgets/exception.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class NullableSingleConsumer<T extends DataObject> extends ConsumerWidget {
  final T? initialData;
  final int? id;
  final Widget Function(BuildContext context, T? data) builder;
  final Widget Function(BuildContext context, Object? exception, {StackTrace? stackTrace})? onException;

  const NullableSingleConsumer({
    required this.builder,
    this.onException,
    required this.id,
    this.initialData,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id == null && initialData?.id == null) {
      return builder(context, initialData);
    }
    final stream = ref.watch(
      singleDataStreamProvider<T>(SingleProviderData<T>(initialData: initialData, id: id ?? initialData!.id!)).future,
    );
    return LoadingBuilder<T>(
      builder: builder,
      future: stream,
      initialData: null,
      // Handle initial data via the stream
      onRetry:
          () async => (await ref.read(
            webSocketManagerProvider,
          )).onWebSocketConnection.sink.add(WebSocketConnectionState.connecting),
      onException: onException,
    );
  }
}

class SingleConsumer<T extends DataObject> extends StatelessWidget {
  final T? initialData;
  final int? id;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context, Object? exception, {StackTrace? stackTrace})? onException;

  const SingleConsumer({required this.builder, required this.id, this.initialData, super.key, this.onException});

  @override
  Widget build(BuildContext context) {
    if (id == null && initialData == null) {
      return onException?.call(context, null) ?? ExceptionCard(context.l10n.notFoundException, stackTrace: null);
    }
    return NullableSingleConsumer(
      builder: (BuildContext context, T? data) {
        if (data == null) {
          return onException?.call(context, null) ?? ExceptionCard(context.l10n.notFoundException, stackTrace: null);
        }
        return builder(context, data);
      },
      id: id,
      initialData: initialData,
      onException: onException,
    );
  }
}

class ManyConsumer<T extends DataObject, S extends DataObject?> extends ConsumerWidget {
  final S? filterObject;
  final Widget Function(BuildContext context, List<T> data) builder;
  final Widget Function(BuildContext context, Object? exception, {StackTrace? stackTrace})? onException;

  const ManyConsumer({required this.builder, this.onException, this.filterObject, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(manyDataStreamProvider<T, S>(ManyProviderData<T, S>(filterObject: filterObject)).future);
    return LoadingBuilder<List<T>>(
      builder: builder,
      future: stream,
      initialData: null,
      // Handle initial data via the stream
      onRetry:
          () async => (await ref.read(
            webSocketManagerProvider,
          )).onWebSocketConnection.sink.add(WebSocketConnectionState.connecting),
      onException: onException,
    );
  }
}

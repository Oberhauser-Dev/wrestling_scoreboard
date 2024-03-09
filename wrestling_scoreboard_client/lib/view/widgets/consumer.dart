import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/exception.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class NullableSingleConsumer<T extends DataObject> extends ConsumerWidget {
  final T? initialData;
  final int? id;
  final Widget Function(BuildContext context, T? data) builder;

  const NullableSingleConsumer({
    required this.builder,
    required this.id,
    this.initialData,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id == null) {
      return builder(context, initialData);
    }
    final stream =
        ref.watch(singleDataStreamProvider<T>(SingleProviderData<T>(initialData: initialData, id: id!)).future);
    return LoadingBuilder<T>(
      builder: builder,
      future: stream,
      initialData: null, // Handle initial data via the stream
      onRetry: () async => (await ref.read(dataManagerNotifierProvider))
          .webSocketManager
          .onWebSocketConnection
          .sink
          .add(WebSocketConnectionState.connecting),
    );
  }
}

class SingleConsumer<T extends DataObject> extends StatelessWidget {
  final T? initialData;
  final int? id;
  final Widget Function(BuildContext context, T data) builder;

  const SingleConsumer({
    required this.builder,
    required this.id,
    this.initialData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (id == null && initialData == null) {
      return ExceptionWidget(AppLocalizations.of(context)!.notFoundException, stackTrace: null);
    }
    return NullableSingleConsumer(
        builder: (BuildContext context, T? data) {
          if (data == null) {
            return ExceptionWidget(AppLocalizations.of(context)!.notFoundException, stackTrace: null);
          }
          return builder(context, data);
        },
        id: id,
        initialData: initialData);
  }
}

class ManyConsumer<T extends DataObject, S extends DataObject?> extends ConsumerWidget {
  final List<T>? initialData;
  final S? filterObject;
  final Widget Function(BuildContext context, List<T> data) builder;

  const ManyConsumer({required this.builder, this.initialData, this.filterObject, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(
        manyDataStreamProvider<T, S>(ManyProviderData<T, S>(initialData: initialData, filterObject: filterObject))
            .future);
    return LoadingBuilder<List<T>>(
      builder: builder,
      future: stream,
      initialData: null, // Handle initial data via the stream
      onRetry: () async => (await ref.read(dataManagerNotifierProvider))
          .webSocketManager
          .onWebSocketConnection
          .sink
          .add(WebSocketConnectionState.connecting),
    );
  }
}

/*
// TODO: can be removed, if only relying on riverpod and https://github.com/rrousselGit/riverpod/issues/1119 is solved
class SingleConsumer<T extends DataObject> extends StatefulWidget {
  final int? id;
  final T? initialData;
  final Widget Function(BuildContext context, T? data) builder;

  const SingleConsumer({
    required this.id,
    this.initialData,
    required this.builder,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => SingleConsumerState<T>();
}

class SingleConsumerState<T extends DataObject> extends State<SingleConsumer<T>> {
  late Stream<WebSocketConnectionState> webSocketConnectionStream;

  @override
  void initState() {
    super.initState();
    webSocketConnectionStream = WebSocketManager.onWebSocketConnection.stream.distinct().where(
        (event) => event == WebSocketConnectionState.disconnected || event == WebSocketConnectionState.connected);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: webSocketConnectionStream,
      builder: (context, snapshot) => widget.id == null
          ? widget.builder(context, widget.initialData)
          : StreamBuilder<T>(
              stream:
                  widget.id == null ? null :  ref.read(dataManagerNotifierProvider).streamSingle<T>(widget.id!, init: widget.initialData == null),
              initialData: widget.initialData,
              builder: (BuildContext context, AsyncSnapshot<T> snap) {
                if (snap.hasError) {
                  return ExceptionWidget(snap.error!, onRetry: () {
                    WebSocketManager.onWebSocketConnection.sink.add(WebSocketConnectionState.connecting);
                  });
                }
                if (snap.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return widget.builder(context, snap.data);
              },
            ),
    );
  }
}

class ManyConsumer<T extends DataObject, S extends DataObject?> extends StatefulWidget {
  final List<T>? initialData;
  final S? filterObject;
  final Widget Function(BuildContext context, List<T> data) builder;

  const ManyConsumer({this.initialData, required this.builder, this.filterObject, super.key});

  @override
  State<StatefulWidget> createState() => ManyConsumerState<T, S>();
}

class ManyConsumerState<T extends DataObject, S extends DataObject?> extends State<ManyConsumer<T, S>> {
  late Stream<WebSocketConnectionState> webSocketConnectionStream;

  @override
  void initState() {
    super.initState();
    webSocketConnectionStream = WebSocketManager.onWebSocketConnection.stream.distinct().where(
        (event) => event == WebSocketConnectionState.disconnected || event == WebSocketConnectionState.connected);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: webSocketConnectionStream,
      builder: (context, snapshot) {
        final stream =
             ref.read(dataManagerNotifierProvider).streamMany<T, S>(filterObject: widget.filterObject, init: widget.initialData == null);
        final initialData = widget.initialData == null ? null : ManyDataObject<T>(data: widget.initialData!);
        return LoadingStreamBuilder(
          builder: (context, data) => widget.builder(context, data.data),
          stream: stream,
          initialData: initialData,
          onRetry: () => WebSocketManager.onWebSocketConnection.sink.add(WebSocketConnectionState.connecting),
        );
      },
    );
  }
}
*/

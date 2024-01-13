import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/ui/components/exception.dart';
import 'package:wrestling_scoreboard_client/ui/components/loading_builder.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_client/util/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_common/common.dart';

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
          ? widget.builder(context, null)
          : StreamBuilder<T>(
              stream:
                  widget.id == null ? null : dataProvider.streamSingle<T>(widget.id!, init: widget.initialData == null),
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
            dataProvider.streamMany<T, S>(filterObject: widget.filterObject, init: widget.initialData == null);
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

class ManyStreamConsumer<T extends DataObject, S extends DataObject?> extends ConsumerWidget {
  final List<T>? initialData;
  final S? filterObject;
  final Widget Function(BuildContext context, List<T> data) builder;

  const ManyStreamConsumer({required this.builder, this.initialData, this.filterObject, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(manyDataStreamProvider<T, S>(initialData: initialData, filterObject: filterObject));
    return LoadingStreamBuilder<List<T>>(
      builder: builder,
      stream: stream,
      initialData: initialData,
      onRetry: () => WebSocketManager.onWebSocketConnection.sink.add(WebSocketConnectionState.connecting),
    );
  }
}

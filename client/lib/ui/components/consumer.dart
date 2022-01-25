import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard/ui/components/exception.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';
import 'package:wrestling_scoreboard/util/network/remote/web_socket.dart';

class SingleConsumer<T extends DataObject> extends StatefulWidget {
  final int? id;
  final T? initialData;
  final Widget Function(BuildContext context, T? data) builder;

  const SingleConsumer({required this.id, this.initialData, required this.builder, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SingleConsumerState<T>();
}

class SingleConsumerState<T extends DataObject> extends State<SingleConsumer<T>> {
  late Stream<bool> webSocketConnectingStream;
  late Stream<T>? singleStream;

  @override
  void initState() {
    super.initState();
    webSocketConnectingStream = WebSocketManager.onWebSocketConnecting.stream.distinct();
    singleStream = widget.id == null
        ? null
        : dataProvider.streamSingle<T>(widget.id!, init: widget.initialData == null).distinct();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: webSocketConnectingStream,
      builder: (_, __) => widget.id == null
          ? widget.builder(context, null)
          : StreamBuilder<T>(
              stream: singleStream,
              initialData: widget.initialData,
              builder: (BuildContext context, AsyncSnapshot<T> snap) {
                if (snap.hasError) {
                  return ExceptionWidget(snap.error!, () {
                    WebSocketManager.onWebSocketConnecting.sink.add(true);
                  });
                }
                return widget.builder(context, snap.data!);
              },
            ),
    );
  }
}

class ManyConsumer<T extends DataObject> extends StatefulWidget {
  final List<T>? initialData;
  final DataObject? filterObject;
  final Widget Function(BuildContext context, List<T> data) builder;

  const ManyConsumer({this.initialData, required this.builder, this.filterObject, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ManyConsumerState<T>();
}

// TODO add const CircularProgressIndicator() on load
class ManyConsumerState<T extends DataObject> extends State<ManyConsumer<T>> {
  late Stream<bool> webSocketConnectingStream;
  late Stream<ManyDataObject<T>> manyStream;

  @override
  void initState() {
    super.initState();
    webSocketConnectingStream = WebSocketManager.onWebSocketConnecting.stream.distinct();
    manyStream =
        dataProvider.streamMany<T>(filterObject: widget.filterObject, init: widget.initialData == null).distinct();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: webSocketConnectingStream,
      builder: (_, __) => StreamBuilder(
        stream: manyStream,
        initialData: ManyDataObject<T>(data: widget.initialData ?? []),
        builder: (BuildContext context, AsyncSnapshot<ManyDataObject<T>> snap) {
          if (snap.hasError) {
            return ExceptionWidget(snap.error!, () {
              WebSocketManager.onWebSocketConnecting.sink.add(true);
            });
          }
          return widget.builder(context, snap.data!.data);
        },
      ),
    );
  }
}

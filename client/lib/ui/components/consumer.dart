import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard/ui/components/exception.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';
import 'package:wrestling_scoreboard/util/network/remote/web_socket.dart';

class SingleConsumer<T extends DataObject> extends StatelessWidget {
  final int? id;
  final T? initialData;
  final Widget Function(BuildContext context, T? data) builder;

  const SingleConsumer({required this.id, this.initialData, required this.builder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: WebSocketManager.onWebSocketConnecting.stream.distinct(),
      builder: (_, __) => id == null ? builder(context, null) :  StreamBuilder<T>(
        stream: dataProvider.streamSingle<T>(id!, init: initialData == null),
        initialData: initialData,
        builder: (BuildContext context, AsyncSnapshot<T> snap) {
          if (snap.hasError) {
            return ExceptionWidget(snap.error!, () {
              WebSocketManager.onWebSocketConnecting.sink.add(true);
            });
          }
          return builder(context, snap.data!);
        },
      ),
    );
  }
}

class ManyConsumer<T extends DataObject> extends StatelessWidget {
  final List<T>? initialData;
  final DataObject? filterObject;
  final Widget Function(BuildContext context, List<T> data) builder;

  const ManyConsumer({this.initialData, required this.builder, this.filterObject, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: WebSocketManager.onWebSocketConnecting.stream.distinct(),
      builder: (_, __) => StreamBuilder(
        stream: dataProvider.streamMany<T>(filterObject: filterObject, init: initialData == null),
        initialData: ManyDataObject<T>(data: initialData ?? []),
        builder: (BuildContext context, AsyncSnapshot<ManyDataObject<T>> snap) {
          if (snap.hasError) {
            return ExceptionWidget(snap.error!, () {
              WebSocketManager.onWebSocketConnecting.sink.add(true);
            });
          }
          return builder(context, snap.data!.data);
        },
      ),
    );
  }
}

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard/ui/components/exception.dart';
import 'package:wrestling_scoreboard/ui/settings/settings.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

// TODO may use isConnected Stream and another StreamBuilder to replace StatefulWidget, this would also update all other widgets simultaneously
class SingleConsumer<T extends DataObject, S extends T> extends StatefulWidget {
  final int id;
  final S? initialData;
  final Widget Function(BuildContext context, S data) builder;

  const SingleConsumer({required this.id, this.initialData, required this.builder, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SingleConsumerState<T, S>();
}

class SingleConsumerState<T extends DataObject, S extends T> extends State<SingleConsumer<T, S>> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      stream: dataProvider.streamSingle<T, S>(widget.id, init: widget.initialData == null),
      initialData: widget.initialData,
      builder: (BuildContext context, AsyncSnapshot<S> snap) {
        if (snap.hasError) {
          return ExceptionWidget(snap.error!, () {
            CustomSettingsScreen.onConnectWebSocket.sink.add(null);
            setState(() {});
          });
        }
        return widget.builder(context, snap.data!);
      },
    );
  }
}

class ManyConsumer<T extends DataObject, S extends T> extends StatefulWidget {
  final List<S>? initialData;
  final DataObject? filterObject;
  final Widget Function(BuildContext context, List<S> data) builder;

  const ManyConsumer({this.initialData, required this.builder, this.filterObject, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ManyConsumerState<T, S>();
}

class ManyConsumerState<T extends DataObject, S extends T> extends State<ManyConsumer<T, S>> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dataProvider.streamMany<T, S>(filterObject: widget.filterObject, init: widget.initialData == null),
      initialData: ManyDataObject<S>(data: widget.initialData ?? []),
      builder: (BuildContext context, AsyncSnapshot<ManyDataObject<S>> snap) {
        if (snap.hasError) {
          return ExceptionWidget(snap.error!, () {
            CustomSettingsScreen.onConnectWebSocket.sink.add(null);
            setState(() {});
          });
        }
        return widget.builder(context, snap.data!.data);
      },
    );
  }
}

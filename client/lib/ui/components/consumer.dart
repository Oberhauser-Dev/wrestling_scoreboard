import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class SingleConsumer<T extends DataObject> extends StatelessWidget {
  final T initialData;
  final Widget Function(BuildContext context, T data) builder;

  const SingleConsumer({required this.initialData, required this.builder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: dataProvider.streamSingle<T>(initialData.runtimeType, initialData.id!, init: false),
      initialData: initialData,
      builder: (BuildContext context, AsyncSnapshot<T> snap) {
        if (snap.hasError) {
          throw snap.error!;
        }
        return builder(context, snap.data!);
      },
    );
  }
}

class ManyConsumer<T extends DataObject> extends StatelessWidget {
  final Iterable<T> initialData;
  final DataObject? filterObject;
  final Widget Function(BuildContext context, Iterable<T> data) builder;

  const ManyConsumer({required this.initialData, required this.builder, this.filterObject, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dataProvider.streamMany<T>(initialData.runtimeType, filterObject: filterObject, init: false),
      initialData: ManyDataObject<T>(data: initialData),
      builder: (BuildContext context, AsyncSnapshot<ManyDataObject<T>> snap) {
        if (snap.hasError) {
          throw snap.error!;
        }
        return builder(context, snap.data!.data);
      },
    );
  }
}


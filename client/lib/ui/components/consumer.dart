import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class SingleConsumer<T extends DataObject, S extends T> extends StatelessWidget {
  final int id;
  final S? initialData;
  final Widget Function(BuildContext context, S data) builder;

  const SingleConsumer({required this.id, this.initialData, required this.builder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      stream: dataProvider.streamSingle<T, S>(id, init: initialData == null),
      initialData: initialData,
      builder: (BuildContext context, AsyncSnapshot<S> snap) {
        if (snap.hasError) {
          throw snap.error!;
        }
        return builder(context, snap.data!);
      },
    );
  }
}

class ManyConsumer<T extends DataObject, S extends T> extends StatelessWidget {
  final List<S>? initialData;
  final DataObject? filterObject;
  final Widget Function(BuildContext context, List<S> data) builder;

  const ManyConsumer({this.initialData, required this.builder, this.filterObject, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dataProvider.streamMany<T, S>(filterObject: filterObject, init: initialData == null),
      initialData: ManyDataObject<S>(data: initialData ?? []),
      builder: (BuildContext context, AsyncSnapshot<ManyDataObject<S>> snap) {
        if (snap.hasError) {
          throw snap.error!;
        }
        return builder(context, snap.data!.data);
      },
    );
  }
}

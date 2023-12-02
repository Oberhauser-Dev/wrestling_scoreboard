import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class AbstractOverview<T extends DataObject> {
  Widget buildOverview(
    BuildContext context, {
    required String classLocale,
    required Widget editPage,
    required VoidCallback onDelete,
    required List<Widget> tiles,
    required int dataId,
    T? initialData,
  });
}

class AppBarTitle extends StatelessWidget {
  final String label;
  final String details;

  const AppBarTitle({super.key, required this.label, required this.details});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        Text(
          '  $details',
          style: TextStyle(color: Theme.of(context).disabledColor),
        ),
      ],
    );
  }
}

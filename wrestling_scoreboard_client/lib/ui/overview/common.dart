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

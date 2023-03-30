import 'package:flutter/material.dart';

abstract class AbstractOverview {
  Widget buildOverview(
    BuildContext context, {
    required String classLocale,
    required Widget editPage,
    required VoidCallback onDelete,
    required List<Widget> tiles,
  });
}

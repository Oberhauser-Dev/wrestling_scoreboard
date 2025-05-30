import 'package:flutter/material.dart';

abstract class AbstractEditState<T> {
  Widget buildEdit(BuildContext context, {required String classLocale, required int? id, required List<Widget> fields});

  Future<void> handleNested(T dataObject);
}

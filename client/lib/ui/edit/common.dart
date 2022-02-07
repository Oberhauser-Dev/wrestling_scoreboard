import 'package:flutter/material.dart';

abstract class AbstractEditState<T> {
  List<Widget> buildFields(BuildContext context);

  Future<void> handleNested(T dataObject);
}

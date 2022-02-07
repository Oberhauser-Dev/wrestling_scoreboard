import 'package:flutter/material.dart';

abstract class AbstractOverview {
  Widget buildOverview(BuildContext context, {required Widget editPage, required List<Widget> tiles});
}

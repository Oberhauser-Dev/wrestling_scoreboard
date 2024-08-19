import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';

class TabGroup extends StatelessWidget {
  final Widget? top;
  final List<Widget> items;

  const TabGroup({required this.items, super.key, this.top});

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
        child: Expanded(
            child: TabBarView(
      children: items,
    )));
  }
}

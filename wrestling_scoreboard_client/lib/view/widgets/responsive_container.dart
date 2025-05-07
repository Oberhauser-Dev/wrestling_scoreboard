import 'package:flutter/cupertino.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;

  const ResponsiveContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(width: _calculateContainerSize(screenSize), child: child),
    );
  }

  double _calculateContainerSize(Size screenSize) {
    return screenSize.width < 768 ? screenSize.width : 768;
  }
}

class ResponsiveScrollView extends StatelessWidget {
  final Widget child;

  const ResponsiveScrollView({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(child: SingleChildScrollView(child: child));
  }
}

class ResponsiveColumn extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveColumn({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(child: SingleChildScrollView(child: Column(children: children)));
  }
}

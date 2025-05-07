import 'package:flutter/material.dart';

class ThemedContainer extends StatelessWidget {
  final Color? color;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget child;

  const ThemedContainer({required this.child, this.height, this.color, this.padding, this.margin, super.key});

  @override
  Widget build(BuildContext context) {
    final textColor =
        ThemeData.estimateBrightnessForColor(color ?? Theme.of(context).colorScheme.surface) == Brightness.light
            ? Colors.black
            : Colors.white;
    return Container(
      color: color,
      padding: padding,
      margin: margin,
      height: height,
      child: DefaultTextStyle.merge(style: TextStyle(color: textColor), child: child),
    );
  }
}

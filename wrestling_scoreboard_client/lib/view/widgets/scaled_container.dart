import 'package:flutter/cupertino.dart';

class ScaledContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final Color? color;

  const ScaledContainer({this.child, this.width, this.height, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: width == null ? null : (width! * MediaQuery.of(context).size.width),
      height: height == null ? null : (height! * MediaQuery.of(context).size.height),
      child: child,
    );
  }
}

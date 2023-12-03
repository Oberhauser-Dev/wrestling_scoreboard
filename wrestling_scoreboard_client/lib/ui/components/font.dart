import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  final String heading;

  const HeadingText(this.heading, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 10, top: 20),
        child: Text(
          heading.toUpperCase(),
          style: Theme.of(context).textTheme.bodySmall,
        ));
  }
}

class AutoTextScaler extends TextScaler {
  @override
  final double textScaleFactor;
  final double minFontSize;
  final double maxFontSize;

  const AutoTextScaler({this.textScaleFactor = 1, this.minFontSize = 0, this.maxFontSize = double.infinity});

  @override
  double scale(double fontSize) {
    fontSize = fontSize * textScaleFactor;
    return clampDouble(fontSize, minFontSize, maxFontSize);
  }
}

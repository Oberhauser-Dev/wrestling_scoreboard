import 'package:flutter/cupertino.dart';

class FittedText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  FittedText(this.text, {this.style});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Text(this.text, textScaleFactor: 100, style: this.style),
    );
  }
}

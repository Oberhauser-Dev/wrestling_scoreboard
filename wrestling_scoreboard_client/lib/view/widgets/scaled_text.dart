import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';

class ScaledText extends StatelessWidget {
  final String data;
  final double fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final Paint? foreground;
  final Color? color;
  final double? minFontSize;
  final double? scale;
  final bool? softWrap;
  final TextDecoration? decoration;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const ScaledText(
    this.data, {
    this.fontSize = 14,
    this.fontWeight,
    this.fontStyle,
    this.foreground,
    this.minFontSize,
    this.color,
    this.scale,
    this.softWrap,
    this.decoration,
    this.textAlign,
    this.overflow,
    super.key,
  });

  static Paint outlinePaint(BuildContext context) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..color = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;

  @override
  Widget build(BuildContext context) {
    final curScale = scale ?? (MediaQuery.of(context).size.width / 1000);
    return Text(
      data,
      style: TextStyle(
        fontSize: curScale * fontSize,
        color: color,
        decoration: decoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        foreground: foreground,
      ),
      textScaler: AutoTextScaler(minFontSize: minFontSize ?? fontSize),
      softWrap: softWrap,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}

class FittedText extends Text {
  const FittedText(
    super.data, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaler,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(fit: BoxFit.contain, child: super.build(context));
  }
}

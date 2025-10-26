import 'package:flutter/cupertino.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';

class ScaledText extends StatelessWidget {
  final String data;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final double? minFontSize;
  final double? scale;
  final bool? softWrap;
  final TextDecoration? decoration;
  final TextAlign? textAlign;

  const ScaledText(
    this.data, {
    this.fontSize = 14,
    this.fontWeight,
    this.minFontSize,
    this.color,
    this.scale,
    this.softWrap,
    this.decoration,
    this.textAlign,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final curScale = scale ?? (MediaQuery.of(context).size.width / 1000);
    return Text(
      data,
      style: TextStyle(fontSize: curScale * fontSize, color: color, decoration: decoration, fontWeight: fontWeight),
      textScaler: AutoTextScaler(minFontSize: minFontSize ?? fontSize),
      softWrap: softWrap,
      textAlign: textAlign,
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

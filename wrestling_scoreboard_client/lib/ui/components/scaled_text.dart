import 'package:flutter/cupertino.dart';
import 'package:wrestling_scoreboard_client/ui/components/font.dart';

class ScaledText extends StatelessWidget {
  final String data;
  final double fontSize;
  final Color? color;
  final double? minFontSize;
  final double? scale;
  final bool? softWrap;

  const ScaledText(
    this.data, {
    this.fontSize = 14,
    this.minFontSize,
    this.color,
    this.scale,
    this.softWrap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final curScale = scale ?? (MediaQuery.of(context).size.width / 1000);
    return Text(
      data,
      style: TextStyle(fontSize: curScale * fontSize, color: color),
      textScaler: AutoTextScaler(minFontSize: minFontSize ?? fontSize),
      softWrap: softWrap,
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
    TextScaler super.textScaler = const TextScaler.linear(100),
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: super.build(context),
    );
  }
}

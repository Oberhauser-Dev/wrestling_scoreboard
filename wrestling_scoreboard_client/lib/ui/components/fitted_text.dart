import 'package:flutter/cupertino.dart';
import 'package:wrestling_scoreboard_client/ui/components/font.dart';

class FittedText extends Text {
  const FittedText(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double textScaleFactor = 100,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) : super(data,
            key: key,
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaleFactor: textScaleFactor,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: super.build(context),
    );
  }
}

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
    Key? key,
  }) : super(key: key);

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

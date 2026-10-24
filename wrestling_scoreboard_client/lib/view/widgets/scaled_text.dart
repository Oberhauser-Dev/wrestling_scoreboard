import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';

class ScaledText extends StatelessWidget {
  final String data;
  final double fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;

  /// Draws only a single outline around the text in [color] and leaves the glyphs hollow.
  final bool outlined;
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
    this.outlined = false,
    this.minFontSize,
    this.color,
    this.scale,
    this.softWrap,
    this.decoration,
    this.textAlign,
    this.overflow,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final curScale = scale ?? (MediaQuery.of(context).size.width / 1000);
    final style = TextStyle(
      fontSize: curScale * fontSize,
      decoration: decoration,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );
    Text buildText(TextStyle style) => Text(
      data,
      style: style,
      textScaler: AutoTextScaler(minFontSize: minFontSize ?? fontSize),
      softWrap: softWrap,
      textAlign: textAlign,
      overflow: overflow,
    );
    if (!outlined) return buildText(style.copyWith(color: color));

    return _TextOutline(buildText: buildText, style: style, color: color ?? DefaultTextStyle.of(context).style.color!);
  }
}

/// Paints only the outer outline of the text.
/// A stroke alone also traces the inner and overlapping contours of the glyphs.
/// Therefore the filled glyphs erase the stroke afterwards, which only leaves its outer half.
class _TextOutline extends StatelessWidget {
  final Text Function(TextStyle style) buildText;
  final TextStyle style;
  final Color color;

  const _TextOutline({required this.buildText, required this.style, required this.color});

  @override
  Widget build(BuildContext context) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2, style.fontSize! * 0.06)
      ..strokeJoin = StrokeJoin.round
      ..color = color;
    final eraser = Paint()..blendMode = BlendMode.dstOut;
    return _IsolatedLayer(
      child: Stack(
        children: [
          buildText(style.copyWith(foreground: stroke)),
          buildText(style.copyWith(foreground: eraser)),
        ],
      ),
    );
  }
}

/// Paints its child in a separate layer, so blend modes like [BlendMode.dstOut] do not affect the content behind.
class _IsolatedLayer extends SingleChildRenderObjectWidget {
  const _IsolatedLayer({super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderIsolatedLayer();
}

class _RenderIsolatedLayer extends RenderProxyBox {
  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    context.canvas.saveLayer(offset & size, Paint());
    super.paint(context, offset);
    context.canvas.restore();
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

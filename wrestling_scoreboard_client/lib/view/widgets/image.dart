import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

ImageProvider getImageProviderFromString(String imageUri) {
  return imageUri.toLowerCase().endsWith('.svg') ? Svg(imageUri, source: SvgSource.network) : NetworkImage(imageUri);
}

class CircularImage extends StatelessWidget {
  final ImageProvider imageProvider;
  final double size;
  final double? borderWidth;
  final Color? borderColor;

  CircularImage({super.key, required String imageUri, this.size = 24, this.borderWidth, this.borderColor})
    : imageProvider = getImageProviderFromString(imageUri);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover, alignment: Alignment.topCenter),
        borderRadius: BorderRadius.all(Radius.circular(size / 2)),
        border: borderWidth == null ? null : Border.all(color: borderColor ?? Colors.white, width: borderWidth!),
      ),
    );
  }
}

class OverlappingCircularImage extends StatelessWidget {
  final List<String?> imageUris;
  final double size;
  final double? borderWidth;
  final Color? borderColor;

  const OverlappingCircularImage({
    super.key,
    required this.imageUris,
    this.size = 24,
    this.borderWidth,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          imageUris.nonNulls
              .map(
                (e) => Align(
                  widthFactor: 0.7,
                  child: CircularImage(size: size, imageUri: e, borderWidth: borderWidth, borderColor: borderColor),
                ),
              )
              .toList(),
    );
  }
}

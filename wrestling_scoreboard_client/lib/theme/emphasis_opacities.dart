import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// The opacities of content by its emphasis, which depend on the theme.
/// Material Design distinguishes the emphasis of text by the color roles [ColorScheme.onSurface] (high emphasis)
/// and [ColorScheme.onSurfaceVariant] (lower emphasis), which are named the same here:
/// https://m3.material.io/styles/color/roles
/// The theme does not define their opacities, so they are provided by this extension to derive the emphasis
/// of text colors on other backgrounds than the theme background.
class EmphasisOpacities extends ThemeExtension<EmphasisOpacities> {
  /// The opacities of the default theme.
  static const standard = EmphasisOpacities(onSurfaceAlpha: 0.87, onSurfaceVariantAlpha: 0.74, disabledAlpha: 0.38);

  /// The opacities of the high contrast theme.
  static const highContrast = EmphasisOpacities(onSurfaceAlpha: 1.0, onSurfaceVariantAlpha: 1.0, disabledAlpha: 0.6);

  /// The opacity of high emphasis (active) content, see [ColorScheme.onSurface].
  /// The default M3 colors correspond to 0.89 (light) and 0.88 (dark).
  final double onSurfaceAlpha;

  /// The opacity of medium emphasis (inactive) content, e.g. a vacant participant or a past match,
  /// see [ColorScheme.onSurfaceVariant].
  /// In contrast to disabled content it still carries information and keeps a contrast of at least 4.5 (WCAG AA)
  /// on the theme backgrounds, e.g. also on a projector.
  /// The default M3 colors correspond to 0.72 (light) and 0.76 (dark).
  final double onSurfaceVariantAlpha;

  /// The opacity of disabled content, e.g. a disabled control, which is not meant to be read:
  /// https://m3.material.io/foundations/interaction/states/applying-states#4aff9c51-d20f-4580-a510-862d2e25e931
  final double disabledAlpha;

  const EmphasisOpacities({
    required this.onSurfaceAlpha,
    required this.onSurfaceVariantAlpha,
    required this.disabledAlpha,
  });

  /// Get the high emphasis (active) variant of a text [color].
  /// Use [ColorScheme.onSurface] for text on the theme background, and this for text on other backgrounds.
  Color onSurface(Color color) => color.withValues(alpha: onSurfaceAlpha);

  /// Get the medium emphasis (inactive) variant of a text [color].
  /// Use [ColorScheme.onSurfaceVariant] for text on the theme background, and this for text on other backgrounds.
  Color onSurfaceVariant(Color color) => color.withValues(alpha: onSurfaceVariantAlpha);

  /// Get the disabled variant of a [color], e.g. of a disabled control.
  /// Use [ThemeData.disabledColor] for content on the theme background, and this for content on other backgrounds.
  Color disabled(Color color) => color.withValues(alpha: disabledAlpha);

  @override
  EmphasisOpacities copyWith({double? onSurfaceAlpha, double? onSurfaceVariantAlpha, double? disabledAlpha}) {
    return EmphasisOpacities(
      onSurfaceAlpha: onSurfaceAlpha ?? this.onSurfaceAlpha,
      onSurfaceVariantAlpha: onSurfaceVariantAlpha ?? this.onSurfaceVariantAlpha,
      disabledAlpha: disabledAlpha ?? this.disabledAlpha,
    );
  }

  @override
  EmphasisOpacities lerp(covariant EmphasisOpacities? other, double t) {
    if (other == null) return this;
    return EmphasisOpacities(
      onSurfaceAlpha: lerpDouble(onSurfaceAlpha, other.onSurfaceAlpha, t)!,
      onSurfaceVariantAlpha: lerpDouble(onSurfaceVariantAlpha, other.onSurfaceVariantAlpha, t)!,
      disabledAlpha: lerpDouble(disabledAlpha, other.disabledAlpha, t)!,
    );
  }
}

extension EmphasisOpacitiesContext on BuildContext {
  EmphasisOpacities get emphasis => Theme.of(this).extension<EmphasisOpacities>() ?? EmphasisOpacities.standard;
}

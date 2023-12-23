import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final isMobile =
    !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);
final isDesktop = !kIsWeb && !isMobile;

extension ColorExtension on Color {
  /// Get disabled state of a color.
  /// This adheres to the Material Design specifications:
  /// https://m3.material.io/foundations/interaction/states/applying-states#4aff9c51-d20f-4580-a510-862d2e25e931
  Color disabled() {
    return withOpacity(0.38);
  }
}

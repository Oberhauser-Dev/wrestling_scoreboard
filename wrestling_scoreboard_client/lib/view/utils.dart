import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final isOnMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
final isMobile = !kIsWeb && isOnMobile;
final isOnDesktop = !isOnMobile;
final isDesktop = !kIsWeb && isOnDesktop;

extension ColorExtension on Color {
  /// Get disabled state of a color.
  /// This adheres to the Material Design specifications:
  /// https://m3.material.io/foundations/interaction/states/applying-states#4aff9c51-d20f-4580-a510-862d2e25e931
  Color disabled() {
    return withValues(alpha: 0.38);
  }
}

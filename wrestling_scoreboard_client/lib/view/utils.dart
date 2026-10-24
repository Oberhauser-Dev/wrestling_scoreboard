import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/app.dart';
import 'package:wrestling_scoreboard_client/l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';

final isOnMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
final isMobile = !kIsWeb && isOnMobile;
final isOnDesktop = !isOnMobile;
final isDesktop = !kIsWeb && isOnDesktop;

// Material Design distinguishes the emphasis of text by its opacity on the background:
// https://m2.material.io/design/color/text-legibility.html#text-types
// Material 3 replaced these with the color roles [ColorScheme.onSurface] and [ColorScheme.onSurfaceVariant],
// which are named the same here. Disabled content (0.38), which is not meant to be read, is not covered here.

/// The opacity of high emphasis (active) content, see [ColorScheme.onSurface].
const double onSurfaceAlpha = 0.87;

/// The opacity of high emphasis content in high contrast mode, see [onSurfaceAlpha].
const double highContrastOnSurfaceAlpha = 1.0;

/// The opacity of medium emphasis (inactive) content, e.g. a vacant participant or a past match,
/// see [ColorScheme.onSurfaceVariant].
/// In contrast to disabled content it still carries information and keeps a contrast of at least 4.5 (WCAG AA)
/// on the theme backgrounds, e.g. also on a projector.
const double onSurfaceVariantAlpha = 0.6;

/// The opacity of medium emphasis content in high contrast mode, see [onSurfaceVariantAlpha].
const double highContrastOnSurfaceVariantAlpha = 0.9;

extension ColorExtension on Color {
  /// Get the high emphasis (active) variant of a text color, see [onSurfaceAlpha] and [highContrastOnSurfaceAlpha].
  /// Use [ColorScheme.onSurface] for text on the theme background, and this for text on other backgrounds.
  Color onSurface({bool highContrast = false}) {
    return withValues(alpha: highContrast ? highContrastOnSurfaceAlpha : onSurfaceAlpha);
  }

  /// Get the medium emphasis (inactive) variant of a text color,
  /// see [onSurfaceVariantAlpha] and [highContrastOnSurfaceVariantAlpha].
  /// Use [ColorScheme.onSurfaceVariant] for text on the theme background, and this for text on other backgrounds.
  Color onSurfaceVariant({bool highContrast = false}) {
    return withValues(alpha: highContrast ? highContrastOnSurfaceVariantAlpha : onSurfaceVariantAlpha);
  }
}

// Below 600: extraSmallScreen
const smallScreenMinWidth = 600.0;
const mediumScreenMinWidth = 768.0;
const largeScreenMinWidth = 992.0;
const extraLargeScreenMinWidth = 1200.0;

extension ResponsiveExtension on BuildContext {
  bool get isMediumScreenOrLarger => MediaQuery.of(this).size.width >= mediumScreenMinWidth;
}

/// Show a snackbar with a message depending on the current locale, e.g. from a service without a [BuildContext].
void showAppSnackBar(
  String Function(AppLocalizations l10n) messageBuilder, {
  bool clearSnackBars = false,
  SnackBarAction Function(AppLocalizations l10n)? actionBuilder,
}) {
  final context = scaffoldMessengerKey.currentContext;
  if (context == null) return;
  if (clearSnackBars) scaffoldMessengerKey.currentState?.clearSnackBars();
  final l10n = context.l10n;
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(content: Text(messageBuilder(l10n)), action: actionBuilder?.call(l10n), actionOverflowThreshold: 1),
  );
}

/// Up to 120 retries
const _connectionRetryCount = 120;

/// Starts with a delay of 500ms
const _connectionRetryInitialPeriodMs = 500;

/// Doubles the delay on each retry up to 1 minute
const _connectionRetryMaxPeriodMs = 60000;

/// Calculate duration until an action should be retried.
Duration? getRetryDuration(int retryCount) {
  if (retryCount >= _connectionRetryCount) return null;
  return Duration(
    milliseconds: math.min(
      _connectionRetryInitialPeriodMs * math.pow(2, retryCount).toInt(),
      _connectionRetryMaxPeriodMs,
    ),
  );
}

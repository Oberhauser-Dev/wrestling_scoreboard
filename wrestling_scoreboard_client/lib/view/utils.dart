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

// Material Design distinguishes the emphasis of text by the color roles [ColorScheme.onSurface] (high emphasis)
// and [ColorScheme.onSurfaceVariant] (lower emphasis), which are named the same here:
// https://m3.material.io/styles/color/roles

/// The opacity of high emphasis (active) content, see [ColorScheme.onSurface].
/// The default M3 colors correspond to 0.89 (light) and 0.88 (dark).
const double _onSurfaceAlpha = 0.87;

/// The opacity of high emphasis content in high contrast mode.
const double _highContrastOnSurfaceAlpha = 1.0;

/// The opacity of medium emphasis (inactive) content, e.g. a vacant participant or a past match,
/// see [ColorScheme.onSurfaceVariant].
/// In contrast to disabled content it still carries information and keeps a contrast of at least 4.5 (WCAG AA)
/// on the theme backgrounds, e.g. also on a projector.
/// The default M3 colors correspond to 0.72 (light) and 0.76 (dark).
const double _onSurfaceVariantAlpha = 0.74;

/// The opacity of medium emphasis content in high contrast mode.
const double _highContrastOnSurfaceVariantAlpha = 0.9;

/// The opacity of disabled content, e.g. a disabled control, which is not meant to be read.
const double _disabledAlpha = 0.38;

/// The opacity of disabled content in high contrast mode.
const double _highContrastDisabledAlpha = 0.6;

extension ColorExtension on Color {
  /// Get the high emphasis (active) variant of a text color.
  /// Use [ColorScheme.onSurface] for text on the theme background, and this for text on other backgrounds.
  Color onSurface({bool highContrast = false}) {
    return withValues(alpha: highContrast ? _highContrastOnSurfaceAlpha : _onSurfaceAlpha);
  }

  /// Get the medium emphasis (inactive) variant of a text color.
  /// Use [ColorScheme.onSurfaceVariant] for text on the theme background, and this for text on other backgrounds.
  Color onSurfaceVariant({bool highContrast = false}) {
    return withValues(alpha: highContrast ? _highContrastOnSurfaceVariantAlpha : _onSurfaceVariantAlpha);
  }

  /// Get the disabled variant of a color, e.g. of a disabled control.
  /// Disabled content is not meant to be read and has a fixed opacity:
  /// https://m3.material.io/foundations/interaction/states/applying-states#4aff9c51-d20f-4580-a510-862d2e25e931
  Color disabled({bool highContrast = false}) {
    return withValues(alpha: highContrast ? _highContrastDisabledAlpha : _disabledAlpha);
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

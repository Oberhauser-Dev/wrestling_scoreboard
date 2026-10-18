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

/// The opacity of disabled content, e.g. a vacant participant or a past match.
/// Material Design uses 0.38 for disabled controls, which are not meant to be read:
/// https://m3.material.io/foundations/interaction/states/applying-states#4aff9c51-d20f-4580-a510-862d2e25e931
/// As disabled content still carries information here, a higher opacity is used, which keeps a contrast
/// of at least 4.5 (WCAG AA) on the theme backgrounds, e.g. also on a projector.
const double disabledAlpha = 0.65;

extension ColorExtension on Color {
  /// Get disabled state of a color, see [disabledAlpha].
  Color disabled() {
    return withValues(alpha: disabledAlpha);
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

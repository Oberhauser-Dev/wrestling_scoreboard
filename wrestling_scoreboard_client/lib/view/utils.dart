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

extension ColorExtension on Color {
  /// Get disabled state of a color.
  /// This adheres to the Material Design specifications:
  /// https://m3.material.io/foundations/interaction/states/applying-states#4aff9c51-d20f-4580-a510-862d2e25e931
  Color disabled() {
    return withValues(alpha: 0.38);
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

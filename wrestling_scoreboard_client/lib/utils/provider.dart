import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

extension WidgetRefExtension on WidgetRef {
  // FIXME: .read not always returns the correct value for Future streams.
  // So use watch to await the result.
  // See: https://github.com/rrousselGit/riverpod/issues/3889
  T readAsync<T>(ProviderListenable<T> provider) => watch(provider);
}

/// See: https://riverpod.dev/docs/essentials/auto_dispose#example-keeping-state-alive-for-a-specific-amount-of-time
extension CacheForExtension on Ref {
  /// Keeps the provider alive for [duration].
  // TODO: may dynamically read cache duration from settings.
  void cache([Duration duration = const Duration(minutes: 5)]) {
    // Immediately prevent the state from getting destroyed.
    final link = keepAlive();
    // After duration has elapsed, we re-enable automatic disposal.
    final timer = Timer(duration, link.close);

    // Optional: when the provider is recomputed (such as with ref.watch),
    // we cancel the pending timer.
    onDispose(timer.cancel);
  }
}

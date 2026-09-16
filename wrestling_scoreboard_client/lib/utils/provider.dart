import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

// ignore: implementation_imports, depend_on_referenced_packages, invalid_use_of_internal_member
import 'package:riverpod/src/internals.dart' show $RefArg;

extension WidgetRefExtension on WidgetRef {
  // FIXME: .read not always returns the correct value for Future streams.
  // So use listenManual to await the result.
  // See: https://github.com/rrousselGit/riverpod/issues/3889
  Future<T> readAsync<T>(ProviderListenable<Future<T>> provider) async {
    final sub = listenManual(provider, (previous, next) {});
    final value = await sub.read();
    sub.close();
    return value;
  }
}

/// See: https://riverpod.dev/docs/concepts2/auto_dispose#fine-tuned-disposal-with-refkeepalive
extension CacheForExtension on Ref {
  /// Keeps the provider alive and active (not paused) for [duration].
  ///
  /// A plain [keepAlive] only prevents disposal. Without an active listener,
  /// the provider is paused and does not process any events (e.g. stream updates).
  /// So additionally listen to the provider itself from the container,
  /// which is never paused, as it is not bound to any widget.
  // TODO: may dynamically read cache duration from settings.
  void cache([Duration duration = const Duration(minutes: 5)]) {
    // Immediately prevent the state from getting destroyed.
    final link = keepAlive();

    // FIXME: provide a way to update providers without need to explicitly listen to them.
    // Defer, as a provider must not be listened to while it is being built.
    ProviderSubscription<Object?>? sub;
    scheduleMicrotask(() {
      if (!mounted) return;
      sub = container.listen($element.origin, (previous, next) {});
    });

    // After duration has elapsed, we re-enable automatic disposal and pausing.
    final timer = Timer(duration, () {
      sub?.close();
      link.close();
    });

    // Optional: when the provider is recomputed (such as with ref.watch),
    // we cancel the pending timer.
    onDispose(() {
      timer.cancel();
      sub?.close();
    });
  }
}

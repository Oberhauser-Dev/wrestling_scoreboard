import 'package:flutter_riverpod/flutter_riverpod.dart';

extension WidgetRefExtension on WidgetRef {
  // FIXME: .read not always returns the correct value for Future streams.
  // So use watch to await the result.
  // See: https://github.com/rrousselGit/riverpod/issues/3889
  T readAsync<T>(ProviderListenable<T> provider) => watch(provider);
}

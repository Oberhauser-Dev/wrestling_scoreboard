import 'dart:io';

/// The directory all relative resources (`.env`, `public`, `database`, `pubspec.yaml`) are resolved against.
///
/// - Compiled executable (`<bundle>/bin/wrestling-scoreboard-server`): the bundle root, i.e. the parent of `bin`.
/// - Running via the Dart VM (`dart run`, `dart test`, `flutter test`): the current working directory.
final String baseDir = _resolveBaseDir();

String _resolveBaseDir() {
  final executable = File(Platform.resolvedExecutable);
  // Only treat this as our compiled bundle when the executable's name matches what
  // build-server.yml produces. Dev runtimes (`dart`, `dart.exe`, `flutter`, or `flutter test`'s
  // `flutter_tester`) are named differently, so they fall back to the current working directory.
  final exeName = executable.uri.pathSegments.last.toLowerCase();
  if (!exeName.contains('server')) {
    return Directory.current.path;
  }
  return executable.parent.parent.path;
}

/// Resolves [relativePath] against [baseDir].
String resolvePath(String relativePath) {
  final normalized = relativePath.replaceFirst(RegExp(r'^\./'), '');
  return '$baseDir${Platform.pathSeparator}$normalized';
}

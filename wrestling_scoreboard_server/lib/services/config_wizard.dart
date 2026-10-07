import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dotenv/dotenv.dart' show DotEnv;
import 'package:wrestling_scoreboard_server/services/base_dir.dart';
import 'package:wrestling_scoreboard_server/services/environment.dart';

/// Thrown, if stdin ends before all questions of the [runConfigWizard] were answered.
class ConfigInputEndedException implements Exception {
  @override
  String toString() => 'Input ended before all questions were answered.';
}

/// Asks for the necessary configuration in the terminal and saves it to the [configFilePath].
///
/// The values of the existing config files are suggested as defaults, other entries of the file are kept.
/// Must not access [env], as it is loaded only once and should contain the saved values.
///
/// Returns `false`, if the configuration could not be saved.
bool runConfigWizard() {
  try {
    _runConfigWizard();
    return true;
  } on ConfigInputEndedException catch (e) {
    stderr.writeln('\n$e');
  } on FileSystemException catch (e) {
    stderr.writeln(
      '\nCould not save the configuration to "$configFilePath": ${e.osError?.message ?? e.message}\n'
      'Run as administrator or choose another file via `--config-file`.',
    );
  }
  return false;
}

void _runConfigWizard() {
  final current = DotEnv(quiet: true)..load(existingConfigFiles);
  String? currentValue(String key) => current.isDefined(key) ? current[key] : null;

  stdout.writeln('Configure the Wrestling Scoreboard Server, press Enter to keep the value in brackets.\n');
  final values = <String, String>{
    'HOST': _ask(
      'Address to listen on (0.0.0.0 to allow access from other devices)',
      defaultValue: currentValue('HOST') ?? '127.0.0.1',
    ),
    'PORT': _ask('Port', defaultValue: currentValue('PORT') ?? '8080', validate: _validatePort),
    'DATABASE_HOST': _ask('PostgreSQL host', defaultValue: currentValue('DATABASE_HOST') ?? '127.0.0.1'),
    'DATABASE_PORT': _ask(
      'PostgreSQL port',
      defaultValue: currentValue('DATABASE_PORT') ?? '5432',
      validate: _validatePort,
    ),
    'DATABASE_NAME': _ask('Database name', defaultValue: currentValue('DATABASE_NAME') ?? 'wrestling_scoreboard'),
    'DATABASE_USER': _ask('Database user', defaultValue: currentValue('DATABASE_USER') ?? 'wrestling'),
    'DATABASE_PASSWORD': _ask(
      'Database password',
      defaultValue: currentValue('DATABASE_PASSWORD'),
      isSecret: true,
      validate: (value) => value.isEmpty ? 'The password must not be empty.' : null,
    ),
    'DATABASE_SSL_MODE': _ask(
      'Database SSL mode (${_sslModes.join(', ')})',
      defaultValue: currentValue('DATABASE_SSL_MODE') ?? 'DISABLE',
      validate: (value) => _sslModes.contains(value.toUpperCase()) ? null : 'Must be one of ${_sslModes.join(', ')}.',
    ).toUpperCase(),
    'POSTGRES_BIN_DIR': _ask(
      'Directory of the PostgreSQL client tools psql and pg_dump (- to use the PATH)',
      defaultValue: currentValue('POSTGRES_BIN_DIR') ?? _detectPostgresBinDir(),
      isClearable: true,
    ),
  };

  final jwtSecret = currentValue('JWT_SECRET');
  if (jwtSecret == null || jwtSecret == exampleJwtSecret) {
    values['JWT_SECRET'] = _generateSecret();
  }

  writeConfigFile(configFilePath, values);
  stdout.writeln('\nSaved the configuration to "$configFilePath".');
}

const _sslModes = ['DISABLE', 'REQUIRE', 'VERIFY_FULL'];

String? _validatePort(String value) {
  final port = int.tryParse(value);
  return port != null && port > 0 && port <= 65535 ? null : 'Must be a number between 1 and 65535.';
}

/// Asks the [question] until the answer is valid, an empty answer keeps the [defaultValue].
///
/// If [isClearable], the answer `-` sets an empty value.
String _ask(
  String question, {
  String? defaultValue,
  bool isSecret = false,
  bool isClearable = false,
  String? Function(String value)? validate,
}) {
  final hint = defaultValue == null || defaultValue.isEmpty ? '' : ' [${isSecret ? '***' : defaultValue}]';
  while (true) {
    stdout.write('$question$hint: ');
    final input = (isSecret ? _readSecretLine() : _readLine())?.trim();
    if (input == null) throw ConfigInputEndedException();
    final value = switch (input) {
      '' => defaultValue ?? '',
      '-' when isClearable => '',
      _ => input,
    };
    final error = validate?.call(value);
    if (error == null) return value;
    stdout.writeln(error);
  }
}

/// Whether stdin is an interactive terminal.
///
/// [Stdin.hasTerminal] alone is not sufficient, as it is also `true` for the `NUL` device on Windows,
/// which has no console mode.
bool get isInteractiveTerminal {
  if (!stdin.hasTerminal) return false;
  try {
    stdin.lineMode;
    return true;
  } on StdinException {
    return false;
  }
}

/// Reads a line, or returns `null` if the input ended or cannot be read (e.g. from the `NUL` device on Windows).
String? _readLine() {
  try {
    return stdin.readLineSync();
  } on StdinException {
    return null;
  }
}

/// Reads a line without echoing it, if stdin is a terminal.
String? _readSecretLine() {
  if (!isInteractiveTerminal) return _readLine();
  stdin.echoMode = false;
  try {
    return _readLine();
  } finally {
    stdin.echoMode = true;
    stdout.writeln();
  }
}

/// Finds the `bin` directory of the newest PostgreSQL installation in the default location on Windows.
String? _detectPostgresBinDir() {
  if (!Platform.isWindows) return null;
  final root = Directory('${Platform.environment['ProgramFiles'] ?? r'C:\Program Files'}\\PostgreSQL');
  if (!root.existsSync()) return null;
  final installations = root.listSync().whereType<Directory>().where(
    (dir) => File('${dir.path}\\bin\\psql.exe').existsSync(),
  );
  final newest = installations.fold<Directory?>(null, (newest, dir) {
    int version(Directory dir) => int.tryParse(dir.uri.pathSegments.lastWhere((s) => s.isNotEmpty)) ?? 0;
    return newest == null || version(dir) > version(newest) ? dir : newest;
  });
  return newest == null ? null : '${newest.path}\\bin';
}

String _generateSecret() {
  final random = Random.secure();
  return base64Url.encode(List.generate(48, (_) => random.nextInt(256)));
}

/// Sets the [values] in the config file at [path], keeping all other lines.
///
/// A new file is based on `.env.example`, so all options stay documented.
/// Commented out entries (e.g. `#KEY=...`) are replaced by non-empty values, empty values stay commented out.
void writeConfigFile(String path, Map<String, String> values) {
  final file = File(path);
  final template = File(resolvePath('.env.example'));
  final lines = [
    if (file.existsSync()) ...file.readAsLinesSync() else if (template.existsSync()) ...template.readAsLinesSync(),
  ];
  final keyPattern = RegExp(r'^\s*(?:export\s+)?([A-Za-z_]\w*)\s*=');
  final commentedKeyPattern = RegExp(r'^\s*#\s*([A-Za-z_]\w*)\s*=');
  final remaining = Map.of(values);
  // Single quoted values are read literally, see the dotenv parser.
  String entry(String key) => "$key='${remaining.remove(key)}'";

  // Replace active entries first, so a commented out example is only used if there is no active entry.
  for (var i = 0; i < lines.length; i++) {
    final key = keyPattern.firstMatch(lines[i])?.group(1);
    if (key != null && remaining.containsKey(key)) lines[i] = entry(key);
  }
  remaining.removeWhere((key, value) => value.isEmpty);
  for (var i = 0; i < lines.length; i++) {
    final key = commentedKeyPattern.firstMatch(lines[i])?.group(1);
    if (key != null && remaining.containsKey(key)) lines[i] = entry(key);
  }
  lines.addAll(remaining.keys.toList().map(entry));

  file.parent.createSync(recursive: true);
  file.writeAsStringSync('${lines.join('\n')}\n');
}

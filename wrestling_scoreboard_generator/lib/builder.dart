import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:graphs/graphs.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

// TODO: remove when https://github.com/dart-lang/source_gen/issues/743 is resolved.
// ignore_for_file: deprecated_member_use

Builder genericDataObjectBuilder(BuilderOptions options) =>
    GenericDataObjectBuilder();

extension on ClassElement {
  bool get isDataObject {
    return !name.startsWith('_') &&
        mixins.isNotEmpty &&
        allSupertypes
            .map((i) => i.element3.name3)
            .any((name) => name == 'DataObject');
  }

  bool hasGettersOfClass(ClassElement cElement) {
    if (mixins.isEmpty) {
      return false;
    }
    // Avoid cyclic dependencies for its own class:
    if (thisType == cElement.thisType) return false;
    return mixins.first.getters.any((getter) {
      return getter.returnType.element3?.name3 == cElement.name;
    });
  }
}

class GenericDataObjectBuilder implements Builder {
  static AssetId _allFileOutput(BuildStep buildStep) {
    return AssetId(
      buildStep.inputId.package,
      p.join('lib', 'src', 'generic_data_objects.dart'),
    );
  }

  @override
  Future build(BuildStep buildStep) async {
    final classes = <ClassElement>[];

    final assetsStream = buildStep.findAssets(Glob(r'**.dart'));
    await for (final input in assetsStream) {
      if (input.path.endsWith('.freezed.dart') ||
          input.path.endsWith('.g.dart')) {
        continue;
      }
      final library = await buildStep.resolver.libraryFor(input);
      final classesInLibrary = LibraryReader(library).classes;
      classes.addAll(classesInLibrary.where((c) => c.isDataObject));
    }
    final sorted = topologicalSort<ClassElement>(
      classes,
      // for each “dependency” node, list all the nodes that depend on it:
      (node) {
        final cl = classes.where((c) => c.hasGettersOfClass(node));
        // print('${node.name}: ${cl.map((c) => c.name).join(', ')}');
        return cl;
      },
      equals: (p0, p1) => p0.name == p1.name,
      secondarySort: (a, b) => a.name.compareTo(b.name),
    );

    final output = '''
// ignore: prefer_relative_imports
import 'package:wrestling_scoreboard_common/common.dart';
/// This file is generated, DO NOT CHANGE BY HAND.

/// Topo-Hierarchically ordered data types (most to least dependent on others).
final dataTypes = [
  ${sorted.reversed.map((c) => c.name).join(',\n  ')}
];

String getTableNameFromType(Type t) {
  return switch (t) {
    ${sorted.map((c) => 'const (${c.name}) => ${c.name}.cTableName,').join('\n    ')}
    const (BasicAuthService) => BasicAuthService.cTableName, // Only used for type encoding
    _ => throw UnimplementedError('ClassName for "\${t.toString()}" not found.'),
  };
}

Type getTypeFromTableName(String tableName) {
  return switch (tableName) {
    ${sorted.map((c) => '${c.name}.cTableName => ${c.name},').join('\n    ')}
    BasicAuthService.cTableName => BasicAuthService, // Only used for type decoding
    _ => throw UnimplementedError('Type for "\${tableName.toString()}" not found.'),
  };
}

Future<int?> handleGenericJson(
  Map<String, dynamic> json, {
  required HandleSingleCallback handleSingle,
  required HandleManyCallback handleMany,
  required HandleSingleRawCallback handleSingleRaw,
  required HandleManyRawCallback handleManyRaw,
}) {
  final type = getTypeFromTableName(json['tableName'] as String);
  return switch (type) {
    ${sorted.map((c) => 'const (${c.name}) => handleJson<${c.name}>(json, handleSingle: handleSingle, handleMany: handleMany, handleSingleRaw: handleSingleRaw, handleManyRaw: handleManyRaw),').join('\n    ')}
    _ => throw UnimplementedError('Cannot handle Json for type "\${type.toString()}".'),
  };
}

extension DataObjectParser on DataObject {
  static T fromJson<T extends DataObject>(Map<String, dynamic> json) {
    return switch (T) {
      ${sorted.map((c) => 'const (${c.name}) => ${c.name}.fromJson(json) as T,').join('\n      ')}
      _ => throw UnimplementedError('Json conversation for "\$T" not found.'),
    };
  }

  static Future<T> fromRaw<T extends DataObject>(Map<String, dynamic> raw, GetSingleOfTypeCallback getSingle) async {
    return switch (T) {
      ${sorted.map((c) => 'const (${c.name}) => (await ${c.name}.fromRaw(raw, getSingle)) as T,').join('\n      ')}
      _ => throw UnimplementedError('Raw conversation for "\$T" not found.'),
    };
  }
}
''';
    await buildStep.writeAsString(_allFileOutput(buildStep), output);
  }

  @override
  final buildExtensions = const {
    r'$lib$': ['src/generic_data_objects.dart'],
  };
}

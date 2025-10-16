import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:graphs/graphs.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

Builder genericDataObjectBuilder(BuilderOptions options) => GenericDataObjectBuilder();

extension on ClassElement2 {
  bool get isDataObject {
    return !(name3?.startsWith('_') ?? false) &&
        mixins.isNotEmpty &&
        allSupertypes.map((i) => i.element3.name3).any((name) => name == 'DataObject');
  }

  bool hasGettersOfClass(ClassElement2 cElement) {
    if (mixins.isEmpty) {
      return false;
    }
    // Avoid cyclic dependencies for its own class:
    if (thisType == cElement.thisType) return false;
    return mixins.first.getters.any((getter) {
      return getter.returnType.element3?.name3 == cElement.name3;
    });
  }
}

class GenericDataObjectBuilder implements Builder {
  static AssetId _allFileOutput(BuildStep buildStep) {
    return AssetId(buildStep.inputId.package, p.join('lib', 'src', 'generic_data_objects.dart'));
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final classes = <ClassElement2>[];

    final assetsStream = buildStep.findAssets(Glob(r'**.dart'));
    await for (final input in assetsStream) {
      if (input.path.endsWith('.freezed.dart') || input.path.endsWith('.g.dart')) {
        continue;
      }
      final library = await buildStep.resolver.libraryFor(input);
      final classesInLibrary = LibraryReader(library).classes;
      classes.addAll(classesInLibrary.where((c) => c.isDataObject));
    }
    final sorted = topologicalSort<ClassElement2>(
      classes,
      // for each “dependency” node, list all the nodes that depend on it:
      (node) {
        final cl = classes.where((c) => c.hasGettersOfClass(node));
        // print('${node.name}: ${cl.map((c) => c.name).join(', ')}');
        return cl;
      },
      equals: (p0, p1) => p0.name3 == p1.name3,
      secondarySort: (a, b) {
        if (a.name3 == null) return -1;
        if (b.name3 == null) return 1;
        return a.name3!.compareTo(b.name3!);
      },
    );

    final output = '''
// ignore: prefer_relative_imports
import 'package:wrestling_scoreboard_common/common.dart';
/// This file is generated, DO NOT CHANGE BY HAND.

/// Topo-Hierarchically ordered data types (most to least dependent on others).
final dataTypes = [
  ${sorted.reversed.map((c) => c.name3).join(',\n  ')}
];

String getTableNameFromType(Type t) {
  return switch (t) {
    ${sorted.map((c) => 'const (${c.name3}) => ${c.name3}.cTableName,').join('\n    ')}
    const (BasicAuthService) => BasicAuthService.cTableName, // Only used for type encoding
    _ => throw UnimplementedError('ClassName for "\${t.toString()}" not found.'),
  };
}

Type getTypeFromTableName(String tableName) {
  return switch (tableName) {
    ${sorted.map((c) => '${c.name3}.cTableName => ${c.name3},').join('\n    ')}
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
    ${sorted.map((c) => 'const (${c.name3}) => handleJson<${c.name3}>(json, handleSingle: handleSingle, handleMany: handleMany, handleSingleRaw: handleSingleRaw, handleManyRaw: handleManyRaw),').join('\n    ')}
    _ => throw UnimplementedError('Cannot handle Json for type "\${type.toString()}".'),
  };
}

extension DataObjectParser on DataObject {
  static T fromJson<T extends DataObject>(Map<String, dynamic> json) {
    return switch (T) {
      ${sorted.map((c) => 'const (${c.name3}) => ${c.name3}.fromJson(json) as T,').join('\n      ')}
      _ => throw UnimplementedError('Json conversation for "\$T" not found.'),
    };
  }

  static Future<T> fromRaw<T extends DataObject>(Map<String, dynamic> raw, GetSingleOfTypeCallback getSingle) async {
    return switch (T) {
      ${sorted.map((c) => 'const (${c.name3}) => (await ${c.name3}.fromRaw(raw, getSingle)) as T,').join('\n      ')}
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

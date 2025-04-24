import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:graphs/graphs.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

Builder genericDataObjectBuilder(BuilderOptions options) =>
    GenericDataObjectBuilder();

extension on InterfaceType {
  bool get isDataObject {
    return !getDisplayString(withNullability: false).startsWith('_') &&
        allSupertypes
            .map((i) => i.getDisplayString(withNullability: false))
            .any((name) => name == 'DataObject');
  }
}

extension on ClassElement {
  bool hasGettersOfClass(ClassElement cElement) {
    if (mixins.isEmpty) {
      return false;
    }
    // Avoid cyclic dependencies for its own class:
    if (thisType == cElement.thisType) return false;
    return mixins.first.getters.any((getter) {
      return getter.returnType.getDisplayString(withNullability: false) ==
          cElement.thisType.getDisplayString(withNullability: false);
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
      classes.addAll(classesInLibrary.where((c) => c.thisType.isDataObject));
    }
    final sorted = topologicalSort<ClassElement>(
      classes,
      // for each “dependency” node, list all the nodes that depend on it:
      (node) => classes.where((c) => c.hasGettersOfClass(node)),
      secondarySort: (a, b) => a.name.compareTo(b.name),
    );

    final output = '''
/// This file is generated, please do not change.

import 'package:wrestling_scoreboard_common/common.dart';

final dataTypes = [
  ${sorted.map((c) => c.name).join(',\n  ')}
];
''';
    await buildStep.writeAsString(_allFileOutput(buildStep), output);
  }

  @override
  final buildExtensions = const {
    r'$lib$': ['src/generic_data_objects.dart'],
  };
}

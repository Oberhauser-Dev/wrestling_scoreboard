import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:graphs/graphs.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

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

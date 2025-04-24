import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

Builder genericDataObjectBuilder(BuilderOptions options) =>
    GenericDataObjectBuilder();

extension on InterfaceType {
  bool get isDataObject {
    return interfaces
            .map((i) => i.getDisplayString(withNullability: false))
            .any((name) => name == 'DataObject') ||
        interfaces.any((i) => i.isDataObject);
  }
}

extension on ClassElement {
  bool hasGettersOfClass(ClassElement cElement) {
    if (mixins.isEmpty) {
      return false;
    }
    print(
      '${thisType.getDisplayString(withNullability: false)}: compare to: ${cElement.thisType.getDisplayString(withNullability: false)}',
    );
    return mixins.first.getters.any((getter) {
      print(
        'Return Type: ${getter.returnType.getDisplayString(withNullability: false)}',
      );
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
    classes.sort((a, b) {
      final comp =
          a.hasGettersOfClass(b) ? 1 : (b.hasGettersOfClass(a) ? -1 : 0);
      print(
        '########## ${a.displayName} ${comp > 0 ? '>' : (comp < 0 ? '<' : '==')} ${b.displayName}',
      );
      return comp;
    });

    final output = '''
/// This file is generated, please do not change.

import 'package:wrestling_scoreboard_common/common.dart';

final dataTypes = [
  ${classes.map((c) => c.name).join(',\n  ')}
];
''';
    await buildStep.writeAsString(_allFileOutput(buildStep), output);
  }

  @override
  final buildExtensions = const {
    r'$lib$': ['src/generic_data_objects.dart'],
  };
}

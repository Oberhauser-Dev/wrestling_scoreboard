import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

Builder genericDataObjectBuilder(BuilderOptions options) => GenericDataObjectBuilder();

extension on InterfaceType {
  bool get isDataObject {
    return interfaces.map((i) => i.getDisplayString()).any((name) => name == 'DataObject') ||
        interfaces.any((i) => i.isDataObject);
  }
}

extension on ClassElement {
  bool hasGettersOfClass(ClassElement cElement) {
    print('## classeelement: ${thisType.toString()}');
    print(thisType.mixins);
    if (thisType.mixins.isEmpty) {
      print('## has no mixins: ${thisType.toString()}');
      return false;
    }
    return thisType.mixins.first.getters.any((getter) {
      // print(getter.returnType.toString() + ' vs ' + cElement.thisType.toString());
      return getter.returnType == cElement.thisType;
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

    await for (final input in buildStep.findAssets(Glob('**.dart'))) {
      final library = await buildStep.resolver.libraryFor(input);
      final classesInLibrary = LibraryReader(library).classes;
      classes.addAll(classesInLibrary.where((c) => c.thisType.isDataObject));
    }
    classes.sort((a, b) => a.hasGettersOfClass(b) ? 1 : 0);

    final output = '''
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

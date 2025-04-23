// ignore_for_file: depend_on_referenced_packages
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

class GenericDataObjectBuilder implements Builder {
  static AssetId _allFileOutput(BuildStep buildStep) {
    return AssetId(
      buildStep.inputId.package,
      p.join('lib', 'src', 'generic_data_objects.g.dart'),
    );
  }

  @override
  Future build(BuildStep buildStep) async {
    final classNames = <String>[];

    await for (final input in buildStep.findAssets(Glob('lib/src/data/**.dart'))) {
      final library = await buildStep.resolver.libraryFor(input);
      final classesInLibrary = LibraryReader(library).classes;
      classNames.addAll(classesInLibrary.where((c) => c.thisType.isDataObject).map((c) => c.name));
    }
    final output = '''
import '../common.dart';

final dataTypes = [
  ${classNames.join(',\n  ')}
];
''';
    await buildStep.writeAsString(_allFileOutput(buildStep), output);
  }

  @override
  final buildExtensions = const {
    r'$lib$': ['src/generic_data_objects.g.dart'],
  };
}

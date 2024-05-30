import 'dart:async';

import 'package:macros/macros.dart';

macro class TypeLookup implements LibraryDeclarationsMacro {
  final List<Type> dataTypes;

  const TypeLookup(this.dataTypes);

  @override
  FutureOr<void> buildDeclarationsForLibrary(Library library,
      DeclarationBuilder builder) {
    final typeToSnakeCase = dataTypes.map((Type t) {
      String snakeCase = t.toString().replaceAllMapped(
        RegExp(r'/[A-Z]/g'), (match) => '_${match.group(0)!
          .toString()
          .toLowerCase()}',);
      snakeCase = snakeCase.substring(1, snakeCase.length);
      return "const (${t.toString()}) => '$snakeCase',";
    });

    final snakeCaseToType = dataTypes.map((Type t) {
      String snakeCase = t.toString().replaceAllMapped(
        RegExp(r'/[A-Z]/g'), (match) => '_${match.group(0)!
          .toString()
          .toLowerCase()}',);
      snakeCase = snakeCase.substring(1, snakeCase.length);
      return "'$snakeCase' => ${t.toString()},";
    });

    builder.declareInLibrary(
        DeclarationCode.fromString('''
String getTableNameFromType(Type t) {
  return switch (t) {
    $typeToSnakeCase
  };
}
'''),
    );

        builder.declareInLibrary(
        DeclarationCode.fromString('''
Type getTypeFromTableName(String tableName) {
  return switch (tableName) {
    $snakeCaseToType
  };
}
'''),
    );
  }
}

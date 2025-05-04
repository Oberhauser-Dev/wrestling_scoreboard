# Wrestling Scoreboard Generator Library

Generation tool for wrestling scoreboard.

Add `build.yaml` file to the root of your project to generate type conversion methods:

```yaml title="build.yaml"
builders:
  genericDataObjectBuilder:
    import: "package:wrestling_scoreboard_generator/builder.dart"
    builder_factories: ["genericDataObjectBuilder"]
    build_extensions: {".dart": ["generic_data_objects.dart"]}
    build_to: source
    required_inputs: [".freezed.dart", ".g.dart"]
    auto_apply: root_package
```

Execute to generate:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

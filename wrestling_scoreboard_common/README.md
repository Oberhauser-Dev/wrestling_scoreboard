# Wrestling Scoreboard Common Library

## Usage

A simple usage example:

```dart
import 'package:wrestling_scoreboard_common/common.dart';

main() {
  var club = Club(name: 'MyClubName');
}
```

## Json Serialization

Build Json Serialization models with:
```
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Adding a new data object type

Update following files accordingly:
- `package:wrestling_scoreboard_common/lib/src/util/data_wrapper.dart`
- `package:wrestling_scoreboard_common/lib/src/data/data_oject.dart`
- `package:wrestling_scoreboard_common/lib/src/data.dart`
- `package:wrestling_scoreboard_server/lib/routes/api_route.dart`
- `package:wrestling_scoreboard_server/lib/controllers/websocket_handler.dart`
- `package:wrestling_scoreboard_server/lib/controllers/entity_controller.dart@getControllerFromDataType`
- `package:wrestling_scoreboard_server/public/index.html`
- Migrate and export database
- `package:wrestling_scoreboard_client/lib/mocks/mock_data_provider.dart`
- `package:wrestling_scoreboard_client/lib/mocks/mocks.dart`

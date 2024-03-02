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
- `package:common/lib/src/util/data_wrapper.dart`
- `package:common/lib/src/data/data_oject.dart`
- `package:common/lib/src/data.dart`
- `package:server/lib/routes/api_route.dart`
- `package:server/lib/controllers/websocket_handler.dart`
- `package:server/lib/controllers/entity_controller.dart@getControllerFromDataType`
- `package:server/public/index.html`
- Adapt and export database
- `package:client/lib/mocks/mock_data_provider.dart`
- `package:client/lib/mocks/mocks.dart`

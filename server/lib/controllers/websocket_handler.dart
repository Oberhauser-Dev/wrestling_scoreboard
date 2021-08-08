import 'dart:convert';

import 'package:common/common.dart';
import 'package:server/controllers/participation_controller.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

import 'entity_controller.dart';

final websocketHandler = webSocketHandler((webSocket) {
  final handleSingle = ({required CRUD operation, required DataObject single}) async {
    final controller = EntityController.getControllerFromDataType(single.runtimeType);
    if (operation == CRUD.update) {
      await controller.updateSingle(single);
      webSocket.sink.add(jsonEncode(singleToJson(single, operation)));
    } else if (operation == CRUD.create) {
      single.id = await controller.createSingle(single);
    } else if (operation == CRUD.delete) {
      await controller.deleteSingle(single.id!);
    }
    // Currently do not update list of all entities (as is and should not used anywhere)
    if(operation != CRUD.read) {
      /*webSocket.sink.add(jsonEncode(
        manyToJson(await EntityController.getControllerFromDataType(single.runtimeType).getMany(), operation)));*/
      if (single is Participation) {
        webSocket.sink.add(jsonEncode(manyToJson(
            await ParticipationController()
                .getMany(conditions: ['lineup_id = @id'], substitutionValues: {'id': single.lineup.id}),
            CRUD.update,
            filterType: Lineup,
            filterId: single.lineup.id)));
      } else if (single is Lineup) {
        // No filtered list needs to be handled.
      } else {
        throw DataUnimplementedError(operation, single.runtimeType);
      }
    }
  };
  final handleMany = ({required CRUD operation, required Iterable<DataObject> many, Type? filterType, int? filterId}) {
    throw DataUnimplementedError(operation, many.runtimeType);
  };

  webSocket.stream.listen((message) {
    final json = jsonDecode(message);
    handleFromJson(json, handleSingle, handleMany);
  });
});

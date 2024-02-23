import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/mocks/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';

part 'network_provider.g.dart';

@Riverpod(keepAlive: true)
class MockDataManagerNotifier extends _$MockDataManagerNotifier implements DataManagerNotifier {
  @override
  Raw<Future<DataManager>> build() async {
    return MockDataManager();
  }
}

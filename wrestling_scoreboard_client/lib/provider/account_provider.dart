import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

part 'account_provider.g.dart';

@Riverpod(keepAlive: true, dependencies: [DataManagerNotifier])
class UserNotifier extends _$UserNotifier {
  @override
  Raw<Future<User?>> build() async {
    final dataManager = await ref.watch(dataManagerProvider);
    return await dataManager.getUser();
  }

  Future<void> signUp(User user) async {
    final dataManager = await ref.read(dataManagerProvider);
    await dataManager.signUp(user);
    await signIn(username: user.username, password: user.password!);
  }

  Future<void> signIn({required String username, required String password}) async {
    final dataManager = await ref.read(dataManagerProvider);
    final token = await dataManager.signIn(BasicAuthService(username: username, password: password));
    await ref.read(jwtProvider.notifier).setState(token);
  }

  Future<void> signOut() async {
    await ref.read(jwtProvider.notifier).setState(null);
  }

  Future<void> updateUser({required User user}) async {
    final dataManager = await ref.read(dataManagerProvider);
    await dataManager.updateUser(user);
  }
}

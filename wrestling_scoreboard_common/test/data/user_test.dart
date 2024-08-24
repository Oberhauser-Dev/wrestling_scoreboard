import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';

void main() {
  test('Password check', () {
    final password = 'hello123!';
    final user = User(username: 'MyUsername', password: password, createdAt: DateTime.now());
    final securedUser = user.toSecuredUser();
    expect(securedUser.salt?.length, 8);
    expect(securedUser.checkPassword(password), true);
    expect(securedUser.checkPassword('otherpassword'), false);
  });
}

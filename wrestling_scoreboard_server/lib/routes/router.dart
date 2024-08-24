import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/services/auth.dart';

extension RestrictedRouter on Router {
  void restrictedGet(String route, Future<Response> Function(Request request, User user) handler,
          [UserPrivilege privilege = UserPrivilege.none]) =>
      get(route, (Request request) => request.restricted(privilege: privilege, handler: handler));

  void restrictedGetOne(String route, Future<Response> Function(Request request, User user, String arg1) handler,
          [UserPrivilege privilege = UserPrivilege.none]) =>
      get(route,
          (Request request, arg1) => request.restricted(privilege: privilege, handler: (r, u) => handler(r, u, arg1)));

  void restrictedGetTwo(
      String route, Future<Response> Function(Request request, User user, String arg1, String arg2) handler,
      [UserPrivilege privilege = UserPrivilege.none]) {
    get(
        route,
        (Request request, arg1, arg2) =>
            request.restricted(privilege: privilege, handler: (r, u) => handler(r, u, arg1, arg2)));
  }

  void restrictedPost(String route, Future<Response> Function(Request request, User user) handler,
          [UserPrivilege privilege = UserPrivilege.write]) =>
      post(route, (Request request) => request.restricted(privilege: privilege, handler: handler));

  void restrictedPostOne(String route, Future<Response> Function(Request request, User user, String arg1) handler,
          [UserPrivilege privilege = UserPrivilege.write]) =>
      post(route,
          (Request request, arg1) => request.restricted(privilege: privilege, handler: (r, u) => handler(r, u, arg1)));

  void restrictedPut(String route, Future<Response> Function(Request request, User user) handler,
          [UserPrivilege privilege = UserPrivilege.write]) =>
      put(route, (Request request) => request.restricted(privilege: privilege, handler: handler));

  void restrictedOptions(String route, Future<Response> Function(Request request, User user) handler,
          [UserPrivilege privilege = UserPrivilege.none]) =>
      options(route, (Request request) => request.restricted(privilege: privilege, handler: handler));

  void restrictedDelete(String route, Future<Response> Function(Request request, User user) handler,
          [UserPrivilege privilege = UserPrivilege.write]) =>
      delete(route, (Request request) => request.restricted(privilege: privilege, handler: handler));

  void restrictedPatch(String route, Future<Response> Function(Request request, User user) handler,
          [UserPrivilege privilege = UserPrivilege.write]) =>
      patch(route, (Request request) => request.restricted(privilege: privilege, handler: handler));
}

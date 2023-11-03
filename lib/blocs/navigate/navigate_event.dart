import 'package:alemagro_application/models/user_role.dart';

abstract class RouteEvent {}

class RouteLogin extends RouteEvent {}

class RouteHome extends RouteEvent {
  final UserRole userRole;

  RouteHome(this.userRole);
}

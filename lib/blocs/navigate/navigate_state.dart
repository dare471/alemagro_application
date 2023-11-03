import 'package:alemagro_application/models/user_role.dart';

abstract class RouteState {}

class RouteLoginState extends RouteState {}

class RouteHomeState extends RouteState {
  final UserRole userRole;

  RouteHomeState(this.userRole);
}

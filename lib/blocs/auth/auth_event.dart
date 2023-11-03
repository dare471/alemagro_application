// ignore_for_file: override_on_non_overriding_member, duplicate_ignore

abstract class AuthEvent {}

class AuthStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String token;
  final int userId;
  LoggedIn({required this.token, required this.userId});
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({required this.username, required this.password});

  // ignore: override_on_non_overriding_member
  @override
  List<Object> get props => [username, password];
}

class CheckPinStored extends AuthEvent {}

class LoggedOut extends AuthEvent {}

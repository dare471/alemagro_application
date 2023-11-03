import 'package:alemagro_application/blocs/navigate/navigate_event.dart';
import 'package:alemagro_application/blocs/navigate/navigate_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc()
      : super(
            RouteLoginState()); // Предполагаем, что начальное состояние - это экран входа

  @override
  Stream<RouteState> mapEventToState(RouteEvent event) async* {
    if (event is RouteLogin) {
      yield RouteLoginState();
    } else if (event is RouteHome) {
      yield RouteHomeState(event.userRole);
    }
  }
}

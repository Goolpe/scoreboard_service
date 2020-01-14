import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:scoreboard_service/shelf.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final String userName = await getUserName();

      yield userName.isNotEmpty
      ? AuthenticationAuthenticated()
      : AuthenticationUnauthenticated();
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await persistUserName(event.userName);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await removeUserName();
      yield AuthenticationUnauthenticated();
    }
  }
}
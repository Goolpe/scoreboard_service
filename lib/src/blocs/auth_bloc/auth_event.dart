import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => <Object>[];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  const LoggedIn({
    @required this.userName
  });

  final String userName;

  @override
  List<String> get props => <String>[userName];

  @override
  String toString() => 'LoggedIn { userName: $userName }';
}
class LoggedOut extends AuthenticationEvent {}
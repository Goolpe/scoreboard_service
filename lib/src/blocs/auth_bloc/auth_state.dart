import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  
  @override
  List<Object> get props => <Object>[];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AppLoading extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}
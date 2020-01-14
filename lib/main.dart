import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoreboard_service/shelf.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(
    MultiBlocProvider(
      providers: <BlocProvider<Bloc<dynamic, dynamic>>>[
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) =>
            AuthenticationBloc()..add(AppStarted()),
        ),
      ],
      child: App()
    ),
  );
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scoreboard service',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (BuildContext context, AuthenticationState authenticationState) =>
          authenticationState is AuthenticationUninitialized
          ? const Scaffold()
          : authenticationState is AuthenticationAuthenticated
          ? HomeScreen()
          : WelcomeScreen()
      )
    );
  }
}

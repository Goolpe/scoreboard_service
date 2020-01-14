import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoreboard_service/shelf.dart';

class WelcomeScreen extends StatefulWidget{

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>{

  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Tervetuloa!', style: TextStyle(fontSize:30)),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: const Text('Please, input your name')
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Form(
                      key: _loginKey,
                      child: TextFormField(
                        validator: (String data) {
                          if(data.isEmpty) 
                            return 'Input the name';
                          else 
                            return null;
                        },
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          counter: SizedBox(),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        focusNode: _nameFocus,
                        onFieldSubmitted: (_){
                          _nameFocus.unfocus();
                          _login();
                        },
                        maxLength: 25,
                      )
                    )
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    color: Colors.blue,
                    onPressed: () => _login(),
                  )
                ]
              )
            ]
          )
        ),
      )
    );
  }

  Future<void> _login() async{
    if(_loginKey.currentState.validate()){
      BlocProvider.of<AuthenticationBloc>(context).add(
        LoggedIn(userName: _nameController.text)
      );
      _nameController.clear();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
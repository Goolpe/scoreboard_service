import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoreboard_service/shelf.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PanelComponent extends StatefulWidget{
  const PanelComponent({
    @required this.child,
    @required this.controller
  });

  final Widget child;
  final PanelController controller;

  @override
  _PanelComponentState createState() => _PanelComponentState();
}

class _PanelComponentState extends State<PanelComponent>{

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  final FocusNode _descriptionFocus = FocusNode(); 
  final FocusNode _scoreFocus = FocusNode(); 
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      controller: widget.controller,
      backdropEnabled: true,
      minHeight: 0,
      maxHeight: 250,
      defaultPanelState: PanelState.CLOSED,
      onPanelClosed: (){
        _descriptionFocus.unfocus();
        _scoreFocus.unfocus();
      },
      panel: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('New score')
                  ),
                  FlatButton(
                    textColor: Colors.blue,
                    child: const Text('Add'),
                    onPressed: () => _addPlayer(context),
                  )
                ]
              ),
              const Divider(height: 1,),
              TextFormField(
                validator: (String data) {
                  if(data.isEmpty)
                    return 'Input the score';
                  else 
                    return null;
                },
                focusNode: _scoreFocus,
                controller: _scoreController,
                decoration: InputDecoration(
                  icon: Icon(Icons.score),
                  labelText: 'Score',
                  counter: const SizedBox()
                ),
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_){
                  _scoreFocus.unfocus();
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                maxLength: 6,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  icon: Icon(Icons.create),
                  labelText: 'Description',
                  counter: const SizedBox(),
                ),
                textCapitalization: TextCapitalization.sentences,
                focusNode: _descriptionFocus,
                onFieldSubmitted: (_){
                  _descriptionFocus.unfocus();
                  _addPlayer(context);
                },
                maxLength: 25,
              )
            ]
          )
        ),
      ),
      body: widget.child
    );
  }

  void _addPlayer(BuildContext context){
    _descriptionFocus.unfocus();
    _scoreFocus.unfocus();
    if(_formKey.currentState.validate()){
      widget.controller.close();
      BlocProvider.of<ItemsBloc>(context).add(
        ItemsAdd(
          Item(
            description: _descriptionController.text,
            score: int.parse(_scoreController.text)
          )
        )
      );
      _descriptionController.clear();
      _scoreController.clear();
    }
  }

  @override
  void dispose() {
    _descriptionController?.dispose();
    _scoreController?.dispose();
    super.dispose();
  }
}
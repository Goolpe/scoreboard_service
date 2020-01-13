import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoreboard_service/shelf.dart';

class HomeScreen extends StatelessWidget{
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  final FocusNode _nameFocus = FocusNode(); 
  final FocusNode _scoreFocus = FocusNode(); 
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: ListTile(
                title: Text('Player'),
                trailing: Text('Score'),
              ),
            ),
            Expanded(
              child: BlocBuilder<ItemBloc, ItemState>(
                builder: (BuildContext context, ItemState state){
                  if(state is ItemExist){
                    _nameController.clear();
                    _scoreController.clear();
                    
                    return ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (BuildContext context, int i){
                        return Column(
                          children: <Widget>[
                            Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              child: ListTile(
                                title: Text(state.items[i].name),
                                trailing: Text(state.items[i].score.toString()),
                              ),
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () => BlocProvider.of<ItemBloc>(context).add(ItemRemove(state.items[i].id)),
                                ),
                              ],
                            ),
                            i == state.items.length - 1
                            ? _inputPlayer(context)
                            : const SizedBox()
                          ]
                        );
                      },
                    );
                  } else{
                    return Align(
                      alignment: Alignment.topCenter,
                      child: _inputPlayer(context)
                    );
                  }
                }
              )
            )
          ]
        )
      )
    );
  }

  Widget _inputPlayer(BuildContext context){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Form(
        key: _formKey,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: TextFormField(
                  validator: (String data) {
                    if(data.isEmpty)
                      return 'Input the name';
                    else 
                      return null;
                  },
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    counter: SizedBox()
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  focusNode: _nameFocus,
                  onFieldSubmitted: (_){
                    _nameFocus.unfocus();
                    FocusScope.of(context).requestFocus(_scoreFocus);
                  },
                  maxLength: 50,
                ),
              )
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: TextFormField(
                  validator: (String data) {
                    if(data.isEmpty)
                      return 'Input the score';
                    else 
                      return null;
                  },
                  focusNode: _scoreFocus,
                  controller: _scoreController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Score',
                    counter: SizedBox()
                  ),
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (_){
                    _scoreFocus.unfocus();
                    _addPlayer(context);
                  },
                  maxLength: 10,
                )
              )
            ),
            // Expanded(
            //   child: Container(
            //     height: 70,
            //     margin: EdgeInsets.symmetric(horizontal: 4),
            //     child: RaisedButton(
            //       child: Text('Add'),
            //       onPressed: () => _addPlayer(context),
            //     ),
            //   )
            // )
          ]
        )
      )
    );
  }

  void _addPlayer(BuildContext context){
    if(_formKey.currentState.validate())
      BlocProvider.of<ItemBloc>(context).add(
        ItemAdd(
          Item(
            name: _nameController.text,
            score: int.parse(_scoreController.text)
          )
        )
      );
  }
}
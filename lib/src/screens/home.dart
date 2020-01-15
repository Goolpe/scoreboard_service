import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoreboard_service/shelf.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget{

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  final PanelController _pc = PanelController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: BlocProvider<ItemsBloc>(
          create: (BuildContext context) =>
            ItemsBloc()..add(ItemsStarted()),
          child: BlocListener<ItemsBloc, ItemsState>(
            listener: (BuildContext context, ItemsState state) {
              if (state is ItemsFailure) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${state.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<ItemsBloc, ItemsState>(
              builder: (BuildContext context, ItemsState state){

                if(state is ItemsUninitialize){
                  return const SizedBox();
                }

                return PanelComponent(
                  controller: _pc,
                  child: state is ItemsExist
                    ? Column(
                      children: <Widget>[
                        Card(
                          elevation: 10,
                          margin: const EdgeInsets.only(top: 24),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('${state.userName}', 
                                        style: TextStyle(
                                          fontSize: 18, 
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.exit_to_app),
                                        onPressed: () => _logOut(),
                                      )
                                    ]
                                  )
                                ),
                                MaterialButton(
                                  child: Row(
                                    children: <Widget>[
                                      Text('SCORE (${state.amount})', 
                                        style: TextStyle(
                                          fontSize: 14, 
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      state.sort == 'scoreUp' 
                                      ? Icon(Icons.arrow_drop_down)
                                      : state.sort == 'scoreDown' 
                                        ? Icon(Icons.arrow_drop_up)
                                        : const SizedBox(),
                                    ],
                                  ),
                                  onPressed: (){
                                    BlocProvider.of<ItemsBloc>(context).add(
                                      ItemsSort(state.sort == 'scoreUp' ? 'scoreDown' : 'scoreUp')
                                    );
                                  },
                                )
                              ],
                            )
                          )
                        ),
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(0),
                            separatorBuilder: (BuildContext context, int i) => 
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 12),
                                child: const Divider(height: 1)
                              ),
                            itemCount: state.items.length,
                            itemBuilder: (BuildContext context, int i){
                              return Column(
                                children: <Widget>[
                                  Slidable(
                                    actionPane: const SlidableDrawerActionPane(),
                                    child: ListTile(
                                      title: Text('${state.items[i].description}'),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                                        ),
                                        child: Text(state.items[i].score.toString(), 
                                          style: const TextStyle(
                                            color: Colors.white
                                          )
                                        ),
                                      ),
                                    ),
                                    secondaryActions: <Widget>[
                                      IconSlideAction(
                                        caption: 'Delete',
                                        color: Colors.red,
                                        icon: Icons.delete,
                                        onTap: () => BlocProvider.of<ItemsBloc>(context).add(ItemsRemove(state.items[i].id)),
                                      ),
                                    ],
                                  ),
                                  i == state.items.length - 1
                                  ? _openPanel(context)
                                  : const SizedBox()
                                ]
                              );
                            },
                          )
                        )
                      ]
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _openPanel(context),
                        FlatButton(
                          child: const Text('Log Out'),
                          onPressed: () => _logOut(),
                        )
                      ]
                  ),
                );
              }
            )
          )
        )
      )
    );
  }
  
  Widget _openPanel(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      height: 50,
      child: RaisedButton.icon(
        color: Theme.of(context).primaryColor,
        textColor: Theme.of(context).buttonColor,
        icon: Icon(Icons.add),
        label: const Text('Add new score'),
        onPressed: () => _pc.open(),
      )
    );
  }

  void _logOut(){
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
  }
}
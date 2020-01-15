import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoreboard_service/shelf.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState>{
  String sort = 'scoreDown';
  String userName  = '';
  int itemsLength = 0;
  int amount = 0;
  List<Item> items = <Item>[];

  @override
  ItemsState get initialState => ItemsUninitialize();

  @override
  Stream<ItemsState> mapEventToState(ItemsEvent event) async* {
    if (event is ItemsStarted) {
      yield* _mapStartedItemsToState();
    } else if (event is ItemsLoad) {
      yield* _mapLoadItemsToState();
    } else if (event is ItemsAdd) {
      yield* _mapAddItemsToState(event);
    } else if (event is ItemsRemove) {
      yield* _mapRemoveItemsToState(event);
    } else if (event is ItemsSort) {
      yield* _mapSortItemsToState(event);
    }
  }

  Stream<ItemsState> _mapStartedItemsToState() async*{
    try{
      userName = await getUserName();

      add(ItemsLoad());
    } catch(error){
      ItemsFailure(error);
    }
  }

  Stream<ItemsState> _mapLoadItemsToState() async*{
    try{
      final List<Item> items = List<Item>.from(
        await Item.getAll(userName)
      );

      if(itemsLength != items.length){
        itemsLength = items.length;
        amount = 0;
        for(Item item in items){
          amount += item.score;
        }
      }

      items.sort((Item a, Item b){
        switch(sort){
          case 'scoreUp': return a.score.compareTo(b.score);
          case 'scoreDown': return b.score.compareTo(a.score);
          default: return a.score.compareTo(b.score);
        }
      });

      yield items.isEmpty
      ? ItemsEmpty()
      : ItemsExist(
        items: items, 
        sort: sort,
        amount: amount,
        userName: userName
      );
    } catch(error){
      ItemsFailure(error);
    }
  }

  Stream<ItemsState> _mapAddItemsToState(ItemsAdd event) async*{
    try{
      await Item.persist(event.item, userName);

      add(ItemsLoad());
    } catch(error){
      ItemsFailure(error);
    }
  }

  Stream<ItemsState> _mapRemoveItemsToState(ItemsRemove event) async*{
    try{
      await Item.remove(event.itemID);
      add(ItemsLoad());
    } catch(error){
      ItemsFailure(error);
    }
  }

  Stream<ItemsState> _mapSortItemsToState(ItemsSort event) async*{
    sort = event.sort;
    add(ItemsLoad());
  }
}
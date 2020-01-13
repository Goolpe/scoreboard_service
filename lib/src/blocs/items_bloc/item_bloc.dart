import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoreboard_service/shelf.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState>{

  @override
  ItemState get initialState => ItemUninitialize();

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    if (event is ItemLoad) {
      yield* _mapLoadItemToState();
    } else if (event is ItemAdd) {
      yield* _mapAddItemToState(event);
    } else if (event is ItemRemove) {
      yield* _mapRemoveItemToState(event);
    }
  }

  Stream<ItemState> _mapLoadItemToState() async*{
    final List<Item> items = List<Item>.from(await Item.getAll());

    yield items.isEmpty
    ? ItemEmpty()
    : ItemExist(items);
  }

  Stream<ItemState> _mapAddItemToState(ItemAdd event) async*{
    await Item.persist(event.item);
   
    add(ItemLoad());
  }

  Stream<ItemState> _mapRemoveItemToState(ItemRemove event) async*{
    await Item.remove(event.itemID);

    add(ItemLoad());
  }
}
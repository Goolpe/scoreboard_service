import 'package:equatable/equatable.dart';
import 'package:scoreboard_service/shelf.dart';

abstract class ItemsEvent extends Equatable{
  const ItemsEvent();
  
  @override
  List<Object> get props => <Object>[];
}

class ItemsAdd extends ItemsEvent{
  const ItemsAdd(this.item);

  final Item item;
  
  @override
  List<Item> get props => <Item>[item];

  @override
  String toString() => 'ItemsAdd { item: $item }';
}

class ItemsRemove extends ItemsEvent{
  const ItemsRemove(this.itemID);

  final int itemID;
  
  @override
  List<int> get props => <int>[itemID];

  @override
  String toString() => 'ItemsRemove { itemID: $itemID }';
}

class ItemsStarted extends ItemsEvent {}

class ItemsLoad extends ItemsEvent{}

class ItemsSort extends ItemsEvent{
  const ItemsSort(this.sort);

  final String sort;
  
  @override
  List<String> get props => <String>[sort];

  @override
  String toString() => 'ItemsSort { sort: $sort }';
}
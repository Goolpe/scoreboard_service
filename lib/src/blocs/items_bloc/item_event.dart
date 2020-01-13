import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:scoreboard_service/shelf.dart';

abstract class ItemEvent extends Equatable{
  const ItemEvent();
  
  @override
  List<Object> get props => <Object>[];
}

class ItemAdd extends ItemEvent{
  const ItemAdd(this.item);

  final Item item;
  
  @override
  List<Item> get props => <Item>[item];

  @override
  String toString() => 'ItemAdd { item: $item }';
}

class ItemRemove extends ItemEvent{
  const ItemRemove(this.itemID);

  final int itemID;
  
  @override
  List<int> get props => <int>[itemID];

  @override
  String toString() => 'ItemRemove { itemID: $itemID }';
}


class ItemLoad extends ItemEvent{}
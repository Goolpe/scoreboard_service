import 'package:equatable/equatable.dart';
import 'package:scoreboard_service/shelf.dart';

abstract class ItemState extends Equatable{
  const ItemState();
  
  @override
  List<Object> get props => <Object>[];
}

class ItemUninitialize extends ItemState{}

class ItemEmpty extends ItemState{}

class ItemExist extends ItemState{
  const ItemExist([this.items = const <Item>[]]);

  final List<Item> items;

  @override
  List<List<Item>> get props => <List<Item>>[items];

  @override
  String toString() => 'ItemExist { items: $items }';
}
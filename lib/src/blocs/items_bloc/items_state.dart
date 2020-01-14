import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:scoreboard_service/shelf.dart';

abstract class ItemsState extends Equatable{
  const ItemsState();
  
  @override
  List<Object> get props => <Object>[];
}

class ItemsUninitialize extends ItemsState{}

class ItemsLoading extends ItemsState{}

class ItemsEmpty extends ItemsState{}

class ItemsExist extends ItemsState{
  const ItemsExist({
    @required this.items,
    @required this.sort,
    @required this.amount,
    @required this.userName
  });

  final List<Item> items;
  final String sort;
  final int amount;
  final String userName;

  @override
  List<Object> get props => <Object>[items, sort, amount, userName];

  @override
  String toString() => 'ItemsExist { items: $items, sort: $sort, amount:$amount, userName:$userName }';
}
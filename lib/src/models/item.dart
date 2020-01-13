import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:scoreboard_service/shelf.dart';
import 'package:sqflite/sqflite.dart';

class Item extends Equatable {
  const Item({
    this.id,
    @required this.name,
    @required this.score
  });

  final int id;
  final String name;
  final int score;

  @override
  List<Object> get props => [id,name,score];

  static Future<void> persist(Item data) async {
    final Database db = await DBProvider().database;

    await db.rawInsert(
      'INSERT Into Item (name,score) VALUES (?,?)',
      <dynamic>[
        data.name, 
        data.score
      ]
    );
  }

  static Future<void> remove(int itemID) async {
    final Database db = await DBProvider().database;

    await db.rawDelete(
      'DELETE FROM Item WHERE id = ?',
      <int>[
        itemID
      ]
    );
  }

  static Future<List<Item>> getAll() async {
    final Database db = await DBProvider().database;
    
    final List<Map<String, dynamic>> sqlData = await db.rawQuery('SELECT * FROM Item');

    return sqlData.isEmpty 
      ? <Item>[]
      : sqlData.map((Map<String, dynamic> data) => 
        Item.convert(data)).cast<Item>().toList();
  }

  static Item convert(Map<String, dynamic> data){
    return Item(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      score: data['score'] ?? 0
    );
  }
}
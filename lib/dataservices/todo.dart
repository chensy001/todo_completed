import 'package:sqflite/sqflite.dart';
import 'package:todo/entities/todo_entity.dart';

import 'database_helper.dart';

class Todo {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  Future<List<TodoEntity>> getItems(int category) async {
    Database db = await databaseHelper.database;
    var todos = await db.query(
      'todo',
      where: 'category=?',
      whereArgs: [category],
      orderBy: 'name',
    );
    List<TodoEntity> items = todos.isNotEmpty
        ? todos.map((e) => TodoEntity.fromMap(e)).toList()
        : [];
    return items;
  }

  Future<int> add(TodoEntity todo) async {
    Database db = await databaseHelper.database;
    return await db.insert(
      "todo",
      todo.toMap(),
    );
  }

  Future<int> remove(int id) async {
    Database db = await databaseHelper.database;
    return await db.delete(
      "todo",
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<int> update(TodoEntity todo) async {
    Database db = await databaseHelper.database;
    return await db.update(
      "todo",
      todo.toMap(),
      where: 'id=?',
      whereArgs: [todo.id],
    );
  }
}

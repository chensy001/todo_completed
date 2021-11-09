import 'package:sqflite/sqflite.dart';
import 'package:todo/entities/category_entity.dart';

import 'database_helper.dart';

class Category {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  Future<List<CategoryEntity>> getItems() async {
    Database db = await databaseHelper.database;
    var categories = await db.query(
      'category',
      orderBy: 'name',
    );
    List<CategoryEntity> items = categories.isNotEmpty
        ? categories.map((e) => CategoryEntity.fromMap(e)).toList()
        : [];
    return items;
  }

  Future<int> add(CategoryEntity category) async {
    Database db = await databaseHelper.database;
    return await db.insert(
      "category",
      category.toMap(),
    );
  }

  Future<int> remove(int id) async {
    Database db = await databaseHelper.database;
    return await db.delete(
      "category",
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<int> update(CategoryEntity category) async {
    Database db = await databaseHelper.database;
    return await db.update(
      "category",
      category.toMap(),
      where: 'id=?',
      whereArgs: [category.id],
    );
  }
}

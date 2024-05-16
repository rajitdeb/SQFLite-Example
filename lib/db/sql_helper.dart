import 'dart:developer';
import 'package:sqflite/sqflite.dart';

import '../model/db_item.dart';
import '../utils/app_constants.dart';

class SQLHelper {
  static Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
        """);
  }

  /// This function creates a database (if not exists)
  /// and call createTables() to create table (if not exists)
  static Future<Database> db() async {
    return openDatabase(AppConstants.dbName, version: 1,
        onCreate: (Database database, int version) async {
      await createTables(database);
    });
  }

  /// This function inserts item in DB
  static Future<int> createItem(DBItem dbItem) async {
    final db = await SQLHelper.db();

    final data = dbItem.toMap();
    final id = await db.insert(
      AppConstants.tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    return id;
  }

  /// Gets all items inside the specified table
  static Future<List<DBItem>> getAllItems() async {
    final db = await SQLHelper.db();
    List<DBItem> itemsList = [];
    await db.query('items', orderBy: 'id').then((value) {
      for (Map<String, dynamic> item in value) {
        itemsList.add(DBItem.fromMap(item));
      }
    });
    return itemsList;
  }

  /// Gets a single item based on specified ID
  static Future<List<DBItem>> getItemById(int id) async {
    final db = await SQLHelper.db();
    List<DBItem> items = [];
    await db
        .query('items', where: "id = ?", whereArgs: [id], limit: 1)
        .then((value) {
      for (Map<String, dynamic> item in value) {
        items.add(DBItem.fromMap(item));
      }
    });
    return items;
  }

  /// Updates an item based on ID
  static Future<int> updateItem(DBItem dbItem) async {
    final db = await SQLHelper.db();
    final data = dbItem.toMap();

    final result = await db.update(
      'items',
      data,
      where: "id = ?",
      whereArgs: [dbItem.id],
    );

    return result;
  }

  /// Deletes an item based on ID
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete('items', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      log("Something went wrong while deleting an item: Error: $err");
    }
  }
}

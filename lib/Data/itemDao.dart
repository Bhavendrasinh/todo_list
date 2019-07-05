import 'dart:async';
import './itemDatabase.dart';
import '../model/itemModel.dart';

class TodoDao {
  final dbProvider = DatabaseProvider.dbProvider;

//Adds new Todo records

  Future<int> createTodo(Todo todo) async {
    final db = await dbProvider.database;

    var result = db.insert(todoTABLE, todo.toDatabaseJson());

    return result;
  }

//Get All Todo items

  Future<List<Todo>> getTodos({List<String> columns, String query}) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;

    if (query == null) {
      result = await db.query(todoTABLE,
          columns: columns,
          where: 'date LIKE ?',
          whereArgs: ["%%"],
          orderBy: 'date');
    } else {}
    List<Todo> todos = result.isNotEmpty
        ? result
            .map((item) => Todo.fromDatabaseJson(item))
            .toList()
            .reversed
            .toList()
        : [];

    return todos;
  }

//Update Todo record

  Future<int> updateTodo(Todo todo) async {
    final db = await dbProvider.database;
    print(todo.toDatabaseJson());
    var result = await db.update(todoTABLE, todo.toDatabaseJson(),
        where: "id = ?", whereArgs: [todo.id]);

    return result;
  }

//Delete Todo records

  Future<int> deleteTodo(int id) async {
    final db = await dbProvider.database;

    var result = await db.delete(todoTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }
}

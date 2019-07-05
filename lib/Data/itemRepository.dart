import './itemDao.dart';
import '../model/itemModel.dart';

class TodoRepository {
  final todoDao = TodoDao();
  Future getAllTodos({String query}) => todoDao.getTodos(query: query);
  Future insertTodo(Todo todo) => todoDao.createTodo(todo);
  Future updateTodo(Todo todo) => todoDao.updateTodo(todo);
  Future deleteTodoById(int id) => todoDao.deleteTodo(id);


}

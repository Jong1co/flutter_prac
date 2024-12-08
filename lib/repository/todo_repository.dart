import 'package:ch2_todo_app/model/todo.dart';

abstract interface class TodoRepository {
  Future<Todo> findById(int id);
  Future<List<Todo>> findAll();
  Future<List<Todo>> findAllByDate(DateTime date);
  Future<Todo> add(Todo todo);
  Future<Todo> update(Todo todo);
  Future<void> remove(int id);
}

import 'package:ch2_todo_app/model/todo.dart';

class TodoService {
  Todo toggleTodo(Todo todo) {
    todo.isDone = !todo.isDone;
    return todo;
  }
}

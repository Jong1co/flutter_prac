import 'package:ch2_todo_app/model/todo.dart';
import 'package:get/get.dart';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    var fetchedTodos = [
      Todo(
        id: 1,
        title: 'title',
        content: 'content',
        createdAt: '2024-01-02',
        isDone: false,
      ),
      Todo(
        id: 2,
        title: 'title',
        content: 'content',
        createdAt: '2024-01-02',
        isDone: false,
      ),
      Todo(
        id: 3,
        title: 'title',
        content: 'content',
        createdAt: '2024-01-02',
        isDone: false,
      ),
    ];

    todos.assignAll(fetchedTodos);
  }
}

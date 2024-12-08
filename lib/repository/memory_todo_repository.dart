import 'package:ch2_todo_app/model/todo.dart';
import 'package:ch2_todo_app/repository/todo_repository.dart';
import 'package:ch2_todo_app/util/date_utils.dart';
import 'package:get/utils.dart';

class MemoryTodoRepository implements TodoRepository {
  static final List<Todo> _todos = [
    Todo(
      id: 1,
      title: '노션 작성하기',
      content: '오늘은 노션을 작성해야 한다.',
      createdAt: '2024-01-02',
      isDone: false,
    ),
    Todo(
      id: 2,
      title: 'Flutter Todo App 만들기',
      content: '유튜브 보고 GetX사용하여 todo app 만들기',
      createdAt: '2024-01-02',
      isDone: true,
    ),
    Todo(
      id: 3,
      title: '아침 운동하기',
      content: '헬스장 가서 유산소 운동하기',
      createdAt: '2024-01-03',
      isDone: false,
    ),
  ];

  @override
  Future<List<Todo>> findAll() async {
    return _todos;
  }

  @override
  Future<Todo> add(Todo todo) async {
    _todos.add(todo);
    return todo;
  }

  @override
  Future<List<Todo>> findAllByDate(DateTime date) async {
    return _todos
        .where((todo) => DateUtils.parse(todo.createdAt).isAtSameMomentAs(date))
        .toList();
  }

  @override
  Future<Todo> findById(int id) async {
    Todo? todo = _todos.firstWhereOrNull((todo) => todo.id == id);
    if (todo == null) throw Exception('$id 에 해당하는 Todo가 존재하지 않습니다.');

    return todo;
  }

  @override
  Future<void> remove(int id) {
    _todos.removeWhere((todo) => todo.id == id);
    return Future.value(); // 비동기 함수가 즉시 완료되게 할 수 있음.
  }

  @override
  Future<Todo> update(Todo todo) async {
    int index = _todos.indexWhere((element) => element.id == todo.id);
    if (index == -1) throw Exception('${todo.id} 에 해당하는 Todo가 존재하지 않습니다.');

    _todos[index] = todo;
    return todo;
  }
}
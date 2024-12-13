import 'package:ch2_todo_app/model/todo.dart';
import 'package:ch2_todo_app/repository/todo_repository.dart';
import 'package:ch2_todo_app/service/todo_service.dart';
import 'package:get/get.dart';

/// Todo를 캐싱해 두는 것이 좋을까?
/// -> 1. 속도 빠름 but 메모리 사용량 증가 & 데이터 불일치 문제 발생 가능
/// -> 2. 구현 필요
/// 그게 아니라면 변경 시마다 요청하는 것이 좋을까?
/// -> 1. 속도는 조금 느릴 수 있음 but 메모리 사용량 감소
/// -> 2. & 데이터 일치 -> 변경 시마다 데이터를 불러와야 함
/// 메모리 사용량이 과연 많을까?
/// 그렇게 많지 않다면 굳이 제거할 필요는 없을 것 같음.
class TodoController extends GetxController {
  final _todos = <Todo>[].obs;
  final _selectedDate = Rx<DateTime>(DateTime.now());

  final TodoRepository _todoRepository;
  final TodoService _todoService = TodoService();

  List<Todo> get todos => _todos;
  DateTime get selectedDate => _selectedDate.value;

  TodoController({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  Future<void> _refetchRangeDate() async {
    _todos.assignAll(await _todoRepository.findAllByDate(_selectedDate.value));
  }

  Future<void> toggleById(int? id) async {
    if (id == null) return;

    Todo todo = await _todoRepository.findById(id);
    todo = _todoService.toggleTodo(todo);
    await _todoRepository.update(todo);

    _refetchRangeDate();
  }

  Future<void> onChangeDate(DateTime date) async {
    _selectedDate.value = date;

    _refetchRangeDate();
  }

  Future<void> add(Todo todo) async {
    await _todoRepository.add(todo);
    _refetchRangeDate();
  }

  Future<void> remove(int id) async {
    await _todoRepository.remove(id);
    _refetchRangeDate();
  }

  Future<void> updateTodo(Todo todo) async {
    await _todoRepository.update(todo);
    _refetchRangeDate();
  }
}

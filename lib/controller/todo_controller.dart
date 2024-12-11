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
  final _selectedDate = <DateTime>[].obs;

  final TodoRepository _todoRepository;
  final TodoService _todoService = TodoService();

  get todos => _todos;
  get selectedDate => _selectedDate;

  TodoController({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  Future<void> _refetch() async {
    // TODO: refetch하는 부분을 공통으로 분리할 수 있을 것 같음 => selectedDate에 해당하는 데이터 refetch 해야 함
    _todos.assignAll(await _todoRepository.findAll());
  }

  Future<void> toggleById(int id) async {
    Todo todo = await _todoRepository.findById(id);
    todo = _todoService.toggleTodo(todo);
    await _todoRepository.update(todo);

    _refetch();
  }

  Future<void> onChangeDate(DateTime date) async {
    List<Todo> todos = await _todoRepository.findAllByDate(date);
    _refetch();
  }

  Future<void> add(Todo todo) async {
    await _todoRepository.add(todo);
    _refetch();
  }

  Future<void> remove(int id) async {
    await _todoRepository.remove(id);
    _refetch();
  }

  Future<void> updateTodo(Todo todo) async {
    await _todoRepository.update(todo);
    _refetch();
  }
}

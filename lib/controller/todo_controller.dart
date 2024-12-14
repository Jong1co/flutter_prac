import 'package:ch2_todo_app/model/todo.dart';
import 'package:ch2_todo_app/repository/todo_repository.dart';
import 'package:ch2_todo_app/service/todo_service.dart';
import 'package:get/get.dart';

/// 잘못 생각했음
/// 월별 리스트 전체를 받아온 후에, 필터링해서 사용했어야 할듯..
/// 월별 전체 리스트 조회 ->
///   선택한 날짜의 리스트 조회 ->
///   월별 todo가 있는지, done인지 조회

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

  Map<String, int> get todoMap => _getTodoMap();

  List<Todo> get doneTodos => _todos.where((todo) => todo.isDone).toList();
  List<Todo> get ongoingTodos => _todos.where((todo) => !todo.isDone).toList();

  DateTime get selectedDate => _selectedDate.value;

  TodoController({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  Map<String, int> _getTodoMap() {
    Map<String, int> map = <String, int>{};
    for (var todo in _todos) {
      if (todo.isDone) {
        map.update(todo.createdAt, (count) => count, ifAbsent: () => 0);
      } else {
        // ifAbsent => 존재하지 않을 경우 새로운 키-값 쌍 생성
        map.update(todo.createdAt, (count) => count + 1, ifAbsent: () => 1);
      }
    }

    return map;
  }

  Future<void> _refetchRangeDate() async {
    _todos.assignAll(await _todoRepository.findAllByDate(_selectedDate.value));
  }

  @override
  void onInit() async {
    super.onInit();
    await _refetchRangeDate();
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

  Future<void> remove(int? id) async {
    if (id == null) return;
    await _todoRepository.remove(id);
    _refetchRangeDate();
  }

  Future<void> updateTodo(Todo todo) async {
    await _todoRepository.update(todo);
    _refetchRangeDate();
  }
}

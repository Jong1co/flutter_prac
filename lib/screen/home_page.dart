import 'package:ch2_todo_app/controller/todo_controller.dart';
import 'package:ch2_todo_app/model/todo.dart';
import 'package:ch2_todo_app/repository/memory_todo_repository.dart';
import 'package:ch2_todo_app/util/date_tools.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final todoController =
      Get.put(TodoController(todoRepository: MemoryTodoRepository()));

  void moveToWritePage() => Get.toNamed('/write');

  AppBar _header(TodoController controller) {
    return AppBar(
      title: Text(
        DateTools.format(controller.selectedDate, 'yyyy.MM'),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: const Border(
        bottom: BorderSide(
          color: Colors.black12,
          width: 1,
        ),
      ),
    );
  }

  Widget _floatingButton() {
    return FloatingActionButton(
      onPressed: moveToWritePage,
      shape: const CircleBorder(),
      backgroundColor: Colors.blueAccent,
      child: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
    );
  }

  TableCalendar<dynamic> _calendar(TodoController controller) {
    return TableCalendar(
      headerVisible: false,
      firstDay: DateTime.utc(2020, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: controller.selectedDate,
      selectedDayPredicate: (day) => isSameDay(day, controller.selectedDate),
      onDaySelected: (selectedDay, focusedDay) =>
          controller.onChangeDate(selectedDay),
      onPageChanged: (focusedDay) => controller.onChangeDate(focusedDay),
      locale: 'ko_KR',
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          String date = DateTools.format(day);
          bool hasTodoOnDate = controller.todoMap.containsKey(date);
          String selectedDate = DateTools.format(controller.selectedDate);

          // Todo가 없는 경우, 혹은 선택한 날짜일 경우에는 marker 안 보여주도록 수정
          if (!hasTodoOnDate || date == selectedDate) {
            return null;
          }

          return controller.todoMap[date]! > 0
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999.0),
                    color: Colors.red,
                  ),
                )
              : Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999.0),
                    color: Colors.blue,
                  ),
                );
        },
      ),
      calendarStyle: const CalendarStyle(
        markersMaxCount: 1,
        markerSize: 4.0,
        markerDecoration: BoxDecoration(
          color: Colors.red,
        ),
        tablePadding: EdgeInsets.only(top: 16.0),
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          color: Colors.black, // 글꼴 색상 변경
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blueAccent, // 선택된 날짜의 배경색
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(
          color: Colors.white, // 선택된 날짜의 글꼴 색상
        ),
      ),
    );
  }

  Widget _draggableTodoList(TodoController _) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.6,
      maxChildSize: 1.0,
      snap: true,
      builder: (BuildContext ctx, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -4.0),
                  blurRadius: 50.0,
                  spreadRadius: 1.0,
                ),
              ]),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(999.0),
                    ),
                    height: 7,
                    width: 80,
                    // width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _title('할 일'),
              Expanded(
                child: Obx(() => ListView.builder(
                      itemCount: _.ongoingTodos.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        Todo todo = _.ongoingTodos[index];

                        return _todoItem(
                          todo: todo,
                          toggle: () => _.toggleById(todo.id),
                          remove: () => _.remove(todo.id),
                        );
                      },
                    )),
              ),
              _title('완료'),
              Expanded(
                child: Obx(() => ListView.builder(
                      itemCount: _.doneTodos.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        Todo todo = _.doneTodos[index];

                        return _todoItem(
                          todo: todo,
                          toggle: () => _.toggleById(todo.id),
                          remove: () => _.remove(todo.id),
                        );
                      },
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _title(String title) => Container(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  CheckboxListTile _todoItem({
    required Todo todo,
    required Function() toggle,
    required Function() remove,
  }) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: todo.isDone,
      onChanged: (value) => toggle(),
      title: Text(
        todo.title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(todo.content),
      secondary: IconButton(
        icon: const Icon(Icons.delete_forever),
        color: Colors.black45,
        onPressed: remove,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetX<TodoController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _header(_),
          floatingActionButton: _floatingButton(),
          // Stack이 뭔지 찾아보기
          body: Stack(
            children: [
              _calendar(_),
              _draggableTodoList(_),
            ],
          ),
        );
      },
    );
  }
}

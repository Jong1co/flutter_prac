import 'package:ch2_todo_app/controller/todo_controller.dart';
import 'package:ch2_todo_app/model/todo.dart';
import 'package:ch2_todo_app/repository/memory_todo_repository.dart';
import 'package:ch2_todo_app/util/date_tools.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatelessWidget {
  /// super.key :
  /// - statelessWidget이나 StatefulWidget의 생성자에서 key를 부모 클래스(extends "xxx")의 생성자로 전달하는 것
  ///   -> key가 뭔데?
  ///   -> 식별자인 거야. 그런데 그렇다면 key를 내가 직접 할당할 수 있어?
  ///
  /// key는 Flutter 위젯 트리에서 위젯을 고유하게 식별하는 데 사용됩니다.
  /// 이를 통해 Flutter 위젯 트리의 변경사항을 효율적으로 감지하고 업데이트 할 수 있습니다.
  HomePage({super.key}); // key는 뭘까?

  final todoController =
      Get.put(TodoController(todoRepository: MemoryTodoRepository()));

  void moveToWritePage() => Get.toNamed('/write');

  AppBar _appBar() {
    return AppBar(
      title: Text(DateTools.format(todoController.selectedDate, 'yyyy.MM')),
      shape: const Border(
        bottom: BorderSide(
          color: Colors.black12,
          width: 1,
        ),
      ),
    );
  }

  /// 함수형 프로그래밍에서는 암묵적 인자를 최대한 줄이는 것이 좋은 방식임(순수함수로)
  /// 하지만 객체지향 프로그래밍에서는 뭐가 좋은지 잘 모르겠음

  TableCalendar<dynamic> _calendar() {
    return TableCalendar(
      headerVisible: false,
      firstDay: DateTime.utc(2020, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: todoController.selectedDate,
      selectedDayPredicate: (day) =>
          isSameDay(day, todoController.selectedDate),
      onDaySelected: (selectedDay, focusedDay) =>
          todoController.onChangeDate(selectedDay),
      onPageChanged: (focusedDay) => todoController.onChangeDate(focusedDay),
      locale: 'ko_KR',
      calendarStyle: const CalendarStyle(
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

  @override
  Widget build(BuildContext context) {
    return GetX<TodoController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _appBar(),
          floatingActionButton: _floatingButton(),
          body: Column(
            children: [
              _calendar(),
              Expanded(
                child: ListView.builder(
                  itemCount: _.todos.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    Todo todo = _.todos[index];
                    return CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: todo.isDone,
                      onChanged: (value) => _.toggleById(todo.id),
                      title: Text(todo.title),
                      subtitle: Text(todo.content),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

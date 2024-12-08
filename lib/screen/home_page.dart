import 'package:ch2_todo_app/controller/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key}); // key는 뭘까?
  final todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    debugPrint(todoController.todos.toString());

    return Scaffold(
        backgroundColor: Colors.red,
        body: Column(
          children: [
            Expanded(
              child: GetX<TodoController>(
                builder: (controller) {
                  return ListView.builder(
                    itemCount: controller.todos.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.todos[index].title,
                                        style: const TextStyle(
                                          fontSize: 24,
                                        ),
                                      ),
                                      Text(
                                        controller.todos[index].content,
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    '\$30',
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Add to Cart'),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Total amount',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }
}

import 'package:ch2_todo_app/screen/home_page.dart';
import 'package:ch2_todo_app/screen/write_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting(); // 이거 추가해야 DateFormatting locale 한글로 설정 가능

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TODO APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(
          name: '/write',
          page: () => const WritePage(),
          transition: Transition.leftToRight,
          transitionDuration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn, // 이건 뭘까?
        ),
      ],
      // write: const WritePage(),
    );
  }
}

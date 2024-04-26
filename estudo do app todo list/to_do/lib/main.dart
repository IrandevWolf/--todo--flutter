import 'package:flutter/material.dart';
import 'package:to_do/pages/to_do_list_page.dart';
void main() {
  runApp( MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListPage(),
    );
  }
  
}



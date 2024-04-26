import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/models/Todo.dart';

const todoListKey = 'todo_list';

class TodoRepository {
  late SharedPreferences sharedPreferences;

  Future <List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) =>Todo.fromJson(e)).toList();
  }

  void saveTodolist(List<Todo> todos) {
    final String jsonString = json.encode(todos);
    sharedPreferences.setString(todoListKey, jsonString);
  }
}
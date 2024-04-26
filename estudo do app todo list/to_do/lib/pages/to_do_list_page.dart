import 'package:flutter/material.dart';
import 'package:to_do/models/Todo.dart';
import 'package:to_do/repositories/todo_repository.dart';

import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();
  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPos;

  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/perfect.jpg'),
            fit: BoxFit.fitHeight,
          )),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: todoController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Adicione uma tarefa',
                              hintText: 'Ex. Minhas tarefas !!',
                              hintStyle: TextStyle(
                                color: Colors.cyanAccent,
                              ),
                              errorText: errorText,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color(0xff00d7f3),
                                width: 2,
                              )),
                              labelStyle: TextStyle(color: Color(0XFF00D7F3))),
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.cyanAccent,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 22,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String Text = todoController.text;

                          if (Text.isEmpty) {
                            setState(() {
                              errorText = 'Adicione uma tarefa ';
                              TextStyle(fontSize: 24);
                            });

                            return;

                          }

                          setState(() {
                            Todo newTodo = Todo(
                              title: Text,
                              dateTime: DateTime.now(),
                            );
                            todos.add(newTodo);
                            errorText = null;
                          });
                          todoController.clear();
                          todoRepository.saveTodolist(todos);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff00d7f3),
                          padding: EdgeInsets.all(10),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 40,
                          //color: Colors.black26,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (Todo todo in todos)
                          TodoListItem(
                            todo: todo,
                            onDelete: onDelete,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                              'Você possui  ${todos.length} tarefas pendentes ',
                              style: TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 18,
                              ))),
                      SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: showDeleteTodosConfirmationDialog,
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff00d7f3),
                          padding: EdgeInsets.all(10),
                        ),
                        child: Text('zerar tarefas '),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodolist(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'tarefa ${todo.title} Foi removida com sucesso!',
          style: TextStyle(color: Color(0xff060708)),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: const Color(0XFF00D7F3),
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar tudo ?'),
        content: Text('Você tem certeza ? isso apagara todas as tarefas.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(primary: Color(0XFF00D7F3)),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            style: TextButton.styleFrom(primary: Colors.red),
            child: Text('Limpar tudo'),
          ),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodolist(todos);
  }
}

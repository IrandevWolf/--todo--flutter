import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:to_do/models/Todo.dart';
import 'package:intl/src/intl/date_format.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    Key? Key,
    required this.todo,
    required this.onDelete,
  }) : super(key: Key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyyy-HH:mm').format(todo.dateTime),
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        actionExtentRatio: 0.18,
        actionPane: const SlidableStrechActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: Colors.deepOrangeAccent,
            icon: Icons.delete,
            caption: 'Deletar',
            onTap: () {
              onDelete(todo);
            },
          ),
        ],
      ),
    );
  }
}

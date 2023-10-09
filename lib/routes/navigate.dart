import 'package:flutter/material.dart';
import 'package:todo_list/screen/todo_list.dart';

Future<void> navigateToTodoList(BuildContext context) async {
  final route = MaterialPageRoute(builder: (context) => const TodoList());
  await Navigator.push(context, route);
}

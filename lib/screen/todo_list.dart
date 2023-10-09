import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_list/screen/add_list.dart';
import 'package:todo_list/services/todo_service.dart';
import 'package:todo_list/utils/snackbar_helper.dart';
import 'package:todo_list/widget/card_todolist.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: Text(
                'No Task',
                style: TextStyle(fontSize: 30),
              ),
            ),
            child: ListView.builder(
                padding: const EdgeInsets.all(7.0),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  // final id = ((item['id'] ?? '') as String);
                  return CardTodoList(
                      index: index,
                      item: item,
                      navigateEdit: navigateToEditPage,
                      deleteById: deleteById);
                }),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: const Icon(Icons.add)),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddList());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => AddList(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final response = await TodoService.deleteById(id);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['id'] != id).toList();
      final responseJson = jsonDecode(response.body) as Map;
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, responseJson['message']);
      setState(() {
        items = filtered;
      });
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, "error");
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodo();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, "Something went wrong");
    }
    setState(() {
      isLoading = false;
    });
  }
}

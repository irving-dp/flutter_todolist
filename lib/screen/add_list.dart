import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_list/services/todo_service.dart';
import 'package:todo_list/utils/snackbar_helper.dart';

class AddList extends StatefulWidget {
  final Map? todo;
  const AddList({super.key, this.todo});

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Task' : 'Add Task'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(isEdit ? 'Update' : 'Submit')),
          )
        ],
      ),
    );
  }

  Future<void> submitData() async {
    final response = await TodoService.submitData(body);
    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';

      final responseJson = jsonDecode(response.body) as Map;
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, responseJson['message']);
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, 'error');
    }
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      showErrorMessage(context, "You cant't edit data");
    }

    final id = todo?['id'];
    final response = await TodoService.updateData(id, body);

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body) as Map;
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, responseJson['message']);
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, 'error');
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
    };
  }
}

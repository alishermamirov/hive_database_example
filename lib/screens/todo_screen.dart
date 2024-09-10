// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:hive_database_example/models/todo_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/todo_service.dart';
import '../setupLocator.dart';

class TodoScreen extends StatefulWidget {
  final List<TodoModel> todos;
  const TodoScreen({
    Key? key,
    required this.todos,
  }) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TodoService _todoService = locator<TodoService>();

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive example"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<TodoModel>('todoBox').listenable(),
        builder: (context, Box<TodoModel> box, child) {
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              var todo = box.getAt(index);
              return ListTile(
                title: Text(todo!.title),
                leading: Checkbox(
                  value: todo.isDone,
                  onChanged: (val) {
                    _todoService.toggleDone(todo, index);
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _todoService.deleteTodo(index);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add Todo'),
                  content: TextField(
                    controller: _controller,
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text('Add'),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          var todo = TodoModel(title: _controller.text);
                          _todoService.addTodo(todo);
                          _controller.clear();
                          Navigator.pop(context);
                        }
                      },
                    )
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

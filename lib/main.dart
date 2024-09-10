import 'package:flutter/material.dart';
import 'package:hive_database_example/models/todo_model.dart';
import 'package:hive_database_example/screens/todo_screen.dart';
import 'package:hive_database_example/services/todo_service.dart';
import 'package:hive_database_example/setupLocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
  Hive.registerAdapter(TodoModelAdapter());
  setuplocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: TodoService().getAllTodos(),
        builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return TodoScreen(
              todos: snapshot.data ?? [],
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

import 'package:hive/hive.dart';
import 'package:hive_database_example/models/todo_model.dart';

class TodoService {
  final _todoBoxName = "todoBox";
  Future<Box<TodoModel>> get _box async =>
      await Hive.openBox<TodoModel>(_todoBoxName);

  Future<void> addTodo(TodoModel todo) async {
    var box = await _box;
    box.add(todo);
  }

  Future<void> deleteTodo( int index) async {
    var box = await _box;
    box.deleteAt(index);
  }

  Future<void> toggleDone(TodoModel todo, int index) async {
    var box = await _box;
    todo.isDone = !todo.isDone;
    box.putAt(index, todo);
  }

  Future<List<TodoModel>> getAllTodos() async {
    var box = await _box;

    return box.values.toList();
  }
}

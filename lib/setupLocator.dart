import 'package:get_it/get_it.dart';
import 'package:hive_database_example/services/todo_service.dart';

final GetIt locator = GetIt.instance;

void setuplocator() {
  locator.registerLazySingleton(
    () => TodoService(),
  );
}

import 'package:path/path.dart'; 
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:todo_clean_architecture/features/task/data/datasources/task_list_datasource.dart';
import 'package:todo_clean_architecture/features/task/data/datasources/todo_task_datasource.dart';
import 'package:todo_clean_architecture/features/task/data/repositories/task_list_repository_impl.dart';
import 'package:todo_clean_architecture/features/task/data/repositories/todo_task_repository_impl.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/task_list_repository.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/todo_task_repository.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/add_task.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/add_task_list.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/delete_task.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/get_all_task_lists.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/get_tasks.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/toggle_completed.dart';
import 'package:todo_clean_architecture/features/task/presentation/task_lists_bloc/task_lists_bloc.dart';
import 'package:todo_clean_architecture/features/task/presentation/todo_tasks_bloc/todo_tasks_bloc.dart';

import 'features/task/domain/usecases/delete_task_list.dart';

final sl = GetIt.instance; 

Future init() async {
  //! Features - Task 
  sl.registerLazySingleton(() => TodoTasksBlocDependencies(
    getTasks: sl(), 
    addTask: sl(), 
    toggleCompleted: sl(), 
    deleteTask: sl(), 
  )); 
  sl.registerLazySingleton(() => TaskListsBlocDependencies(
    getAllTaskLists: sl(), 
    deleteTaskList: sl(), 
    addTaskList: sl()
  )); 


  sl.registerLazySingleton(() => GetTasks(sl())); 
  sl.registerLazySingleton(() => AddTask(sl())); 
  sl.registerLazySingleton(() => ToggleCompleted(sl())); 
  sl.registerLazySingleton(() => DeleteTask(sl())); 

  sl.registerLazySingleton(() => AddTaskList(sl())); 
  sl.registerLazySingleton(() => DeleteTaskList(sl())); 
  sl.registerLazySingleton(() => GetAllTaskLists(sl())); 

  sl.registerLazySingleton<TodoTaskRepository>(() => TodoTaskRepositoryImpl(sl())); 
  sl.registerLazySingleton<TaskListRepository>(() => TaskListRepositoryImpl(sl(), sl())); 

  sl.registerLazySingleton<TodoTaskDataSource>(() => TodoTaskDataSourceImpl(sl())); 
  sl.registerLazySingleton<TaskListDataSource>(() => TaskListDataSourceImpl(sl())); 

  //! External 
  final appDir = await getApplicationDocumentsDirectory(); 
  await appDir.create(recursive: true); 
  final databasePath = join(appDir.path, "sembast.db"); 
  final database = await databaseFactoryIo.openDatabase(databasePath); 
  sl.registerLazySingleton(() => database); 
}
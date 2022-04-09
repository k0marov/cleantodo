import 'package:dartz/dartz.dart';
import 'package:todo_clean_architecture/core/error/failures.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';

import '../values/todo_task.dart';

abstract class TodoTaskRepository {
  Future<Either<Failure, List<TodoTaskEntity>>> getTasks(String taskListId); 
  Future<Either<Failure, TodoTaskEntity>> addTask(String taskListId, TodoTask task); 
  Future<Either<Failure, void>> deleteTask(TodoTaskEntity taskEntity); 
  Future<Either<Failure, TodoTaskEntity>> toggleCompleted(TodoTaskEntity task); 
}
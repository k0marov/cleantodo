
import 'package:dartz/dartz.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/task_list_entity.dart';

import '../../../../core/error/failures.dart';
import '../values/task_list.dart';

abstract class TaskListRepository {
  Future<Either<Failure, List<TaskListEntity>>> getAllTaskLists(); 
  Future<Either<Failure, TaskListEntity>> addTaskList(TaskList newTaskList); 
  Future<Either<Failure, void>> deleteTaskList(TaskListEntity taskList); 
}
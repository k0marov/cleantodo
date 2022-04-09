import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_clean_architecture/core/error/failures.dart';
import 'package:todo_clean_architecture/core/usecases/usecase.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/todo_task_repository.dart';

import '../values/todo_task.dart';

class AddTask extends UseCase<TodoTaskEntity, AddTaskParams> {
  final TodoTaskRepository repository;

  AddTask(this.repository); 

  @override 
  Future<Either<Failure, TodoTaskEntity>> call(AddTaskParams params) async {
    return repository.addTask(params.taskListId, params.newTask); 
  }
}

class AddTaskParams extends Equatable {
  final String taskListId; 
  final TodoTask newTask;

  @override
  List get props => [taskListId, newTask]; 

  const AddTaskParams({required this.taskListId, required this.newTask}); 
}

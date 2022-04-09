import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_clean_architecture/core/usecases/usecase.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/task_list_repository.dart';

import '../../../../core/error/failures.dart';
import '../entities/task_list_entity.dart';
import '../values/task_list.dart';

/// If database is empty, inserts initial "My tasks" list and returns it 
class AddTaskList extends UseCase<TaskListEntity, AddTaskListParams> {
  final TaskListRepository repository; 
  AddTaskList(this.repository); 

  @override 
  Future<Either<Failure, TaskListEntity>> call(AddTaskListParams params) {
    return repository.addTaskList(params.taskList); 
  }
}

class AddTaskListParams extends Equatable {
  final TaskList taskList; 
  @override 
  List get props => [taskList]; 
  const AddTaskListParams({
    required this.taskList 
  }); 
}
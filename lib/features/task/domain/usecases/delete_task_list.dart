import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_clean_architecture/core/error/failures.dart';
import 'package:todo_clean_architecture/core/usecases/usecase.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/task_list_repository.dart';

import '../entities/task_list_entity.dart';

class DeleteTaskList extends UseCase<void, DeleteTaskListParams> {
  final TaskListRepository repository; 
  DeleteTaskList(this.repository); 

  @override 
  Future<Either<Failure, void>> call(DeleteTaskListParams params) {
    return repository.deleteTaskList(params.taskList); 
  }
}

class DeleteTaskListParams extends Equatable {
  final TaskListEntity taskList; 
  @override
  List get props => [taskList]; 

  const DeleteTaskListParams({
    required this.taskList
  }); 
}
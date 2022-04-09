import 'package:equatable/equatable.dart';
import 'package:todo_clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/todo_task_repository.dart';

import '../../../../core/usecases/usecase.dart';

class GetTasks extends UseCase<List<TodoTaskEntity>, GetTasksParams> {
  final TodoTaskRepository repository;
  GetTasks(this.repository); 

  @override
  Future<Either<Failure, List<TodoTaskEntity>>> call(GetTasksParams params) async {
    return repository.getTasks(params.taskListId); 
  }
}

class GetTasksParams extends Equatable {
  final String taskListId;
  @override 
  List get props => [taskListId]; 

  const GetTasksParams({required this.taskListId}); 

}

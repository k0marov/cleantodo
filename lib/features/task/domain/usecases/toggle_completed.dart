import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_clean_architecture/core/error/failures.dart';
import 'package:todo_clean_architecture/core/usecases/usecase.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/todo_task_repository.dart';

class ToggleCompleted extends UseCase<TodoTaskEntity, ToggleCompletedParams> {
  final TodoTaskRepository repository; 
  ToggleCompleted(this.repository); 

  @override
  Future<Either<Failure, TodoTaskEntity>> call(ToggleCompletedParams params) {
    return repository.toggleCompleted(params.task); 
  }
}

class ToggleCompletedParams extends Equatable {
  final TodoTaskEntity task; 
  @override
  List get props => [task]; 
  const ToggleCompletedParams({
    required this.task
  }); 
}
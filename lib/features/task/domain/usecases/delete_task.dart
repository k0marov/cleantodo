import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_clean_architecture/core/error/failures.dart';
import 'package:todo_clean_architecture/core/usecases/usecase.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/todo_task_repository.dart';

class DeleteTask extends UseCase<void, DeleteTaskParams> {
  final TodoTaskRepository repository; 
  const DeleteTask(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteTaskParams params) {
    return repository.deleteTask(params.taskEntity);
  } 
}

class DeleteTaskParams extends Equatable {
  final TodoTaskEntity taskEntity; 
  @override 
  List get props => [taskEntity]; 

  const DeleteTaskParams({required this.taskEntity}); 
}

import 'package:todo_clean_architecture/core/error/exceptions.dart';
import 'package:todo_clean_architecture/features/task/data/datasources/todo_task_datasource.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/todo_task_repository.dart';
import 'package:todo_clean_architecture/features/task/domain/values/todo_task.dart';

class TodoTaskRepositoryImpl implements TodoTaskRepository {
  final TodoTaskDataSource _datasource; 
  TodoTaskRepositoryImpl(this._datasource); 

  @override
  Future<Either<Failure, TodoTaskEntity>> addTask(String taskListId, TodoTask task) async {
    try {
      return Right(
        (await _datasource.addTask(taskListId, task))
          .toEntity()
      ); 
    } on DataException {
      return Left(DataFailure()); 
    }
  }

  @override
  Future<Either<Failure, List<TodoTaskEntity>>> getTasks(String taskListId) async {
    try {
      final tasks = await _datasource.getTasks(taskListId);
      return Right(
        tasks
          .map((taskListModel) => taskListModel.toEntity())
          .toList()
      );
    } on DataException {
      return Left(DataFailure()); 
    }
  }

  @override
  Future<Either<Failure, TodoTaskEntity>> toggleCompleted(TodoTaskEntity task) async {
    try {
      final newCompletedValue = !task.value.isCompleted; 
      final newModel = await _datasource.updateCompleted(task, newCompletedValue); 
      return Right(newModel.toEntity()); 
    } on DataException {
      return Left(DataFailure()); 
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(TodoTaskEntity taskEntity) async {
    try {
      return Right(await _datasource.deleteTask(taskEntity)); 
    } on DataException {
      return Left(DataFailure()); 
    }
  }
}
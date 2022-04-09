import 'package:todo_clean_architecture/core/const/list_colors.dart';
import 'package:todo_clean_architecture/core/error/exceptions.dart';
import 'package:todo_clean_architecture/features/task/data/datasources/task_list_datasource.dart';
import 'package:todo_clean_architecture/features/task/data/datasources/todo_task_datasource.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/task_list_entity.dart';
import 'package:todo_clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/task_list_repository.dart';
import 'package:todo_clean_architecture/features/task/domain/values/task_list.dart';

const initialTaskList = TaskList(
  color: ListColor.red, 
  title: "My Tasks"
); 

class TaskListRepositoryImpl implements TaskListRepository {
  final TaskListDataSource _taskListDatasource; 
  final TodoTaskDataSource _todoTaskDataSource; 
  TaskListRepositoryImpl(this._taskListDatasource, this._todoTaskDataSource); 

  @override
  Future<Either<Failure, TaskListEntity>> addTaskList(TaskList newTaskList) async {
    try {
      final response = await _taskListDatasource.addTaskList(newTaskList); 
      return Right(response.toEntity()); 
    } on DataException {
      return Left(DataFailure()); 
    }
  }

  @override
  Future<Either<Failure, void>> deleteTaskList(TaskListEntity taskList) async {
    try {
      await _taskListDatasource.deleteTaskList(taskList); 
      await _todoTaskDataSource.deleteAllTasks(taskList.id); 
      return Right(null); 
    } on DataException {
      return Left(DataFailure()); 
    }
  }

  @override
  Future<Either<Failure, List<TaskListEntity>>> getAllTaskLists() async {
    try {
      final response = await _taskListDatasource.getAllTaskLists(); 
      final result = response
          .map((taskListModel) => taskListModel.toEntity())
          .toList(); 
      if (result.isNotEmpty) return Right(result); 
      final addedTaskList = await _taskListDatasource.addTaskList(initialTaskList); 
      return Right([
        addedTaskList.toEntity()
      ]); 
    } on DataException {
      return Left(DataFailure()); 
    }
  }
  
}
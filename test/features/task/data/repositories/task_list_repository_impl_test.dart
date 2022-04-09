
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_clean_architecture/core/const/list_colors.dart';
import 'package:todo_clean_architecture/core/error/exceptions.dart';
import 'package:todo_clean_architecture/core/error/failures.dart';
import 'package:todo_clean_architecture/features/task/data/datasources/task_list_datasource.dart';
import 'package:todo_clean_architecture/features/task/data/datasources/todo_task_datasource.dart';
import 'package:todo_clean_architecture/features/task/data/models/task_list_model.dart';
import 'package:todo_clean_architecture/features/task/data/repositories/task_list_repository_impl.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/task_list_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/values/task_list.dart';

class MockTaskListDataSource extends Mock 
  implements TaskListDataSource {} 
class MockTodoTaskDataSource extends Mock 
  implements TodoTaskDataSource {} 

void main() {
  late TaskListRepositoryImpl sut;
  late MockTaskListDataSource mockTaskListDataSource; 
  late MockTodoTaskDataSource mockTodoTaskDataSource; 

  setUp(() {
    mockTaskListDataSource = MockTaskListDataSource(); 
    mockTodoTaskDataSource = MockTodoTaskDataSource(); 
    sut = TaskListRepositoryImpl(mockTaskListDataSource, mockTodoTaskDataSource);
  });

  const tTaskList = TaskList(
    title: "Test", 
    color: ListColor.blue, 
  ); 
  final tTaskListEntity = TaskListEntity(
    id: "123", 
    createdAt: DateTime.utc(2022),
    value: tTaskList
  ); 

  group('addTaskList', () {
    final tTaskListModel = TaskListModel(tTaskListEntity); 

    test(
      "should add new task list using datasource and return "
      " the new entity", 
      () async {
        // arrange
        when(() => mockTaskListDataSource.addTaskList(tTaskList))
          .thenAnswer((_) async => tTaskListModel); 
        // act
        final result = await sut.addTaskList(tTaskList); 
        // assert
        expect(result, equals(Right(tTaskListEntity))); 
        verify(() => mockTaskListDataSource.addTaskList(tTaskList)); 
        verifyNoMoreInteractions(mockTaskListDataSource); 
      },
    );

    test(
      "should return failure if datasource call failed",
      () async {
        // arrange
        when(() => mockTaskListDataSource.addTaskList(tTaskList))
          .thenThrow(DataException()); 
        // act
        final result = await sut.addTaskList(tTaskList); 
        // assert
        expect(result, equals(Left(DataFailure()))); 
        verify(() => mockTaskListDataSource.addTaskList(tTaskList));
        verifyNoMoreInteractions(mockTaskListDataSource); 
      },
    );
  }); 


  group('deleteTaskList', () {

    test(
      "should delete the task list entity using datasource,"
      " then delete corresponding todo tasks using other datasource"
      " and return nothing if datasource calls were successful", 
      () async {
        // arrange
        when(() => mockTaskListDataSource.deleteTaskList(tTaskListEntity))
          .thenAnswer((_) async {}); 
        when(() => mockTodoTaskDataSource.deleteAllTasks(tTaskListEntity.id))
          .thenAnswer((_) async {}); 
        // act
        final result = await sut.deleteTaskList(tTaskListEntity); 
        // assert
        expect(result.isRight(), true); 
        verify(() => mockTaskListDataSource.deleteTaskList(tTaskListEntity)); 
        verifyNoMoreInteractions(mockTaskListDataSource); 
        verify(() => mockTodoTaskDataSource.deleteAllTasks(tTaskListEntity.id)); 
        verifyNoMoreInteractions(mockTodoTaskDataSource);
      },
    );
    
    test(
      "should return failure if calling tasklist datasource is unsuccessful",
      () async {
        // arrange
        when(() => mockTaskListDataSource.deleteTaskList(tTaskListEntity))
          .thenThrow(DataException()); 
        when(() => mockTodoTaskDataSource.deleteAllTasks(tTaskListEntity.id))
          .thenAnswer((_) async {}); 
        // act
        final result = await sut.deleteTaskList(tTaskListEntity); 
        // assert
        expect(result, Left(DataFailure())); 
      },
    );
    test(
      "should return failure if calling todotask datasource is unsuccessful",
      () async {
        // arrange
        when(() => mockTaskListDataSource.deleteTaskList(tTaskListEntity))
          .thenAnswer((_) async {}); 
        when(() => mockTodoTaskDataSource.deleteAllTasks(tTaskListEntity.id))
          .thenThrow(DataException()); 
        // act
        final result = await sut.deleteTaskList(tTaskListEntity); 
        // assert
        expect(result, Left(DataFailure())); 
      },
    );
  }); 

  group('getAllTaskLists', () {
    final tListOfTaskLists = [
      TaskListEntity(
        id: "1", 
        createdAt: DateTime.utc(2001),
        value: tTaskList
      ), 
      TaskListEntity(
        id: "2", 
        createdAt: DateTime.utc(2002),
        value: tTaskList
      ),
      TaskListEntity(
        id: "3", 
        createdAt: DateTime.utc(2003),
        value: tTaskList
      )
    ]; 
    final tListOfTaskListModels = tListOfTaskLists
      .map((taskList) => TaskListModel(taskList))
      .toList(); 

    test(
      "should call datasource and return the task lists"
      " if call is successful", 
      () async {
        // arrange
        when(() => mockTaskListDataSource.getAllTaskLists())
          .thenAnswer((_) async => tListOfTaskListModels); 
        // act
        final result = await sut.getAllTaskLists(); 
        // assert
        result.fold(
          (failure) => expect(false, true), 
          (entityList) => expect(listEquals(entityList, tListOfTaskLists), true)
        ); 
        verify(() => mockTaskListDataSource.getAllTaskLists()); 
        verifyNoMoreInteractions(mockTaskListDataSource); 
      },
    );

    test(
      "should create initial task list and return it if database is empty",
      () async {
        // arrange
        final tInitial = [
          TaskListEntity(
            id: "Test", 
            createdAt: DateTime.now(),
            value: const TaskList(
              color: ListColor.red, 
              title: "My Tasks", 
            )
          )
        ]; 
        when(() => mockTaskListDataSource.getAllTaskLists())
          .thenAnswer((_) async => []); 
        when(() => mockTaskListDataSource.addTaskList(tInitial[0].value))
          .thenAnswer((_) async => TaskListModel(tInitial[0])); 
        // act
        final result = await sut.getAllTaskLists(); 
        // assert
        result.fold(
          (failure) => throw Exception(), 
          (list) => expect(listEquals(list, tInitial), true)
        ); 
        verify(() => mockTaskListDataSource.getAllTaskLists()); 
        verify(() => mockTaskListDataSource.addTaskList(tInitial[0].value)); 
        verifyNoMoreInteractions(mockTaskListDataSource); 
      },
    );

    test(
      "should return failure if datasource call is unsuccessful",
      () async {
        // arrange
        when(() => mockTaskListDataSource.getAllTaskLists())
          .thenThrow(DataException()); 
        // act
        final result = await sut.getAllTaskLists(); 
        // assert
        expect(result, Left(DataFailure())); 
        verify(() => mockTaskListDataSource.getAllTaskLists()); 
        verifyNoMoreInteractions(mockTaskListDataSource); 
      },
    );
  }); 
}

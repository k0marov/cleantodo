import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_clean_architecture/core/error/exceptions.dart';
import 'package:todo_clean_architecture/core/error/failures.dart';
import 'package:todo_clean_architecture/features/task/data/datasources/todo_task_datasource.dart';
import 'package:todo_clean_architecture/features/task/data/models/todo_task_model.dart';
import 'package:todo_clean_architecture/features/task/data/repositories/todo_task_repository_impl.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/values/todo_task.dart';


class MockTodoTaskDataSource extends Mock 
  implements TodoTaskDataSource {} 

void main() {
  late TodoTaskRepositoryImpl sut;
  late MockTodoTaskDataSource mockTodoTaskDataSource; 

  setUp(() {
    mockTodoTaskDataSource = MockTodoTaskDataSource(); 
    sut = TodoTaskRepositoryImpl(mockTodoTaskDataSource); 
  });

  group('deleteTask', () {
    const tTask = TodoTask(
      text: "Task", 
      isCompleted: false
    ); 
    final tTaskEntity = TodoTaskEntity(
      listId: "123", 
      createdAt: DateTime.now(),
      id: "1234", 
      value: tTask
    ); 
    test(
      "should return void if the call was successful (task exists)",
      () async {
        // arrange
        when(() => mockTodoTaskDataSource.deleteTask(tTaskEntity))
          .thenAnswer((_) async {}); 
        // act
        final result = await sut.deleteTask(tTaskEntity); 
        // assert
        expect(result, Right(null)); 
        verify(() => mockTodoTaskDataSource.deleteTask(tTaskEntity)); 
      },
    );
    test(
      "should return DataFailure if datasource call fails (for example, task does not exist)",
      () async {
        // arrange
        when(() => mockTodoTaskDataSource.deleteTask(tTaskEntity))
          .thenThrow(DataException()); 
        // act
        final result = await sut.deleteTask(tTaskEntity); 
        // assert
        expect(result, Left(DataFailure())); 
      },
    );
  });

  group('addTask', () {
    const tListId = "123"; 
    const tNewId = "newId"; 
    const tTask = TodoTask(
      text: "Task", 
      isCompleted: false
    ); 
    final tTaskEntity = TodoTaskEntity(
      listId: tListId, 
      createdAt: DateTime.now(),
      id: tNewId, 
      value: tTask
    ); 
    test(
      "should return new taskEntity if the call is successful"
      " (taskList exists)", 
      () async {
        // arrange
        when(() => mockTodoTaskDataSource.addTask(tListId, tTask))
          .thenAnswer((_) async => TodoTaskModel(tTaskEntity)); 
        // act
        final result = await sut.addTask(tListId, tTask); 
        // assert
        final expectedResult = Right(tTaskEntity); 
        expect(result, equals(expectedResult)); 
        verify(() => mockTodoTaskDataSource.addTask(tListId, tTask)); 
        verifyNoMoreInteractions(mockTodoTaskDataSource); 
      },
    );

    test(
      "should return DataFailure if the call throws"
      " (taskList doesn't exist)", 
      () async {
        // arrange
        when(() => mockTodoTaskDataSource.addTask(tListId, tTask))
          .thenThrow(DataException()); 
        // act
        final result = await sut.addTask(tListId, tTask); 
        // assert
        final expectedResult = Left(DataFailure()); 
        expect(result, equals(expectedResult)); 
        verify(() => mockTodoTaskDataSource.addTask(tListId, tTask)); 
        verifyNoMoreInteractions(mockTodoTaskDataSource); 
      },
    );
  }); 


  group('getTasks', () {
    const tListId = "123"; 
    const tTask = TodoTask(text: "task", isCompleted: false); 
    final tTasks = [
      TodoTaskEntity(listId: tListId, createdAt: DateTime.utc(2001), id: "1", value: tTask),
      TodoTaskEntity(listId: tListId, createdAt: DateTime.utc(2002), id: "2", value: tTask), 
      TodoTaskEntity(listId: tListId, createdAt: DateTime.utc(2003), id: "3", value: tTask),
    ]; 
    final tTaskModels = tTasks.map((task) => TodoTaskModel(task)).toList(); 

    test(
      "should return list of task entities if the call is successful"
      " (taskList exists)", 
      () async {
        // arrange
        when(() => mockTodoTaskDataSource.getTasks(tListId))
          .thenAnswer((_) async => tTaskModels); 
        // act
        final result = await sut.getTasks(tListId); 
        // assert
        result.fold(
          (failure) => expect(false, true), 
          (taskList) => expect(listEquals(taskList, tTasks), true) 
        ); 
        verify(() => mockTodoTaskDataSource.getTasks(tListId)); 
        verifyNoMoreInteractions(mockTodoTaskDataSource); 
      },
    );
    test(
      "should return DataFailure if the call is unsuccessful"
      " (taskList does not exist", 
      () async {
        // arrange
        when(() => mockTodoTaskDataSource.getTasks(tListId))
          .thenThrow(DataException()); 
        // act
        final result = await sut.getTasks(tListId); 
        // assert
        expect(result, equals(Left(DataFailure()))); 
        verify(() => mockTodoTaskDataSource.getTasks(tListId)); 
        verifyNoMoreInteractions(mockTodoTaskDataSource); 
      },
    );
  }); 


  group('toggleCompleted', () {
    final createdAt = DateTime.now(); 
    final tTaskNotCompleted = TodoTaskEntity(
      listId: "test", 
      id: "123", 
      createdAt: createdAt,
      value: const TodoTask(
        text: "task", 
        isCompleted: false
      )
    ); 
    final tTaskCompleted = TodoTaskEntity(
      listId: "test", 
      id: "123", 
      createdAt: DateTime.now(),
      value: const TodoTask(
        text: "task", 
        isCompleted: true
      )
    ); 

    test(
      "should call datasource"
      " and return a new entity with 'isCompleted' set to TRUE if it was FALSE", 
      () async {
        // arrange 
        when(() => mockTodoTaskDataSource.updateCompleted(tTaskNotCompleted, true))
          .thenAnswer((_) async => TodoTaskModel(tTaskCompleted)); 
        // act
        final result = await sut.toggleCompleted(tTaskNotCompleted); 
        // assert
        result.fold(
          (failure) => expect(false, true), 
          (entity) {
            expect(entity, equals(tTaskCompleted)); 
            expect(entity.value.isCompleted, true); 
          }
        ); 
        verify(() => mockTodoTaskDataSource.updateCompleted(tTaskNotCompleted, true)); 
        verifyNoMoreInteractions(mockTodoTaskDataSource); 
      },
    );
    test(
      "should call datasource"
      " and return a new entity with 'isCompleted' set to FALSE if it was TRUE", 
      () async {
        // arrange 
        when(() => mockTodoTaskDataSource.updateCompleted(tTaskCompleted, false))
          .thenAnswer((_) async => TodoTaskModel(tTaskNotCompleted));
        // act 
        final result = await sut.toggleCompleted(tTaskCompleted); 
        // assert
        result.fold(
          (failure) => expect(false, true), 
          (entity) {
            expect(entity, equals(tTaskNotCompleted)); 
            expect(entity.value.isCompleted, false); 
          }
        ); 
        verify(() => mockTodoTaskDataSource.updateCompleted(tTaskCompleted, false)); 
        verifyNoMoreInteractions(mockTodoTaskDataSource); 
      }
    ); 

    test(
      "should return failure if call to datasource throws DataException",
      () async {
        // arrange
        when(() => mockTodoTaskDataSource.updateCompleted(tTaskCompleted, false))
          .thenThrow(DataException());  
        // act
        final result = await sut.toggleCompleted(tTaskCompleted); 
        // assert
        expect(result, Left(DataFailure())); 
        verify(() => mockTodoTaskDataSource.updateCompleted(tTaskCompleted, false)); 
        verifyNoMoreInteractions(mockTodoTaskDataSource); 
      },
    );
  }); 
}

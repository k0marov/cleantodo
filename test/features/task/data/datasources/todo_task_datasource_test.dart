import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:todo_clean_architecture/core/error/exceptions.dart';
import 'package:todo_clean_architecture/features/task/data/datasources/todo_task_datasource.dart';
import 'package:todo_clean_architecture/features/task/data/models/todo_task_model.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/values/todo_task.dart';

void main() {
  late Database db; 
  late TodoTaskDataSourceImpl sut;

  setUp(() async {
    db = await newDatabaseFactoryMemory().openDatabase('test.db'); 
    sut = TodoTaskDataSourceImpl(db); 
  });

  const exceptionMatcher = TypeMatcher<DataException>(); 

  const tTodoTask = TodoTask(
    text: "Test", 
    isCompleted: false, 
  ); 
  const tListId = "123"; 
  final tTaskEntityList = [
    TodoTaskEntity(
      listId: tListId, 
      id: "1", 
      createdAt: DateTime.utc(2001),
      value: tTodoTask
    ), 
    TodoTaskEntity(
      listId: tListId, 
      id: "2", 
      createdAt: DateTime.utc(2002),
      value: tTodoTask
    ), 
  ]; 
  final tTaskModelList = tTaskEntityList
    .map((taskEntity) => TodoTaskModel(taskEntity))
    .toList(); 

  group('deleteAllTasks', () {
    final store = StoreRef(tListId); 
    test(
      "should delete all tasks from given list and return nothing",
      () async {
        // arrange
        for (final model in tTaskModelList) {
          store.record(model.toEntity().id).put(db, model.toJson()); 
        }
        // act
        await sut.deleteAllTasks(tListId); 
        // assert
        expect(await store.count(db), 0); 
      },
    );
  }); 

  group('deleteTask', () {
    final store = StoreRef(tListId); 
    const tId = "42"; 
    final tModel = TodoTaskModel(TodoTaskEntity(
      listId: tListId, 
      id: tId, 
      createdAt: DateTime.now(), 
      value: tTodoTask
    )); 
    test(
      "should delete the given task from the store and return nothing if it exists",
      () async {
        // arrange
        store.record(tId).put(db, tModel.toJson()); 
        // act
        await sut.deleteTask(tModel.toEntity()); 
        // assert
        expect(await store.count(db), 0); 
      },
    );
    test(
      "should throw DataException if given task does not exist",
      () async {
        // assert
        expect(() async => await sut.deleteTask(tModel.toEntity()), throwsA(exceptionMatcher)); 
      },
    );
  }); 
  group('addTask', () {
    test(
      "should add given task to the store with given id"
      " and return the created model", 
      () async {
        // act
        final result = await sut.addTask(tListId, tTodoTask); 
        // assert
        expect(result.toEntity().value, tTodoTask); 
        final dbData = await StoreRef(tListId).record(result.toEntity().id).get(db); 
        expect(mapEquals(dbData, result.toJson()), true); 
      },
    );
    test(
      "should throw DataException if something went wrong",
      () async {
        // arrange
        await db.close(); 
        // act
        final call = sut.addTask; 
        // assert
        expect(() async => call(tListId, tTodoTask), throwsA(exceptionMatcher)); 
      },
    );
  });

  group('getTasks', () {
    test(
      "should return all tasks of given taskList from db",
      () async {
        // arrange
        final store = StoreRef(tListId); 
        for (final taskModel in tTaskModelList) {
          await store.record(taskModel.toEntity().id).put(db, taskModel.toJson()); 
        }
        // act
        final result = await sut.getTasks(tListId); 
        // assert
        expect(listEquals(result, tTaskModelList), true); 
      },
    );
    test(
      "should throw DataException if there is some error",
      () async {
        // arrange
        await db.close(); 
        // act
        final call = sut.getTasks; 
        // assert
        expect(() async => call(tListId), throwsA(exceptionMatcher)); 
      },
    );
  }); 

  group('updateCompleted', () {
    const tId = "1";
    final createdAt = DateTime.now(); 
    final tNotCompleted = TodoTaskEntity(
      listId: tListId, 
      id: tId, 
      createdAt: createdAt,
      value: const TodoTask(
        text: "Test", 
        isCompleted: false
      )
    ); 
    final tCompleted = TodoTaskEntity(
      listId: tListId, 
      createdAt: createdAt, 
      id: tId, 
      value: const TodoTask(
        text: "Test", 
        isCompleted: true
      )
    ); 
    final tCompletedModel = TodoTaskModel(tCompleted); 
    final tNotCompletedModel = TodoTaskModel(tNotCompleted); 
    test(
      "should update 'completed' value to TRUE if it was given as input"
      " and return the new model", 
      () async {
        // arrange
        final store = StoreRef(tListId);  
        await store.record(tId).put(db, tNotCompletedModel.toJson()); 
        // act
        final result = await sut.updateCompleted(tNotCompleted, true); 
        // assert
        expect(result, tCompletedModel); 
        final dbValue = await store.record(tId).get(db); 
        expect(mapEquals(dbValue, tCompletedModel.toJson()), true); 
      },
    );
    test(
      "should update 'completed' value to FALSE if it was given as input"
      " and return the new model", 
      () async {
        // arrange
        final store = StoreRef(tListId);  
        await store.record(tId).put(db, tCompletedModel.toJson()); 
        // act
        final result = await sut.updateCompleted(tCompleted, false); 
        // assert
        expect(result, tNotCompletedModel); 
        final dbValue = await store.record(tId).get(db); 
        expect(mapEquals(dbValue, tNotCompletedModel.toJson()), true); 
      },
    );

    test(
      "should throw DataException if something went wrong",
      () async {
        // arrange
        await db.close();
        // act
        final call = sut.updateCompleted; 
        // assert
        expect(() async => call(tCompleted, false), throwsA(exceptionMatcher)); 
      },
    );
  }); 
}

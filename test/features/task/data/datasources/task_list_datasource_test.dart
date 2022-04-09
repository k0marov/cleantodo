import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:todo_clean_architecture/core/const/list_colors.dart';
import 'package:todo_clean_architecture/core/error/exceptions.dart';
import 'package:todo_clean_architecture/features/task/data/datasources/task_list_datasource.dart';
import 'package:todo_clean_architecture/features/task/data/datasources/todo_task_datasource.dart';
import 'package:todo_clean_architecture/features/task/data/models/task_list_model.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/task_list_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/values/task_list.dart';

void main() {
  late Database db ; 
  late TaskListDataSourceImpl sut;

  setUp(() async {
    db = await newDatabaseFactoryMemory().openDatabase("test.db"); 
    sut = TaskListDataSourceImpl(db); 
  }); 

  final store = StoreRef("taskLists"); 

  const tTaskList = TaskList(
    title: "Test", 
    color: ListColor.blue
  ); 


  const exceptionMatcher = TypeMatcher<DataException>(); 
  group('addTaskList', () {
    test(
      "should add new object on taskLists db store"
      " and return model with correct id", 
      () async {
        // act
        final result = await sut.addTaskList(tTaskList); 
        // assert
        final id = result.toEntity().id; 
        expect(await store.record(id).get(db), result.toJson()); 
        expect(result.toEntity().value, tTaskList); 
      },
    );
    test(
      "should throw DataException if something went wrong",
      () async {
        // arrange
       await db.close();  
        // act
        final call = sut.addTaskList; 
        // assert
        expect(() async => await call(tTaskList), 
          throwsA(exceptionMatcher)); 
      },
    );
  }); 

  group('deleteTaskList', () {
    const tId = "123"; 
    final tTaskListEntity = TaskListEntity(
      value: tTaskList, 
      createdAt: DateTime.utc(2022), 
      id: tId, 
    ); 
    final tTaskListModel = TaskListModel(tTaskListEntity);
    final tJsonData = tTaskListModel.toJson(); 
    test(
      "should delete the task list from db if it exists",
      () async {
        // arrange
        await store.record(tId).put(db, tJsonData); 
        // act
        await sut.deleteTaskList(tTaskListEntity); 
        // assert
        expect(await store.record(tId).exists(db), false); 
      },
    );
    test(
      "should throw DataException if task list does not exist",
      () async {
        // arrange skipped
        // act
        final call = sut.deleteTaskList; 
        // assert
        expect(() async => await call(tTaskListEntity), 
          throwsA(exceptionMatcher)); 
      },
    );
  }); 

  group('getAllTaskLists', () {
    const tTaskList = TaskList(
      title: "test", 
      color: ListColor.blue, 
    ); 
    final tTaskListEntities = [
      TaskListEntity(id: "3", createdAt: DateTime.utc(2003), value: tTaskList),
      TaskListEntity(id: "2", createdAt: DateTime.utc(2002), value: tTaskList), 
      TaskListEntity(id: "1", createdAt: DateTime.utc(2001), value: tTaskList),
    ]; 
    final tTaskListModels = tTaskListEntities 
      .map((entity) => TaskListModel(entity))
      .toList(); 

    test(
      "should get all task lists present in db store",
      () async {
        // arrange
        for (final model in tTaskListModels) {
          await store.record(model.toEntity().id)
                     .put(db, model.toJson()); 
        }
        // act
        final result = await sut.getAllTaskLists(); 
        // assert
        expect(listEquals(result, tTaskListModels), true); 
      },
    );

    test(
      "should throw DataException if some error happened",
      () async {
        // arrange
        await store.record("123").put(db, {'will-cause': 'error'}); 
        // act
        final call = sut.getAllTaskLists; 
        // assert
        expect(() async => call(), throwsA(exceptionMatcher)); 
      },
    );
  }); 
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_clean_architecture/features/task/data/models/todo_task_model.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/values/todo_task.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  // same as in fixtures/todo_task.json 
  final tEntity = TodoTaskEntity(
    listId: "123", 
    id: "123", 
    createdAt: DateTime.parse("2022-04-02T07:18:32.761571"),
    value: const TodoTask(
      text: "Test Todo Task", 
      isCompleted: false, 
    )
  ); 
  final tTodoTaskModel = TodoTaskModel(
    tEntity
  ); 

  group('toEntity', () {
    test(
      "should convert to a valid entity",
      () async {
        // assert 
        final result = tTodoTaskModel.toEntity(); 
        expect(result, isA<TodoTaskEntity>()); 
        expect(result, tEntity); 
      },
    );
  }); 

  group('fromJson', () {
    test(
      "should return a valid model",
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = 
          json.decode(fixture("todo_task.json")); 
        // act
        final result = TodoTaskModel.fromJson(jsonMap); 
        // assert
        expect(result, equals(tTodoTaskModel)); 
      },
    );
  }); 

  group('toJson', () {
    test(
      "should return a JSON map containing the proper data",
      () async {
        // act
        final result = tTodoTaskModel.toJson(); 
        // assert
        final expectedJsonMap = json.decode(fixture('todo_task.json')); 
        expect(result, expectedJsonMap); 
      },
    );
  }); 
}
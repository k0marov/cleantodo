import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_clean_architecture/core/const/list_colors.dart';
import 'package:todo_clean_architecture/features/task/data/models/task_list_model.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/task_list_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/values/task_list.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  // same as in "task_list.json"
  final tTaskList = TaskListEntity(
    id: "123", 
    createdAt: DateTime.parse("2022-04-02T07:18:32.761571"), 
    value: const TaskList(
      title: "Test", 
      color: ListColor.blue, 
    )
  ); 
  final tTaskListModel = TaskListModel(tTaskList); 
  final jsonMap = json.decode(fixture("task_list.json")); 

  group('toEntity', () {
    test(
      "should convert to a valid entity",
      () async {
        final result = tTaskListModel.toEntity(); 
        expect(result, tTaskList);
      },
    );
  });

  group('fromJson', () {
    test(
      "should return a valid model",
      () async {
        // act
        final result = TaskListModel.fromJson(jsonMap); 
        // assert
        expect(result, tTaskListModel);
      },
    );
  }); 

  group('toJson', () {
    test(
      "should convert to correct json", 
      () async {
        // act
        final result = tTaskListModel.toJson();
        // assert
        expect(result, jsonMap); 
      },
    );
  }); 
}

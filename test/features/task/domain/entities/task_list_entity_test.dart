import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_clean_architecture/core/const/list_colors.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/task_list_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/values/task_list.dart';

void main() {
  const tTaskListValue = TaskList(
    title: "Test", 
    color: ListColor.blue, 
  ); 

  test(
    "should have == overloaded properly",
    () async {
      // assert
      final first = TaskListEntity(id: "1", createdAt: DateTime.utc(2022), value: tTaskListValue); 
      final second = TaskListEntity(id: "1", createdAt: DateTime.utc(2022), value: tTaskListValue); 
      expect(first, equals(second)); 
    },
  );
  test(
    "should be comparable by createdAt",
    () async {
      // arrange
      var tList = [
        TaskListEntity(id: "1", createdAt: DateTime.utc(2003), value: tTaskListValue), 
        TaskListEntity(id: "2", createdAt: DateTime.utc(2001), value: tTaskListValue), 
        TaskListEntity(id: "3", createdAt: DateTime.utc(2002), value: tTaskListValue), 
      ]; 
      // act
      tList.sort(); 
      // assert
      final expectedList = [
        TaskListEntity(id: "1", createdAt: DateTime.utc(2003), value: tTaskListValue), 
        TaskListEntity(id: "3", createdAt: DateTime.utc(2002), value: tTaskListValue), 
        TaskListEntity(id: "2", createdAt: DateTime.utc(2001), value: tTaskListValue), 
      ]; 
      expect(listEquals(tList, expectedList), true); 
    },
  );
}

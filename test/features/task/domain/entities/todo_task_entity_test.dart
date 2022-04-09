import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/values/todo_task.dart';

void main() {
  const tValue = TodoTask(text: "Test Task", isCompleted: false); 
  const tListId = "123"; 
  test(
    "should have == overloaded properly",
    () async {
      final first = TodoTaskEntity(listId: tListId, createdAt: DateTime.utc(2022), id: "1", value: tValue); 
      final second = TodoTaskEntity(listId: tListId, createdAt: DateTime.utc(2022), id: "1", value: tValue); 
      expect(first, equals(second)); 
    },
  );

  test(
    "should be comparable by createdAt",
    () async {
      // arrange
      var tList = [
        TodoTaskEntity(listId: tListId, id: "1", createdAt: DateTime.utc(2003), value: tValue), 
        TodoTaskEntity(listId: tListId, id: "2", createdAt: DateTime.utc(2001), value: tValue), 
        TodoTaskEntity(listId: tListId, id: "3", createdAt: DateTime.utc(2002), value: tValue), 
      ]; 
      // act
      tList.sort(); 
      // assert
      final expectedList = [
        TodoTaskEntity(listId: tListId, id: "2", createdAt: DateTime.utc(2001), value: tValue), 
        TodoTaskEntity(listId: tListId, id: "3", createdAt: DateTime.utc(2002), value: tValue), 
        TodoTaskEntity(listId: tListId, id: "1", createdAt: DateTime.utc(2003), value: tValue), 
      ]; 
      expect(listEquals(tList, expectedList), true); 
    },
  );
}

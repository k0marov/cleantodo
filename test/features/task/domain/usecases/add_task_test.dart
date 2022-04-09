import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/todo_task_repository.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/add_task.dart';
import 'package:todo_clean_architecture/features/task/domain/values/todo_task.dart';

class MockTodoTaskRepository extends Mock 
  implements TodoTaskRepository {} 

void main() {
  late MockTodoTaskRepository mockTodoTaskRepository; 
  late AddTask sut;

  setUp(() {
    mockTodoTaskRepository = MockTodoTaskRepository(); 
    sut = AddTask(mockTodoTaskRepository);
  });

  const tListId = "123"; 
  const tTask = TodoTask(
    text: "Test", 
    isCompleted: false
  ); 
  final tTaskEntity = TodoTaskEntity(
    listId: tListId, 
    id: "321", 
    createdAt: DateTime.utc(2022),
    value: tTask
  ); 

  test(
    "should forward the call to repository and return created entity",
    () async {
      // arrange
      when(() => mockTodoTaskRepository.addTask(tListId, tTask))
        .thenAnswer((_) async => Right(tTaskEntity)); 
      // act
      final result = await sut(const AddTaskParams(taskListId: tListId, newTask: tTask)); 
      // assert
      expect(result, Right(tTaskEntity)); 
      verify(() => mockTodoTaskRepository.addTask(tListId, tTask)); 
    },
  );
}

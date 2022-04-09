import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/todo_task_repository.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/toggle_completed.dart';
import 'package:todo_clean_architecture/features/task/domain/values/todo_task.dart';

class MockTodoTaskRepository extends Mock 
  implements TodoTaskRepository {} 

void main() {
  late ToggleCompleted sut; 
  late MockTodoTaskRepository mockTodoTaskRepository; 

  setUp(() {
    mockTodoTaskRepository = MockTodoTaskRepository(); 
    sut = ToggleCompleted(mockTodoTaskRepository); 
  }); 
  final createdAt = DateTime.utc(2022); 
  final tTaskNotCompleted = TodoTaskEntity(
    listId: "id", 
    id: "testId", 
    createdAt: createdAt,
    value: const TodoTask(
      text: "Some Task", 
      isCompleted: false
    )
  ); 
  final tTaskCompleted = TodoTaskEntity(
    listId: "id", 
    id: "testId", 
    createdAt: createdAt,
    value: const TodoTask(
      text: "Some Task", 
      isCompleted: true
    )
  ); 

  test(
    "should set 'completed' to true if it was false"
    " using the repository",
    () async {
      // arrange
      when(() => mockTodoTaskRepository.toggleCompleted(tTaskNotCompleted))
        .thenAnswer((_) async => Right(tTaskCompleted)); 
      // act
      final result = await sut(ToggleCompletedParams(task: tTaskNotCompleted)); 
      // assert
      expect(result, Right(tTaskCompleted)); 
      verify(() => mockTodoTaskRepository.toggleCompleted(tTaskNotCompleted)); 
      verifyNoMoreInteractions(mockTodoTaskRepository); 
    },
  );
  test(
    "should set 'completed' to false if it was true"
    " using the repository",
    () async {
      // arrange
      when(() => mockTodoTaskRepository.toggleCompleted(tTaskCompleted))
        .thenAnswer((_) async => Right(tTaskNotCompleted)); 
      // act
      final result = await sut(ToggleCompletedParams(task: tTaskCompleted)); 
      // assert
      expect(result, Right(tTaskNotCompleted)); 
      verify(() => mockTodoTaskRepository.toggleCompleted(tTaskCompleted)); 
      verifyNoMoreInteractions(mockTodoTaskRepository); 
    },
  );
}
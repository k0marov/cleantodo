import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/todo_task_repository.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/delete_task.dart';
import 'package:todo_clean_architecture/features/task/domain/values/todo_task.dart';

class MockTodoTaskRepository extends Mock implements TodoTaskRepository {} 

void main() {
  late DeleteTask sut;
  late MockTodoTaskRepository mockRepository; 

  setUp(() {
    mockRepository = MockTodoTaskRepository();
    sut = DeleteTask(mockRepository);
  });

  final tTask = TodoTaskEntity(
    listId: "123", 
    id: "321", 
    createdAt: DateTime.now(), 
    value: TodoTask(
      text: "Test", 
      isCompleted: false, 
    )
  );
  test(
    "should delete task using repository",
    () async {
      // arrange
      when(() => mockRepository.deleteTask(tTask))
        .thenAnswer((_) async => Right(null)); 
      // act
      final result = await sut(DeleteTaskParams(taskEntity: tTask)); 
      // assert
      expect(result, Right(null)); 
      verify(() => mockRepository.deleteTask(tTask));
    },
  );
}

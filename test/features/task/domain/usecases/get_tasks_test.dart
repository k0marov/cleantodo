import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/todo_task_repository.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/get_tasks.dart';
import 'package:todo_clean_architecture/features/task/domain/values/todo_task.dart';

class MockTodoTaskRepository extends Mock 
  implements TodoTaskRepository {} 

void main() {
  late MockTodoTaskRepository mockTodoTaskRepository; 
  late GetTasks sut;

  setUp(() {
    mockTodoTaskRepository = MockTodoTaskRepository(); 
    sut = GetTasks(mockTodoTaskRepository);
  });

  const tTask = TodoTask(
    text: "Test",
    isCompleted: false, 
  );
  const tListId = "123"; 
  final tList = [
    TodoTaskEntity(listId: tListId, id: "1", createdAt: DateTime.utc(2001), value: tTask), 
    TodoTaskEntity(listId: tListId, id: "2", createdAt: DateTime.utc(2002), value: tTask), 
    TodoTaskEntity(listId: tListId, id: "3", createdAt: DateTime.utc(2003), value: tTask), 
  ]; 


  test(
    "should forward call to repository",
    () async {
      // arrange
      when(() => mockTodoTaskRepository.getTasks(tListId))
        .thenAnswer((_) async => Right(tList)); 
      // act
      final result = await sut(const GetTasksParams(taskListId: tListId)); 
      // assert
      expect(result, Right(tList)); 
      verify(() => mockTodoTaskRepository.getTasks(tListId)); 
    },
  );
}

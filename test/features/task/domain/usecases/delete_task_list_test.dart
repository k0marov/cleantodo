import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_clean_architecture/core/const/list_colors.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/task_list_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/task_list_repository.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/delete_task_list.dart';
import 'package:todo_clean_architecture/features/task/domain/values/task_list.dart';

class MockTaskListRepository extends Mock 
  implements TaskListRepository {} 

void main() {
  late DeleteTaskList sut; 
  late MockTaskListRepository mockTaskListRepository; 

  setUp(() {
    mockTaskListRepository = MockTaskListRepository(); 
    sut = DeleteTaskList(mockTaskListRepository); 
  }); 

  final tTaskList = TaskListEntity(
    id: "123", 
    createdAt: DateTime.utc(2022),
    value: const TaskList(
      title: "test", 
      color: ListColor.blue
    )
  ); 

  test(
    "should delete task list using repository",
    () async {
      // arrange
      when(() => mockTaskListRepository.deleteTaskList(tTaskList))
        .thenAnswer((_) async => const Right(null)); 
      // act
      final result = await sut(DeleteTaskListParams(taskList: tTaskList)); 
      // assert
      expect(result, const Right(null)); 
      verify(() => mockTaskListRepository.deleteTaskList(tTaskList)); 
      verifyNoMoreInteractions(mockTaskListRepository); 
    },
  );
}
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_clean_architecture/core/const/list_colors.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/task_list_repository.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/task_list_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/add_task_list.dart';
import 'package:todo_clean_architecture/features/task/domain/values/task_list.dart';

class MockTaskListRepository extends Mock 
  implements TaskListRepository {} 


void main() {
  late AddTaskList sut; 
  late MockTaskListRepository mockTaskListRepository; 

  setUp(() {
    mockTaskListRepository = MockTaskListRepository(); 
    sut = AddTaskList(mockTaskListRepository); 
  }); 

  const tTaskList = TaskList(
    color: ListColor.blue, 
    title: "Test 1"
  );

  test(
    "should add taskList using the repository"
    " and return new taskList Entity", 
    () async {
      // arrange
      final expectedResult = TaskListEntity(
        id: "id", 
        createdAt: DateTime.utc(2022),
        value: tTaskList
      ); 
      when(() => mockTaskListRepository.addTaskList(tTaskList))
        .thenAnswer((_) async => Right(expectedResult)); 
      // act
      final result = await sut(const AddTaskListParams(taskList: tTaskList)); 
      // assert
      expect(result, Right(expectedResult)); 
      verify(() => mockTaskListRepository.addTaskList(tTaskList)); 
      verifyNoMoreInteractions(mockTaskListRepository); 
    },
  );
}
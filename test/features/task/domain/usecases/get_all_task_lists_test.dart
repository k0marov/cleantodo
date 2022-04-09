import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_clean_architecture/core/const/list_colors.dart';
import 'package:todo_clean_architecture/core/usecases/usecase.dart';
import 'package:todo_clean_architecture/features/task/domain/repositories/task_list_repository.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/get_all_task_lists.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/task_list_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/values/task_list.dart'; 

class MockTaskListRepository extends Mock 
  implements TaskListRepository {} 


void main() {
  late GetAllTaskLists sut; 
  late MockTaskListRepository mockTaskListRepository; 

  setUp(() {
    mockTaskListRepository = MockTaskListRepository(); 
    sut = GetAllTaskLists(mockTaskListRepository); 
  }); 

  const tTaskListValue = TaskList(
    color: ListColor.blue, 
    title: "Some Task" 
  ); 

  final tTaskLists = [
    TaskListEntity(
      id: "test1", 
      createdAt: DateTime.utc(2001),
      value: tTaskListValue
    ), 
    TaskListEntity(
      id: "test2", 
      createdAt: DateTime.utc(2002),
      value: tTaskListValue
    ), 
  ]; 

  test(
    "should get all task lists from the repository",
    () async {
      // arrange
      when(() => mockTaskListRepository.getAllTaskLists())
        .thenAnswer((_) async => Right(tTaskLists)); 
      // act
      final result = await sut(NoParams()); 
      // assert
      expect(result, Right(tTaskLists)); 
      verify(() => mockTaskListRepository.getAllTaskLists()); 
      verifyNoMoreInteractions(mockTaskListRepository); 
    },
  );
}
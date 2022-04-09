
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_clean_architecture/core/const/list_colors.dart';
import 'package:todo_clean_architecture/core/error/failures.dart';
import 'package:todo_clean_architecture/core/usecases/usecase.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/task_list_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/add_task_list.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/delete_task_list.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/get_all_task_lists.dart';
import 'package:todo_clean_architecture/features/task/domain/values/task_list.dart';
import 'package:todo_clean_architecture/features/task/presentation/task_lists_bloc/task_lists_bloc.dart';

class MockAddTaskList extends Mock 
  implements AddTaskList {}
class MockGetAllTaskLists extends Mock 
  implements GetAllTaskLists {} 
class MockDeleteTaskList extends Mock 
  implements DeleteTaskList {} 

void main() {
  late TaskListsBloc sut;
  late MockAddTaskList mockAddTaskList; 
  late MockGetAllTaskLists mockGetAllTaskLists; 
  late MockDeleteTaskList mockDeleteTaskList; 

  const tTaskList = TaskList(
    color: ListColor.blue, 
    title: "Test"
  ); 

  setUp(() {
    mockAddTaskList = MockAddTaskList(); 
    mockGetAllTaskLists = MockGetAllTaskLists(); 
    mockDeleteTaskList = MockDeleteTaskList(); 
    sut = TaskListsBloc(
      deps: TaskListsBlocDependencies(
        addTaskList: mockAddTaskList, 
        getAllTaskLists: mockGetAllTaskLists, 
        deleteTaskList: mockDeleteTaskList, 
      ) 
    );

    registerFallbackValue(const AddTaskListParams(taskList: tTaskList)); 
  });

  test(
    "should have initialState = Empty",
    () async {
      // assert
      expect(sut.state, TaskListsEmpty()); 
    },
  );

  final tList = [
    TaskListEntity(id: "1", createdAt: DateTime.utc(2001), value: tTaskList),
    TaskListEntity(id: "2", createdAt: DateTime.utc(2002), value: tTaskList),
    TaskListEntity(id: "3", createdAt: DateTime.utc(2003), value: tTaskList),
  ]; 

  final tTaskListEntity = TaskListEntity(
    id: "123", 
    createdAt: DateTime.utc(2022),
    value: tTaskList, 
  ); 

  group('AddingTaskList', () {
    test(
      "should set state to Adding with current list if state was Loaded",
      () async {
        // arrange
        sut.emit(TaskListsLoaded(taskLists: tList)); 
        // assert later 
        expectLater(sut.stream, emitsInOrder([TaskListsAdding(currentTaskLists: tList)])); 
        // act 
        sut.add(AddingTaskListEvent()); 
      },
    );
    test(
      "should set state to Error if state was not Loaded",
      () async {
        // assert later
        expectLater(sut.stream, emitsInOrder([const TaskListsError(message: addingListFailureMessage)])); 
        // act
        sut.add(AddingTaskListEvent());
      },
    );
  }); 

  group('StopAdding', () {
    test(
      "should set state to Loaded if it was Adding",
      () async {
        // arrange
        sut.emit(TaskListsAdding(currentTaskLists: tList)); 
        // assert later 
        expectLater(sut.stream, emitsInOrder([
          TaskListsLoaded(taskLists: tList)
        ])); 
        // act
        sut.add(StopAddingListEvent());
      },
    );
    test(
      "should set state to Error if it was not Adding",
      () async {
        // assert later
        expectLater(sut.stream, emitsInOrder([
          const TaskListsError(message: stoppingDeletingFailureMessage)
        ])); 
        // act 
        sut.add(StopAddingListEvent());
      },
    );
  }); 

  group('GetAllTaskLists', () {
    test(
      "should get data from the GetAllTaskLists use case",
      () async {
        // arrange
        when(() => mockGetAllTaskLists(NoParams()))
          .thenAnswer((_) async => Right(tList)); 
        // act
        sut.add(GetAllTaskListsEvent()); 
        await untilCalled(() => mockGetAllTaskLists(NoParams())); 
        // assert
        verify(() => mockGetAllTaskLists(NoParams())); 
      },
    );
    test(
      "should have Loading state while the data is fetched",
      () async {
        // arrange
        when(() => mockGetAllTaskLists(NoParams()))
          .thenAnswer((_) => Future.delayed(
            const Duration(seconds: 3), 
            () => Right(tList)
          )); 
        // assert later
        final expected = [
          const TaskListsLoading(), 
        ]; 
        expectLater(sut.stream, emitsInOrder(expected)); 
        // act
        sut.add(GetAllTaskListsEvent()); 
      },
    );
    test(
      "should emit Loaded state with proper parameters"
      " when data is gotten successfully", 
      () async {
        // arrange
        when(() => mockGetAllTaskLists(NoParams()))
          .thenAnswer((_) async =>  Right(tList)); 
        // assert later 
        final expected = [
          const TaskListsLoading(), 
          TaskListsLoaded(taskLists: tList)
        ]; 
        expectLater(sut.stream, emitsInOrder(expected)); 
        // act
        sut.add(GetAllTaskListsEvent()); 
      },
    );
    test(
      "should emit Error state when data fetching failed",
      () async {
        // arrange
        when(() => mockGetAllTaskLists(NoParams()))
          .thenAnswer((_) async => Left(DataFailure())); 
        // assert later 
        final expected = [
          const TaskListsLoading(), 
          const TaskListsError(message: dataFailureMessage), 
        ]; 
        expectLater(sut.stream, emitsInOrder(expected)); 
        // act
        sut.add(GetAllTaskListsEvent()); 
      },
    );
  }); 

  group('AddTaskList', () {

    void arrangeMock() {
      when(() => mockAddTaskList(const AddTaskListParams(taskList: tTaskList)))
        .thenAnswer((_) async => Right(tTaskListEntity)); 
    }
    test(
      "should emit Error and not call usecase if was called when state is not Loaded",
      () async {
        // assert later 
        final expected = [
          const TaskListsError(message: addingListFailureMessage)
        ]; 
        expectLater(sut.stream, emitsInOrder(expected))
          .then((_) {
            verifyNever(() => mockAddTaskList(any())); 
          }); 
        // act 
        sut.add(const AddTaskListEvent("", ListColor.blue)); 
      },
    );
    test(
      "should emit [Loading, Loaded (with proper params)] if was called with state Loading"
      " and data fetching (strictly from usecase) was successful"
      " + shoudln't call get all lists usecase (for performance)", 
      () async {
        // arrange
        arrangeMock(); 
        sut.emit(TaskListsLoaded(taskLists: tList)); 
        // assert later 
        final expectedList = tList + [tTaskListEntity]; 
        expectedList.sort(); 
        final expectedStates = [
          TaskListsLoadingWithData(currentTaskLists: tList), 
          TaskListsLoaded(taskLists: expectedList)
        ]; 
        expectLater(sut.stream, emitsInOrder(expectedStates))
          .then((_) {
            verify(() => mockAddTaskList(const AddTaskListParams(taskList: tTaskList)));
            verifyZeroInteractions(mockGetAllTaskLists); 
          }); 
        // act
        sut.add(AddTaskListEvent(tTaskList.title, tTaskList.color)); 
      },
    );

    test(
      "should emit [Loading, Error] state when data fetching (adding) failed",
      () async {
        // arrange
        when(() => mockAddTaskList(const AddTaskListParams(taskList: tTaskList)))
          .thenAnswer((_) async => Left(DataFailure())); 
        sut.emit(TaskListsLoaded(taskLists: tList)); 
        // assert later 
        final expectedStates = [
          TaskListsLoadingWithData(currentTaskLists: tList), 
          const TaskListsError(message: dataFailureMessage), 
        ]; 
        expectLater(sut.stream, emitsInOrder(expectedStates)); 
        // act
        sut.add(AddTaskListEvent(tTaskList.title, tTaskList.color)); 
      },
    );
  });

  group('DeleteTaskList', () {
    void arrangeMock() {
      when(() => mockDeleteTaskList(DeleteTaskListParams(taskList: tTaskListEntity))) 
        .thenAnswer((_) async => const Right(null)); 
    }

    test(
      "should emit Error and not call usecase when state was not Loaded",
      () async {
        // assert later 
        final expectedStates = [
          const TaskListsError(message: deletingListFailureMessage) 
        ]; 
        expectLater(sut.stream, emitsInOrder(expectedStates))
          .then((_) {
            verifyZeroInteractions(mockAddTaskList); 
          }); 
        // act 
        sut.add(DeleteTaskListEvent(tTaskListEntity)); 
      },
    );

    test(
      "should emit [Loading, Loaded (with proper params)] if state was Loaded"
      " and data fetching (from usecase) was successful"
      " + shoudln't call get all lists usecase (for performance)", 
      () async {
        // arrange
        arrangeMock(); 
        sut.emit(TaskListsLoaded(taskLists: tList)); 
        // assert later 
        final expectedList = tList.where((elem) => elem != tTaskListEntity).toList(); 
        final expectedStates = [
          TaskListsLoadingWithData(currentTaskLists: tList), 
          TaskListsLoaded(taskLists: expectedList), 
        ];
        expectLater(sut.stream, emitsInOrder(expectedStates)) 
          .then((_) {
            verify(() => mockDeleteTaskList(DeleteTaskListParams(taskList: tTaskListEntity)));
            verifyZeroInteractions(mockGetAllTaskLists); 
          }); 
        // act
        sut.add(DeleteTaskListEvent(tTaskListEntity)); 
      },
    );

    test(
      "should emit Error if data fetching failed",
      () async {
        // arrange
        when(() => mockDeleteTaskList(DeleteTaskListParams(taskList: tTaskListEntity)))
          .thenAnswer((invocation) async => Left(DataFailure())); 
        sut.emit(TaskListsLoaded(taskLists: tList)); 
        // assert later 
        final expectedStates =[
          TaskListsLoadingWithData(currentTaskLists: tList),
          const TaskListsError(message: dataFailureMessage)
        ]; 
        expectLater(sut.stream, emitsInOrder(expectedStates)); 
        // act 
        sut.add(DeleteTaskListEvent(tTaskListEntity)); 
      },
    );
  }); 

}

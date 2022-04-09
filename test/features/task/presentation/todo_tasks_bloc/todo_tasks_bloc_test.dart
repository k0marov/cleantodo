import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_clean_architecture/core/const/list_colors.dart';
import 'package:todo_clean_architecture/core/error/failures.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/task_list_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/add_task.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/delete_task.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/get_tasks.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/toggle_completed.dart';
import 'package:todo_clean_architecture/features/task/domain/values/task_list.dart';
import 'package:todo_clean_architecture/features/task/domain/values/todo_task.dart';
import 'package:todo_clean_architecture/features/task/presentation/todo_tasks_bloc/todo_tasks_bloc.dart';


class MockGetTasks extends Mock
  implements GetTasks {} 
class MockAddTask extends Mock 
  implements AddTask {} 
class MockToggleCompleted extends Mock 
  implements ToggleCompleted {} 
class MockDeleteTask extends Mock 
  implements DeleteTask {} 

void main() {
  late TodoTasksBloc sut;
  late MockDeleteTask mockDeleteTask; 
  late MockGetTasks mockGetTasks; 
  late MockAddTask mockAddTask; 
  late MockToggleCompleted mockToggleCompleted; 

  const tListId = "123"; 
  final tTaskListEntity = TaskListEntity(
    id: tListId, 
    createdAt: DateTime.utc(2022),
    value: const TaskList(
      title: "Test", 
      color: ListColor.blue
    )
  ); 
  setUp(() {
    mockGetTasks = MockGetTasks(); 
    mockAddTask = MockAddTask(); 
    mockDeleteTask = MockDeleteTask(); 
    mockToggleCompleted = MockToggleCompleted(); 
    sut = TodoTasksBloc(
      taskList: tTaskListEntity,
      deps: TodoTasksBlocDependencies(
        getTasks: mockGetTasks, 
        addTask: mockAddTask, 
        toggleCompleted: mockToggleCompleted, 
        deleteTask: mockDeleteTask
      )
    );
  });

  test(
    "should have Empty as initial state",
    () async {
      // assert 
      expect(sut.state, TodoTasksEmpty()); 
    },
  );

  const tTask = TodoTask(
    text: "Test", 
    isCompleted: false, 
  ); 
  final tTasks = [
    TodoTaskEntity(listId: tListId, id: "1", createdAt: DateTime.utc(2001), value: tTask), 
    TodoTaskEntity(listId: tListId, id: "2", createdAt: DateTime.utc(2002), value: tTask), 
    TodoTaskEntity(listId: tListId, id: "3", createdAt: DateTime.utc(2003), value: tTask), 
  ]; 
  const tNewTask = TodoTask(
    text: "Test New Task", 
    isCompleted: false, 
  ); 
  final tNewEntity = TodoTaskEntity(
    listId: tListId, 
    id: "4", 
    createdAt: DateTime.utc(2004),
    value: tNewTask
  ); 

  
  group('DeleteTask', () {
    final tToDelete = tTasks[0]; 
    test(
      "should emit error if called when state is not Loaded ",
      () async {
        // assert later 
        expectLater(sut.stream, emitsInOrder([TodoTasksError(message: deletingTaskFailureMessage)])); 
        // act 
        sut.add(DeleteTaskEvent(tToDelete));
      },
    );
    test(
      "should emit [Loading, Loaded] if state was Loaded and call was successful"
      " + shouldn't call other usecases (for performance)", 
      () async {
        // arrange
        when(() => mockDeleteTask(DeleteTaskParams(taskEntity: tToDelete)))
          .thenAnswer((_) async => Right(null)); 
        sut.emit(TodoTasksLoaded(tasks: tTasks)); 
        // assert later 
        expectLater(sut.stream, emitsInOrder([
          TodoTasksLoadingWithData(currentTasks: tTasks), 
          TodoTasksLoaded(tasks: tTasks.where((task) => task != tToDelete).toList()) 
        ])).then((_) {
          verifyZeroInteractions(mockGetTasks); 
        }); 
        // act
        sut.add(DeleteTaskEvent(tToDelete)); 
      },
    );

    test(
      "should emit [Loading, Error] if call to usecase was not successful",
      () async {
        // arrange
        when(() => mockDeleteTask(DeleteTaskParams(taskEntity: tToDelete)))
          .thenAnswer((_) async => Left(DataFailure())); 
        sut.emit(TodoTasksLoaded(tasks: tTasks)); 
        // assert later
        expectLater(sut.stream, emitsInOrder([
          TodoTasksLoadingWithData(currentTasks: tTasks), 
          TodoTasksError(message: dataFailureMessage), 
        ])); 
        // act
        sut.add(DeleteTaskEvent(tToDelete));
      },
    );
  }); 
  group('TodoTasksAdding', () {
    test(
      "should set state to Adding if it was Loaded",
      () async {
        // arrange
        sut.emit(TodoTasksLoaded(tasks: tTasks)); 
        // assert later 
        expectLater(sut.stream, emitsInOrder([TodoTasksAdding(currentTasks: tTasks)])); 
        // act
        sut.add(AddingTaskEvent()); 
      },
    );
    test(
      "should set state to Error if it was not Loaded",
      () async {
        // assert later 
        expectLater(sut.stream, emitsInOrder([const TodoTasksError(message: addingTaskFailureMessage)])); 
        // act
        sut.add(AddingTaskEvent()); 
      },
    );
  }); 

  group('StopAdding', () {
    test(
      "should set state to Loaded if it was Adding",
      () async {
        // arrange
        sut.emit(TodoTasksAdding(currentTasks: tTasks)); 
        // assert later 
        expectLater(sut.stream, emitsInOrder([TodoTasksLoaded(tasks: tTasks)])); 
        // act
        sut.add(StopAddingTaskEvent()); 
      },
    );
    test(
      "should set state to Error if it was not Adding",
      () async {
        // assert later 
        expectLater(sut.stream, emitsInOrder([const TodoTasksError(message: addingTaskFailureMessage)])); 
        // act
        sut.add(StopAddingTaskEvent()); 
      },
    );
  }); 

  group('getTasks', () {
    test(
      "should call getTasks use case",
      () async {
        // arrange
        when(() => mockGetTasks(const GetTasksParams(taskListId: tListId)))
          .thenAnswer((_) async => Right(tTasks)); 
        // act
        sut.add(GetTasksEvent()); 
        // assert
        await untilCalled(() => mockGetTasks(const GetTasksParams(taskListId: tListId))); 
        verify(() => mockGetTasks(const GetTasksParams(taskListId: tListId))); 
      },
    );
    test(
      "should emit [Loading, Loaded (with proper params) if call to usecase was successful",
      () async {
        // arrange
        when(() => mockGetTasks(const GetTasksParams(taskListId: tListId)))
          .thenAnswer((_) async => Right(tTasks)); 
        // assert later 
        final expectedStates = [
          const TodoTasksLoading(), 
          TodoTasksLoaded(tasks: tTasks), 
        ]; 
        expectLater(sut.stream, emitsInOrder(expectedStates)); 
        // act 
        sut.add(GetTasksEvent()); 
      },
    );
    test(
      "should emit [Loading, Error] if call to usecase was unsuccessful",
      () async {
        // arrange
        when(() => mockGetTasks(const GetTasksParams(taskListId: tListId)))
          .thenAnswer((_) async => Left(DataFailure())); 
        // assert later 
        final expectedStates = [
          const TodoTasksLoading(), 
          const TodoTasksError(message: dataFailureMessage), 
        ]; 
        expectLater(sut.stream, emitsInOrder(expectedStates)); 
        // act 
        sut.add(GetTasksEvent()); 
      },
    );
  });
  group('addTask', () {
    void arrangeMock() => 
      when(() => mockAddTask(const AddTaskParams(taskListId: tListId, newTask: tNewTask)))
        .thenAnswer((_) async => Right(tNewEntity));
    test(
      "should emit Error if called when state is not Loaded",
      () async {
        // assert later 
        final expectedStates = [
          const TodoTasksError(message: addingTaskFailureMessage)
        ];
        expectLater(sut.stream, emitsInOrder(expectedStates)); 
        // act
        sut.add(const AddTaskEvent("Test New Task")); 
      },
    );
    test(
      "should emit [Loading, Loaded (with proper params) if state was Loaded"
      " and data fetching was successful (should call use case)"
      " + shouldn't call get tasks use case (for performance)", 
      () async {
        // arrange
        arrangeMock(); 
        sut.emit(TodoTasksLoaded(tasks: tTasks)); 
        // assert later 
        final expectedList = (tTasks + [tNewEntity])..sort(); 
        final expectedStates = [
          TodoTasksLoadingWithData(currentTasks: tTasks), 
          TodoTasksLoaded(tasks: expectedList), 
        ]; 
        expectLater(sut.stream, emitsInOrder(expectedStates))
          .then((_) {
            verify(() => mockAddTask(const AddTaskParams(newTask: tNewTask, taskListId: tListId))); 
            verifyZeroInteractions(mockGetTasks); 
          }); 
        // act
        sut.add(const AddTaskEvent("Test New Task")); 
      },
    );

    test(
      "should emit [Loading, Error] if state was Loaded"
      " but usecase call failed", 
      () async {
        // arrange
        when(() => mockAddTask(const AddTaskParams(newTask: tNewTask, taskListId: tListId)))
          .thenAnswer((_) async => Left(DataFailure())); 
        sut.emit(TodoTasksLoaded(tasks: tTasks)); 
        // assert later 
        final expectedStates = [
          TodoTasksLoadingWithData(currentTasks: tTasks), 
          const TodoTasksError(message: dataFailureMessage)
        ]; 
        expectLater(sut.stream, emitsInOrder(expectedStates)); 
        // act
        sut.add(const AddTaskEvent("Test New Task")); 
      },
    );
  }); 

  group('toggleCompleted', () {
    final tTaskEntity = tTasks[0]; 
    final tToggled = TodoTaskEntity(
      listId: tTaskEntity.listId, 
      id: tTaskEntity.id, 
      createdAt: DateTime.utc(2022),
      value: TodoTask(
        text: tTaskEntity.value.text, 
        isCompleted: !tTaskEntity.value.isCompleted, 
      )
    ); 
    test(
      "should emit Error if state was not Loaded",
      () async {
        // assert later
        expectLater(sut.stream, emitsInOrder([const TodoTasksError(message: togglingTaskFailureMessage)])); 
        // act
        sut.add(ToggleCompletedEvent(tTaskEntity)); 
      },
    );

    test(
      "should emit [Loading, Loaded (with proper params)] if state was Loaded,"
      " and data fetching was successful (should call the usecase!)"
      " + shouldn't call getTasks usecase (for performance)", 
      () async {
        // arrange
        when(() => mockToggleCompleted(ToggleCompletedParams(task: tTaskEntity)))
          .thenAnswer((_) async => Right(tToggled)); 
        sut.emit(TodoTasksLoaded(tasks: tTasks)); 
        // assert later
        final expectedList = tTasks.map((elem) => elem == tTaskEntity ? tToggled : elem).toList(); 
        final expectedStates = [
          TodoTasksLoadingWithData(currentTasks: tTasks), 
          TodoTasksLoaded(tasks: expectedList)
        ]; 
        expectLater(sut.stream, emitsInOrder(expectedStates))
          .then((_) {
            verify(() => mockToggleCompleted(ToggleCompletedParams(task: tTaskEntity))); 
            verifyZeroInteractions(mockGetTasks); 
          }); 
        // act
        sut.add(ToggleCompletedEvent(tTaskEntity)); 
      },
    );

    test(
      "should emit [Loading, Error] if state was Loaded"
      " but data fetching failed", 
      () async {
        // arrange
        when(() => mockToggleCompleted(ToggleCompletedParams(task: tTaskEntity)))
          .thenAnswer((_) async => Left(DataFailure())); 
        sut.emit(TodoTasksLoaded(tasks: tTasks)); 
        // assert later 
        final expectedStates = [
          TodoTasksLoadingWithData(currentTasks: tTasks), 
          const TodoTasksError(message: dataFailureMessage), 
        ]; 
        expectLater(sut.stream, emitsInOrder(expectedStates)); 
        // act
        sut.add(ToggleCompletedEvent(tTaskEntity)); 
      },
    );
  }); 
}

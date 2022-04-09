
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/task_list_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/add_task.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/get_tasks.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/toggle_completed.dart';
import 'package:todo_clean_architecture/features/task/domain/values/todo_task.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/delete_task.dart';

part 'todo_tasks_event.dart';
part 'todo_tasks_state.dart';

class TodoTasksBlocDependencies {
  final GetTasks getTasks; 
  final AddTask addTask; 
  final ToggleCompleted toggleCompleted;
  final DeleteTask deleteTask; 

  TodoTasksBlocDependencies({
    required this.getTasks, 
    required this.addTask, 
    required this.toggleCompleted, 
    required this.deleteTask, 
  }); 
}

class TodoTasksBloc extends Bloc<TodoTasksEvent, TodoTasksState> {
  final TaskListEntity taskList; 
  final GetTasks _getTasks; 
  final AddTask _addTask; 
  final DeleteTask _deleteTask; 
  final ToggleCompleted _toggleCompleted; 

  TodoTasksBloc({
    required this.taskList, 
    required TodoTasksBlocDependencies deps, 
  }) : _getTasks = deps.getTasks, 
       _addTask = deps.addTask, 
       _toggleCompleted = deps.toggleCompleted, 
       _deleteTask = deps.deleteTask, 
  super(TodoTasksEmpty()) {
    on<TodoTasksEvent>((event, emit) async {
      final List<TodoTaskEntity>? currentTasks = 
        state is TodoTasksWithData ? 
          (state as TodoTasksWithData).tasks 
        : null; 

      if (event is GetTasksEvent) {
        emit(const TodoTasksLoading()); 
        final tasks = await _getTasks(GetTasksParams(taskListId: taskList.id)); 
        tasks.fold(
          (failure) => emit(const TodoTasksError(message: dataFailureMessage)), 
          (tasks) => emit(TodoTasksLoaded(tasks: tasks))
        );
      } else if (event is AddTaskEvent) {
        if (currentTasks != null) {
          final newTask = TodoTask(text: event.text, isCompleted: false); 
          emit(TodoTasksLoadingWithData(currentTasks: currentTasks)); 
          final resultEither = await _addTask(AddTaskParams(
            newTask: newTask, 
            taskListId: taskList.id
          )); 
          resultEither.fold(
            (failure) => emit(const TodoTasksError(message: dataFailureMessage)), 
            (newTaskEntity) => emit(TodoTasksLoaded(tasks: (currentTasks + [newTaskEntity])..sort()))
          ); 
        } else {
          emit(const TodoTasksError(message: addingTaskFailureMessage));
        }
      } else if (event is ToggleCompletedEvent) {
        if (currentTasks != null) {
          emit(TodoTasksLoadingWithData(currentTasks: currentTasks)); 
          final resultEither = await _toggleCompleted(ToggleCompletedParams(task: event.taskToToggle)); 
          resultEither.fold(
            (failure) => emit(const TodoTasksError(message: dataFailureMessage)), 
            (changedEntity) => emit(TodoTasksLoaded(tasks: currentTasks
              .map((task) => task == event.taskToToggle ? changedEntity : task)
              .toList() 
            )) 
          ); 
        } else {
          emit(const TodoTasksError(message: togglingTaskFailureMessage));
        }
      } else if (event is AddingTaskEvent) {
        if (currentTasks != null) {
          emit(TodoTasksAdding(currentTasks: currentTasks)); 
        } else {
          emit(const TodoTasksError(message: addingTaskFailureMessage)); 
        }
      } else if (event is StopAddingTaskEvent) {
        if (currentTasks != null) {
          emit(TodoTasksLoaded(tasks: currentTasks)); 
        } else {
          emit(const TodoTasksError(message: addingTaskFailureMessage)); 
        }
      } else if (event is DeleteTaskEvent) {
        if (currentTasks != null) {
          emit(TodoTasksLoadingWithData(currentTasks: currentTasks)); 
          final result = await _deleteTask(DeleteTaskParams(taskEntity: event.task)); 
          result.fold(
            (failure) => emit(const TodoTasksError(message: dataFailureMessage)), 
            (success) => emit(TodoTasksLoaded(
              tasks: currentTasks.where((elem) => elem != event.task).toList()
            )) 
          ); 
        } else {
          emit(const TodoTasksError(message: deletingTaskFailureMessage)); 
        }
      }
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_clean_architecture/core/usecases/usecase.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/add_task_list.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/delete_task_list.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/get_all_task_lists.dart';
import 'package:todo_clean_architecture/features/task/domain/values/task_list.dart';

import '../../../../core/const/list_colors.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/task_list_entity.dart';

part 'task_lists_event.dart';
part 'task_lists_state.dart';

class TaskListsBlocDependencies {
  final GetAllTaskLists getAllTaskLists; 
  final DeleteTaskList deleteTaskList; 
  final AddTaskList addTaskList;

  TaskListsBlocDependencies({
    required this.getAllTaskLists, 
    required this.deleteTaskList, 
    required this.addTaskList, 
  }); 
}

class TaskListsBloc extends Bloc<TaskListsEvent, TaskListsState> {
  final GetAllTaskLists _getAllTaskLists; 
  final DeleteTaskList _deleteTaskList; 
  final AddTaskList _addTaskList; 

  TaskListsBloc({
    required TaskListsBlocDependencies deps
  }) : _getAllTaskLists = deps.getAllTaskLists, 
       _deleteTaskList = deps.deleteTaskList, 
      _addTaskList = deps.addTaskList, 
  super(TaskListsEmpty()) {
    on<TaskListsEvent>((event, emit) async {
      final currentState = state; 
      final currentTaskLists = 
        currentState is TaskListsWithData ? 
          currentState.taskLists 
        : null; 

      if (event is GetAllTaskListsEvent) {
        emit(const TaskListsLoading()); 
        final tTaskLists = await _getAllTaskLists(NoParams()); 
        tTaskLists.fold(
          (failure) => emit(const TaskListsError(message: dataFailureMessage)), 
          (taskLists) => emit(TaskListsLoaded(taskLists: taskLists)) 
        ); 
      } else if (event is AddTaskListEvent) {
        if (currentTaskLists != null) {
          emit(TaskListsLoadingWithData(currentTaskLists: currentTaskLists)); 
          final resultEither = await _addTaskList(AddTaskListParams(
            taskList: TaskList(
              title: event.title, 
              color: event.color, 
            )
          )); 
          resultEither.fold(
            (failure) => emit(const TaskListsError(message: dataFailureMessage)), 
            (newEntity) => emit(TaskListsLoaded(taskLists: (currentTaskLists + [newEntity])..sort()))
          ); 
        } else {
          emit(const TaskListsError(message: addingListFailureMessage)); 
        }
      } else if (event is DeleteTaskListEvent) {
        if (currentTaskLists != null) {
          emit(TaskListsLoadingWithData(currentTaskLists: currentTaskLists)); 
          final result = await _deleteTaskList(DeleteTaskListParams(taskList: event.taskListEntity)); 
          result.fold(
            (failure) => emit(const TaskListsError(message: dataFailureMessage)),
            (success) {
              final newList = currentTaskLists.where((elem) => elem != event.taskListEntity).toList(); 
              emit(TaskListsLoaded(taskLists: newList)); 
            }
          ); 
        } else {
          emit(const TaskListsError(message: deletingListFailureMessage)); 
        }
      } else if (event is AddingTaskListEvent) {
        if (currentTaskLists != null) {
          emit(TaskListsAdding(currentTaskLists: currentTaskLists)); 
        } else {
          emit(const TaskListsError(message: addingListFailureMessage)); 
        }
      } else if (event is StopAddingListEvent) {
        if (currentTaskLists != null) {
          emit(TaskListsLoaded(taskLists: currentTaskLists)); 
        } else {
          emit(const TaskListsError(message: stoppingDeletingFailureMessage)); 
        }
      }
    });
  }
}


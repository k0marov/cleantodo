part of 'task_lists_bloc.dart';

abstract class TaskListsState extends Equatable {
  const TaskListsState();
  
  @override
  List<Object> get props => [];
}

class TaskListsEmpty extends TaskListsState {} 

abstract class TaskListsWithData extends TaskListsState {
  final List<TaskListEntity> taskLists; 
  @override 
  List<Object> get props => [taskLists]; 

  const TaskListsWithData(this.taskLists);
}

class TaskListsLoading extends TaskListsState {
  const TaskListsLoading(); 
} 

class TaskListsLoadingWithData extends TaskListsLoading implements TaskListsWithData {
  final List<TaskListEntity> currentTaskLists; 
  @override 
  List<Object> get props => [currentTaskLists]; 
  @override 
  List<TaskListEntity> get taskLists => currentTaskLists; 

  const TaskListsLoadingWithData({
    required this.currentTaskLists
  }); 
}

class TaskListsAdding extends TaskListsWithData {
  const TaskListsAdding({
    required List<TaskListEntity> currentTaskLists
  }) : super(currentTaskLists); 
}

class TaskListsLoaded extends TaskListsWithData {
  const TaskListsLoaded({required List<TaskListEntity> taskLists})
    : super(taskLists); 
} 

class TaskListsError extends TaskListsState {
  final String message;
  @override 
  List<Object> get props => [message]; 

  const TaskListsError({required this.message}); 
}
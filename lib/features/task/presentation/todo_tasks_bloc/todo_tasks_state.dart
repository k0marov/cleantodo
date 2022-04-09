part of 'todo_tasks_bloc.dart';

abstract class TodoTasksState extends Equatable {
  const TodoTasksState();
  
  @override
  List<Object> get props => [];
}

class TodoTasksEmpty extends TodoTasksState {}

abstract class TodoTasksWithData extends TodoTasksState {
  final List<TodoTaskEntity> tasks; 
  @override 
  List<Object> get props => [tasks]; 
  
  const TodoTasksWithData(this.tasks); 
}

class TodoTasksLoading extends TodoTasksState {
  const TodoTasksLoading(); 
}

class TodoTasksLoadingWithData extends TodoTasksLoading implements TodoTasksWithData {
  final List<TodoTaskEntity> currentTasks; 
  @override 
  List<Object> get props => [currentTasks]; 
  @override 
  List<TodoTaskEntity> get tasks => currentTasks; 

  const TodoTasksLoadingWithData({
    required this.currentTasks
  }); 
}

class TodoTasksLoaded extends TodoTasksWithData {
  const TodoTasksLoaded({required List<TodoTaskEntity> tasks}) : super(tasks); 
}

class TodoTasksAdding extends TodoTasksWithData {
  const TodoTasksAdding({
    required List<TodoTaskEntity> currentTasks, 
  }) : super(currentTasks); 
}

class TodoTasksError extends TodoTasksState {
  final String message;

  const TodoTasksError({required this.message}); 
  @override 
  List<Object> get props => [message]; 
}
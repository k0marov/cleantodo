part of 'todo_tasks_bloc.dart';

abstract class TodoTasksEvent extends Equatable {
  const TodoTasksEvent();

  @override
  List<Object> get props => [];
}

class GetTasksEvent extends TodoTasksEvent {}

class AddTaskEvent extends TodoTasksEvent {
  final String text;
  @override 
  List<Object> get props => [text]; 

  const AddTaskEvent(this.text); 
}

class DeleteTaskEvent extends TodoTasksEvent {
  final TodoTaskEntity task; 
  @override 
  List<Object> get props => [task]; 

  const DeleteTaskEvent(this.task); 
}

class AddingTaskEvent extends TodoTasksEvent {}

class StopAddingTaskEvent extends TodoTasksEvent {} 

// class DeleteTaskEvent extends TodoTasksBlocEvent {
//   final TodoTaskEntity taskToDelete; 
//   @override 
//   List<Object> get props => [taskToDelete]; 

//   const DeleteTaskEvent(this.taskToDelete); 
// }

class ToggleCompletedEvent extends TodoTasksEvent {
  final TodoTaskEntity taskToToggle; 
  @override 
  List<Object> get props => [taskToToggle]; 

  const ToggleCompletedEvent(this.taskToToggle); 
}
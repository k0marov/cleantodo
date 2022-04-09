part of 'task_lists_bloc.dart';

abstract class TaskListsEvent extends Equatable {
  const TaskListsEvent();

  @override
  List<Object> get props => [];
}

class GetAllTaskListsEvent extends TaskListsEvent {}

class AddTaskListEvent extends TaskListsEvent {
  final String title; 
  final ListColor color;
  @override 
  List<Object> get props => [title, color]; 

  const AddTaskListEvent(this.title, this.color); 
}

class AddingTaskListEvent extends TaskListsEvent {}
class StopAddingListEvent extends TaskListsEvent {}

class DeleteTaskListEvent extends TaskListsEvent {
  final TaskListEntity taskListEntity;
  @override 
  List<Object> get props => [taskListEntity]; 

  const DeleteTaskListEvent(this.taskListEntity); 
}
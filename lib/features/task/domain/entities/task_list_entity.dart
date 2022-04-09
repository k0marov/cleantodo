import 'package:equatable/equatable.dart';
import 'package:todo_clean_architecture/features/task/domain/values/task_list.dart';

class TaskListEntity extends Equatable implements Comparable {
  final String id; 
  final DateTime createdAt; 
  final TaskList value; 

  @override 
  List get props => [id, createdAt, value]; 
  @override
  int compareTo(covariant TaskListEntity other) => - createdAt.compareTo(other.createdAt); 

  const TaskListEntity({
    required this.id, 
    required this.createdAt, 
    required this.value
  }); 
}
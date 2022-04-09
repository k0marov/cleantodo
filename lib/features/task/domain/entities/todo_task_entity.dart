import 'package:equatable/equatable.dart';
import 'package:todo_clean_architecture/features/task/domain/values/todo_task.dart';

class TodoTaskEntity extends Equatable implements Comparable {
  final String listId; 
  final String id; 
  final DateTime createdAt; 
  final TodoTask value; 

  @override 
  List get props => [listId, id, value]; 

  @override 
  int compareTo(covariant TodoTaskEntity other) => createdAt.compareTo(other.createdAt); 

  const TodoTaskEntity({
    required this.listId, 
    required this.id, 
    required this.createdAt, 
    required this.value 
  }); 
}
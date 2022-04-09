import 'package:equatable/equatable.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';

import '../../domain/values/todo_task.dart';


class TodoTaskModel extends Equatable {
  final TodoTaskEntity _entity; 
  const TodoTaskModel(
    this._entity
  ); 
  
  @override 
  List get props => [_entity]; 

  TodoTaskEntity toEntity() => _entity; 

  TodoTaskModel.fromJson(Map<String, dynamic> json) : 
    this(
      TodoTaskEntity(
        listId: json['listId'], 
        id: json['id'], 
        createdAt: DateTime.parse(json['createdAt']), 
        value: TodoTask(
          text: json['text'], 
          isCompleted: json['isCompleted'] 
        )
      )
    ); 

  Map<String, dynamic> toJson() => {
    'listId': _entity.listId, 
    'id': _entity.id, 
    'createdAt': _entity.createdAt.toIso8601String(), 
    'text': _entity.value.text, 
    'isCompleted': _entity.value.isCompleted 
  }; 
}
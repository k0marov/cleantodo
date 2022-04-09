
import 'package:equatable/equatable.dart';
import 'package:todo_clean_architecture/core/const/list_colors.dart';

import '../../domain/entities/task_list_entity.dart';
import '../../domain/values/task_list.dart';

class TaskListModel extends Equatable {
  final TaskListEntity _entity; 
  @override 
  List get props => [_entity]; 

  TaskListEntity toEntity() => _entity; 

  const TaskListModel(this._entity);  

  TaskListModel.fromJson(Map<String, dynamic> json) : this(
    TaskListEntity(
      id: json['id'], 
      createdAt: DateTime.parse(json['createdAt']),
      value: TaskList(
        title: json['title'], 
        color: listColorFromJson(json['color'])
      )
    )
  ); 

  Map<String, dynamic> toJson() => {
    "id": _entity.id, 
    "createdAt": _entity.createdAt.toIso8601String(), 
    "color": listColorToJson(_entity.value.color), 
    "title": _entity.value.title 
  }; 
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/task_list_entity.dart';
import '../../task_lists_bloc/task_lists_bloc.dart';
import 'adding_task_list_widget.dart';
import 'mini_todo_tasks_widget.dart';

class TaskListCarousel extends StatelessWidget {
  final List<TaskListEntity> taskLists; 
  const TaskListCarousel({
    required this.taskLists, 
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAddingState = context.read<TaskListsBloc>().state is TaskListsAdding; 
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      key: isAddingState ? Key(const Uuid().v1()) : null,  // to scroll to start when Adding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 50, 
          ), 
          if (context.read<TaskListsBloc>().state is TaskListsAdding) 
            const AddingTaskListWidget(),
          ...(taskLists
            .map((taskList) {
              return MiniTodoTaskWidget(taskList: taskList); 
            })
            .toList()
          )
        ]
      ),
    ); 
  }
}
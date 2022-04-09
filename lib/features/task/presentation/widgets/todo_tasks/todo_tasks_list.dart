import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_architecture/features/task/presentation/widgets/todo_tasks/todo_task_widget.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/todo_task_entity.dart';
import '../../todo_tasks_bloc/todo_tasks_bloc.dart';
import 'adding_task_widget.dart';

class TodoTasksList extends StatelessWidget {
  const TodoTasksList({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  final List<TodoTaskEntity> tasks;

  @override
  Widget build(BuildContext context) {
    final state = context.read<TodoTasksBloc>().state; 
    final isAdding = state is TodoTasksAdding; 
    final isLoading = state is TodoTasksLoading; 
    return ListView(
      key: isAdding ? Key(const Uuid().v1()) : null,  // to scroll to end if Adding 
      controller: isAdding ? ScrollController(initialScrollOffset: 1.0) : null,
      children: [
        ...(tasks.map((task) => 
            Opacity(
              opacity: isLoading ? 0 : 1,
              child: TodoTaskWidget(task: task)
            )
          )
        ), 
        if (context.read<TodoTasksBloc>().state is TodoTasksAdding) 
          const AddingTaskWidget() 
      ]
    );
  }
}


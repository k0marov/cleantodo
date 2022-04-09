import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/presentation/colors.dart';
import '../../task_lists_bloc/task_lists_bloc.dart';
import '../../todo_tasks_bloc/todo_tasks_bloc.dart';

class TodoTasksActionButtons extends StatelessWidget {
  const TodoTasksActionButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40), 
          child: ElevatedButton(
            child: const Text("Delete"), 
            style: ElevatedButton.styleFrom(
              primary: customRed
            ), 
            onPressed: () {
              final taskList = context.read<TodoTasksBloc>().taskList; 
              Navigator.of(context).pop(); 
              context.read<TaskListsBloc>().add(
                DeleteTaskListEvent(taskList)
              ); 
            }
          )
        ), 
        Padding(
          padding: const EdgeInsets.only(right: 40), 
          child: InkWell(
            onTap: () => context.read<TodoTasksBloc>().add(AddingTaskEvent()), 
            child: Container(
              height: 50, 
              width: 50, 
              decoration: BoxDecoration(
                color: customRed, 
                borderRadius: const BorderRadius.all(Radius.circular(5)), 
              ),
              child: Icon(Icons.add, color: customWhite)
            )
          )
        )
      ]
    );
  }
}

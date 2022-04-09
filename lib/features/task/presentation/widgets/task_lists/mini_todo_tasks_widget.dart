
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_clean_architecture/features/task/presentation/pages/todo_tasks_page.dart';
import 'package:todo_clean_architecture/features/task/presentation/task_lists_bloc/task_lists_bloc.dart';
import 'package:todo_clean_architecture/features/task/presentation/widgets/task_lists/task_list_layout.dart';
import 'package:todo_clean_architecture/features/task/presentation/widgets/task_lists/mini_task_widget.dart';

import '../../../../../core/presentation/colors.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/task_list_entity.dart';
import '../../todo_tasks_bloc/todo_tasks_bloc.dart';

class MiniTodoTaskWidget extends StatelessWidget {
  final TaskListEntity taskList;  
  const MiniTodoTaskWidget({
    required this.taskList, 
    Key? key
  }) : super(key: key); 
  @override 
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoTasksBloc(taskList: taskList, deps: sl())..add(GetTasksEvent()),
      key: Key(taskList.id), // otherwise the same bloc provider is inserted on the newly added Row children
      child: _MiniTodoTasksWidgetInternal(taskList: taskList) 
    ); 
  }
}

class _MiniTodoTasksWidgetInternal extends StatelessWidget {
  final TaskListEntity taskList; 
  const _MiniTodoTasksWidgetInternal({ 
    required this.taskList, 
    Key? key 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskList = context.read<TodoTasksBloc>().taskList; 
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => BlocProvider.value(
            value: context.read<TaskListsBloc>(), 
            child: TodoTasksPage(bloc: context.read<TodoTasksBloc>())
          )
        )); 
      }, 
      child: TaskListLayout(
        color: listColorToColor(taskList.value.color), 
        titleWidget: Text(taskList.value.title,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.roboto(
            fontSize: 22, 
            color: customWhite, 
            fontWeight: FontWeight.bold,
          )
        ),
        bodyWidget: BlocBuilder<TodoTasksBloc, TodoTasksState>(
          builder: (context, state) {
            final tasks = state is TodoTasksWithData ? 
              state.tasks 
            : null; 
            if (tasks != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: tasks.sublist(0, min(tasks.length, 5)).map((task) => 
                  TaskWidget(task: task)
                ).toList()
              ); 
            } else {
              return Container(); 
            }
          },
        ),
      )
    ); 
  
  }
}

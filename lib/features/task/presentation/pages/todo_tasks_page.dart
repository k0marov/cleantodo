import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/todo_task_entity.dart';
import 'package:todo_clean_architecture/features/task/presentation/widgets/todo_tasks/todo_tasks_title.dart';

import '../todo_tasks_bloc/todo_tasks_bloc.dart';
import '../widgets/todo_tasks/todo_tasks_action_buttons.dart';
import '../widgets/todo_tasks/todo_tasks_app_bar.dart';
import '../widgets/todo_tasks/todo_tasks_list.dart';

class TodoTasksPage extends StatelessWidget {
  final TodoTasksBloc bloc; 
  const TodoTasksPage({ 
    required this.bloc, 
    Key? key 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc, 
      child: Scaffold(
        body: BlocBuilder<TodoTasksBloc, TodoTasksState>(
          bloc: bloc, 
          builder: (context, state) {
            if (state is TodoTasksWithData) {
              return TodoTasksPageBody(
                tasks: state.tasks, 
              );
            } else if (state is TodoTasksError) {
              return Text(state.message); 
            } else {
              return Container(); 
            }
          }
        ), 
      ),
    ); 
  }
}

class TodoTasksPageBody extends StatelessWidget {
  final List<TodoTaskEntity> tasks; 
  const TodoTasksPageBody({
    required this.tasks, 
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nTasks = tasks.length; 
    final nCompleted = tasks.where((task) => task.value.isCompleted).length; 

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: 75), 
      const TodoTasksAppBar(), 
      const SizedBox(height: 100), 
      TodoTasksTitle(nCompleted: nCompleted, nTasks: nTasks), 
      const Padding(
        padding: EdgeInsets.only(left: 85, top: 20, bottom: 10), 
        child: Divider(thickness: 2.5,), 
      ), 
      Expanded(
        child: TodoTasksList(tasks: tasks),
      ), 
      const SizedBox(height: 25), 
      const TodoTasksActionButtons(), 
      const SizedBox(height: 20), 
    ]);
  }
}

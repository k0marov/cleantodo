
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_clean_architecture/features/task/presentation/task_lists_bloc/task_lists_bloc.dart';

import '../widgets/task_lists/add_list_widget.dart';
import '../widgets/shared/logo_widget.dart';
import '../widgets/task_lists/task_lists_carousel.dart';
import '../widgets/task_lists/title_widget.dart';

final sl = GetIt.instance; 

class TaskListsPage extends StatelessWidget {
  const TaskListsPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskListsBloc(
        deps: sl() 
      )..add(GetAllTaskListsEvent()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: const SizedBox(
          height: 100, 
        ),
        body: BlocBuilder<TaskListsBloc, TaskListsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, 
              mainAxisSize: MainAxisSize.max, 
              children: [
                const SizedBox(height: 75), 
                const Align(
                  alignment: Alignment.topLeft, 
                  child: Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: LogoWidget()
                  )
                ), 
                const SizedBox(height: 75), 
                const TitleWidget(), 
                const SizedBox(height: 50), 
                state is TaskListsWithData ? 
                  AddListWidget(
                    onPressed: () {
                      context.read<TaskListsBloc>().add(AddingTaskListEvent()); 
                    }
                  )
                : const Center(child: CircularProgressIndicator()), 
                const SizedBox(height: 50), 
                Expanded(
                  child: _buildCarousel(context, state)
                )
            ]); 
          },
        )
      )
    ); 
  }

  Widget _buildCarousel(BuildContext context, TaskListsState state) {
    if (state is TaskListsWithData) {
      return TaskListCarousel(taskLists: state.taskLists); 
    }
    if (state is TaskListsLoading) {
      return const CircularProgressIndicator(); 
    } else if (state is TaskListsError) {
      return Text(state.message); 
    } else {
      return Container(); 
    }
  }
}

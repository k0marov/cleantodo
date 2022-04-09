import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/presentation/colors.dart';
import '../../todo_tasks_bloc/todo_tasks_bloc.dart';

class TodoTasksTitle extends StatelessWidget {
  const TodoTasksTitle({
    Key? key,
    required this.nCompleted,
    required this.nTasks,
  }) : super(key: key);

  final int nCompleted;
  final int nTasks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(width: 5), 
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SizedBox(
            width: 20, 
            height: 20, 
            child: nCompleted == nTasks && nTasks > 0 ? 
              const Icon(
                Icons.done_outline, 
                color: Colors.green
              )
            : CircularProgressIndicator(
              backgroundColor: Colors.grey.shade300,
              color: palette['red'], 
              strokeWidth: 3,
              value: nTasks == 0 ? 0 : nCompleted/nTasks, 
            )
          ),
        ), 
        const SizedBox(width: 20), 
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              context.read<TodoTasksBloc>().taskList.value.title, 
              maxLines: null,
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(fontSize: 30)
              )
            ), 
            const SizedBox(height: 8), 
            Text("$nCompleted of $nTasks tasks", style: GoogleFonts.roboto(textStyle: TextStyle(fontSize:15, color: palette['grey']))), 
          ]),
        ), 
      ]),
    );
  }
}

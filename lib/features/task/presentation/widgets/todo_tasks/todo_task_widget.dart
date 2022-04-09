import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_clean_architecture/features/task/domain/usecases/delete_task.dart';
import 'package:todo_clean_architecture/features/task/presentation/task_lists_bloc/task_lists_bloc.dart';

import '../../../../../core/presentation/colors.dart';
import '../../../domain/entities/todo_task_entity.dart';
import '../../todo_tasks_bloc/todo_tasks_bloc.dart';

class TodoTaskWidget extends StatelessWidget {
  final TodoTaskEntity task; 
  const TodoTaskWidget({
    required this.task, 
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(), 
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => context.read<TodoTasksBloc>().add(DeleteTaskEvent(task)), 
      background: Container(
        color: Colors.red, 
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => context.read<TodoTasksBloc>().add(ToggleCompletedEvent(task)),
        child: task.value.isCompleted ? 
          Container(
            padding: const EdgeInsets.only(left: 40, top: 16, bottom: 13, right: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.grey.shade200, Theme.of(context).canvasColor]), 
            ),
            child: Text(
              "\u{00A0}"*10 + task.value.text,  // non-breaking space 
              maxLines: 5,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(textStyle: TextStyle(
                fontSize: 18, 
                color: palette['red'], 
                decoration: TextDecoration.lineThrough
              ))
            ),
          )
        : Padding(
          padding: const EdgeInsets.only(left: 40, top: 10, bottom: 10, right: 10),
          child: Row(
            children: [
              SizedBox(
                width: 30, 
                height: 30, 
                child: Container(
                  margin: const EdgeInsets.all(8), 
                  decoration: BoxDecoration(
                    border: Border.all(color: palette['grey']!),
                    borderRadius: const BorderRadius.all(Radius.circular(3)), 
                  ),
                ),
              ), 
              const SizedBox(width: 15), 
              Expanded(
                child: Text(
                  task.value.text, 
                  softWrap: true,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(textStyle: const TextStyle(fontSize: 18))
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
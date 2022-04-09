import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/presentation/colors.dart';
import '../../../domain/entities/todo_task_entity.dart';

class TaskWidget extends StatelessWidget {
  final TodoTaskEntity task; 
  const TaskWidget({ 
    required this.task, 
    Key? key 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return task.value.isCompleted ? 
      SizedBox(
        height: 32, 
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\u{00A0}"*7+task.value.text,  // non-breaking space 
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: customGrey, 
                    decoration: TextDecoration.lineThrough, 
                  )
                )
              ),
            ],
          ),
        )
      )
    : Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        children: [
          SizedBox(
            width: 32, 
            height: 32, 
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: customGrey),
                  borderRadius: const BorderRadius.all(Radius.circular(3)), 
                ),
              ),
            ),
          ), 
          Expanded(
            child: Text(
              task.value.text, 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: customWhite), 
            ),
          ),
        ],
      ),
    ); 
  }
}
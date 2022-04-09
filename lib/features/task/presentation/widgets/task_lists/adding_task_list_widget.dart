import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_clean_architecture/features/task/presentation/widgets/task_lists/task_list_layout.dart';

import '../../../../../core/const/list_colors.dart';
import '../../../../../core/presentation/colors.dart';
import '../../task_lists_bloc/task_lists_bloc.dart';
class AddingTaskListWidget extends StatefulWidget {
  const AddingTaskListWidget({ Key? key }) : super(key: key);

  @override
  _AddingTaskListWidgetState createState() => _AddingTaskListWidgetState();
}

class _AddingTaskListWidgetState extends State<AddingTaskListWidget> {
  final _controller = TextEditingController(); 
  ListColor currentColor = ListColor.values[Random().nextInt(ListColor.values.length)]; 

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    const textBorder = InputBorder.none; 
    return TaskListLayout(
      titleWidget: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: TextField(
          autofocus: true,
          style: GoogleFonts.roboto(color: customWhite, fontSize: 23), // TextStyle(color: palette['white']), 
          controller: _controller,
          onChanged: (_) => setState((){}),
          decoration: InputDecoration(
            isCollapsed: true,
            focusColor: customWhite, 
            label: const Text("Name", style: TextStyle(color: Colors.white54)), 
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: textBorder, 
            focusedBorder: textBorder, 
            enabledBorder: textBorder
          )
        ),
      ), 
      bodyWidget: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              children: ListColor.values.map((listColor) => 
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () => setState(() => currentColor = listColor), 
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 35, 
                      height: 35, 
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: listColorToColor(listColor), 
                        // border: Border.all(color: palette['white']!, width: 2)
                      ), 
                      child: currentColor == listColor ? 
                        Icon(Icons.check, color: customWhite)
                      : null, 
                    )
                  ),
                )
              ).toList()
            ), 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: customWhite, 
                  ), 
                  child: Text("Cancel", style: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.red))), 
                  onPressed: () => context.read<TaskListsBloc>().add(StopAddingListEvent())
                ),
                const SizedBox(width: 5), 
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ), 
                    child: Text("Add", style: GoogleFonts.roboto(textStyle: TextStyle(color: customWhite))), 
                    onPressed: _controller.text.isEmpty ? 
                      null 
                    : () => context.read<TaskListsBloc>().add(AddTaskListEvent(
                      _controller.text, 
                      currentColor,
                    ))
                  ),
                ),
              ],
            )
          ]
        ),
      ),
      color: listColorToColor(currentColor), 
    ); 
  }
}


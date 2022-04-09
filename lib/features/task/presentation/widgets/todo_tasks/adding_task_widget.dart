import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/presentation/colors.dart';
import '../../todo_tasks_bloc/todo_tasks_bloc.dart';

class AddingTaskWidget extends StatefulWidget {
  const AddingTaskWidget({ Key? key }) : super(key: key);

  @override
  State<AddingTaskWidget> createState() => _AddingTaskWidgetState();
}

class _AddingTaskWidgetState extends State<AddingTaskWidget> {
  final _controller = TextEditingController(); 
  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    const textBorder = InputBorder.none; 
    return Padding(
      padding: const EdgeInsets.only(left: 45, top: 16, bottom: 13),
      child: TextField(
        controller: _controller,
        style: GoogleFonts.roboto(fontSize: 18), 
        autofocus: true,
        onSubmitted: (text) => text.isEmpty ? 
          null
        : context.read<TodoTasksBloc>().add(AddTaskEvent(text)),
        decoration: InputDecoration(
          isCollapsed: true,
          focusColor: customWhite,
          // filled: true, 
          label: const Text("Name", style: TextStyle(color: Colors.white54)), 
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: textBorder, 
          suffix: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red), 
              onPressed: () => context.read<TodoTasksBloc>().add(StopAddingTaskEvent()), 
            ), 
            IconButton(
              icon: const Icon(Icons.done, color: Colors.green), 
              onPressed: () => context.read<TodoTasksBloc>().add(AddTaskEvent(_controller.text)), 
            ), 
          ]), 
          focusedBorder: textBorder, 
          enabledBorder: textBorder
        )
      )
    ); 
  }
}

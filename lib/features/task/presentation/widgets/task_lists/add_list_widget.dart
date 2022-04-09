
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../task_lists_bloc/task_lists_bloc.dart'; 

class AddListWidget extends StatelessWidget {
  final Function() onPressed; 
  const AddListWidget({
    required this.onPressed, 
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        InkWell(
          onTap: context.read<TaskListsBloc>().state is TaskListsLoaded ? onPressed : null, 
          borderRadius: const BorderRadius.all(Radius.circular(5)), 
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.grey.shade300), 
              borderRadius: const BorderRadius.all(Radius.circular(5)), 
            ),
            child: const Icon(Icons.add)
          )
        ), 
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text("Add List", 
            style: TextStyle(
              fontSize: 15, 
              color: Colors.grey.shade500, 
              fontWeight: FontWeight.bold
            )
          )
        )
      ])
    );
  }
}

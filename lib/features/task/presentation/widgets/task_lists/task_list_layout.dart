import 'package:flutter/material.dart';


class TaskListLayout extends StatelessWidget {
  final Widget titleWidget; 
  final Widget bodyWidget; 
  final Color? color; 
  const TaskListLayout({ 
    required this.titleWidget, 
    required this.bodyWidget, 
    required this.color, 
    Key? key 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175, 
      child: Card(
        color: color, 
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10, ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: SizedBox(
                  height: 50, 
                  child: Align(
                    alignment: Alignment.bottomLeft, 
                    child: titleWidget
                  )
                )
              ), 
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Divider(thickness: 2.5, color: Colors.white30),
              ), 
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: bodyWidget,
                )              
              )
            ]
          ),
        ),
      )
    );
  }
}

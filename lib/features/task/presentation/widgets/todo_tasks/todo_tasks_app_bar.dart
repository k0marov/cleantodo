import 'package:flutter/material.dart';

import '../shared/logo_widget.dart';

class TodoTasksAppBar extends StatelessWidget {
  const TodoTasksAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const LogoWidget(), 
        Padding(
          padding: const EdgeInsets.only(right: 40),
          child: IconButton(
            icon: const Icon(Icons.close, size: 30), 
            onPressed: () => Navigator.of(context).pop(),
          ),
        ), 
      ]),
    );
  }
}
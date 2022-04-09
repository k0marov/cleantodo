import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_clean_architecture/features/task/presentation/pages/task_lists_page.dart';
import 'injection_container.dart' as di; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await di.init(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.sunflowerTextTheme(
        )
      ),
      home: const TaskListsPage(),
    );
  }
}



import 'package:equatable/equatable.dart';

class TodoTask extends Equatable {
  final String text; 
  final bool isCompleted; 

  @override 
  List get props => [text, isCompleted]; 

  const TodoTask({
    required this.text, 
    required this.isCompleted
  }); 

}
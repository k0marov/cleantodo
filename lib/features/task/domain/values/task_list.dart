import 'package:equatable/equatable.dart';
import '../../../../core/const/list_colors.dart';

class TaskList extends Equatable {
  final String title; 
  final ListColor color; 

  @override 
  List get props => [title, color]; 

  const TaskList({
    required this.title, 
    required this.color, 
  }); 
}
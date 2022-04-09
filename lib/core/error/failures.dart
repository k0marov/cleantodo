import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  final List props; 
  const Failure([this.props=const []]); 
}

class DataFailure extends Failure {} 

const dataFailureMessage = "Some data error happened"; 
const addingTaskFailureMessage = "Error: trying to add new task when not all tasks have been loaded"; 
const togglingTaskFailureMessage = "Error: trying to toggle task when not all tasks have been loaded"; 
const addingListFailureMessage = "Error: tried to add a task list while task lists were not loaded"; 
const deletingListFailureMessage = "Error: tried to delete a task list while task lists were not loaded"; 
const stoppingDeletingFailureMessage = "Error: tried to stop deleting when you were not deleting"; 
const deletingTaskFailureMessage = "Error: tried to delete a task while other tasks were not loaded"; 
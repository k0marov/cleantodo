import 'package:sembast/sembast.dart';
import 'package:todo_clean_architecture/core/error/exceptions.dart';
import 'package:todo_clean_architecture/features/task/data/models/task_list_model.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task_list_entity.dart';
import '../../domain/values/task_list.dart';

abstract class TaskListDataSource {
  /// Adds new task list
  /// returns the same task list, but with id 
  /// throws [DataException] if some error happened 
  Future<TaskListModel> addTaskList(TaskList newTaskList); 
  /// Deletes task list entity 
  /// throws [DataException] if some error happened 
  Future<void> deleteTaskList(TaskListEntity taskList); 
  /// Gets all task list entities (as models)
  /// throws [DataException] if some error happened
  Future<List<TaskListModel>> getAllTaskLists(); 
}


class TaskListDataSourceImpl implements TaskListDataSource {
  final Database _db; 
  final _store = StoreRef("taskLists"); 
  static const _uuid = Uuid(); 

  TaskListDataSourceImpl(Database db) : _db = db; 

  @override
  Future<TaskListModel> addTaskList(TaskList newTaskList) async {
    final String newId = _uuid.v1().substring(0, 8); 
    final model = TaskListModel(TaskListEntity(
      id: newId, 
      createdAt: DateTime.now(),
      value: newTaskList
    ));
    try {
      await _store.record(newId).put(_db, model.toJson()); 
    } catch (e) {
      throw DataException(); 
    }
    return model; 
  }

  @override
  Future<void> deleteTaskList(TaskListEntity taskList) async {
    if (await _store.record(taskList.id).delete(_db) == null) {
      throw DataException(); 
    }
  }

  @override
  Future<List<TaskListModel>> getAllTaskLists() async {
    try {
      final records = await _store.find(_db); 
      return records
        .map((RecordSnapshot record) => TaskListModel.fromJson(record.value))
        .toList()
        ..sort((a, b) => a.toEntity().compareTo(b.toEntity()));
    } catch (e) {
      throw DataException(); 
    }
  }
}
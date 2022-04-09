import 'package:sembast/sembast.dart';
import 'package:todo_clean_architecture/core/error/exceptions.dart';
import 'package:todo_clean_architecture/features/task/data/models/todo_task_model.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/task_list_entity.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/todo_task_entity.dart';
import '../../domain/values/todo_task.dart';

abstract class TodoTaskDataSource {
  /// Adds a new task to a task list
  /// return new task's id
  /// Throws a [DataException] in case of an error
  Future<TodoTaskModel> addTask(String taskListId, TodoTask task); 
  /// Deletes the task from db 
  /// Throws a [DataException] in case of an error (for example, task does not exist)
  Future<void> deleteTask(TodoTaskEntity todoTaskEntity); 
  /// Gets all tasks from a task list
  /// Throws a [DataException] in case of an error
  Future<List<TodoTaskModel>> getTasks(String taskListId); 
  /// Sets "completed" to the specified value
  /// Throws a [DataException] in case of an error
  Future<TodoTaskModel> updateCompleted(TodoTaskEntity task, bool newValue); 
  /// Deletes all tasks of a given task list 
  Future<void> deleteAllTasks(String taskListId); 
}


class TodoTaskDataSourceImpl implements TodoTaskDataSource {
  final Database _db; 
  static const _uuid = Uuid(); 
  TodoTaskDataSourceImpl(this._db);

  @override
  Future<TodoTaskModel> addTask(String taskListId, TodoTask task) async {
    final newId = _uuid.v1().substring(0,8); 
    final taskModel = TodoTaskModel(
      TodoTaskEntity(
        listId: taskListId, 
        createdAt: DateTime.now(),
        id: newId, 
        value: task, 
      )
    ); 
    try {
      await StoreRef(taskListId).record(newId).put(_db, taskModel.toJson()); 
    } catch (e) {
      throw DataException(); 
    }

    return taskModel;
  }

  @override
  Future<List<TodoTaskModel>> getTasks(String taskListId) async {
    try {
      final store = StoreRef(taskListId); 
      final records = await store.find(_db); 
      return records
        .map((record) => TodoTaskModel.fromJson(record.value)) 
        .toList()
        ..sort((a,b) => a.toEntity().compareTo(b.toEntity())); 
    } catch (e) {
      throw DataException(); 
    }
  }

  @override
  Future<TodoTaskModel> updateCompleted(TodoTaskEntity task, bool newValue) async {
    final modifiedModel = TodoTaskModel(
      TodoTaskEntity(
        listId: task.listId, 
        createdAt: task.createdAt,
        id: task.id, 
        value: TodoTask(
          text: task.value.text, 
          isCompleted: newValue
        ) 
      )
    ); 
    try {
      await StoreRef(task.listId).record(task.id).put(_db, modifiedModel.toJson()); 
    } catch (e) {
      throw DataException(); 
    }
    return modifiedModel; 
  }

  @override
  Future<void> deleteTask(TodoTaskEntity todoTaskEntity) async {
    try {
      if (await StoreRef(todoTaskEntity.listId).record(todoTaskEntity.id).delete(_db) == null) {
        throw DataException(); 
      }
    } catch (e) {
      throw DataException(); 
    }
  }

  @override
  Future<void> deleteAllTasks(String taskListId) async {
    try {
      await StoreRef(taskListId).drop(_db); 
    } catch (e) {
      throw DataException();
    }
  }


}
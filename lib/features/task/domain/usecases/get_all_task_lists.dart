import 'package:dartz/dartz.dart';
import 'package:todo_clean_architecture/core/usecases/usecase.dart';
import 'package:todo_clean_architecture/features/task/domain/entities/task_list_entity.dart';

import '../../../../core/error/failures.dart';
import '../repositories/task_list_repository.dart';

class GetAllTaskLists extends UseCase<List<TaskListEntity>, NoParams> {
  final TaskListRepository repository; 
  GetAllTaskLists(this.repository); 

  @override
  Future<Either<Failure, List<TaskListEntity>>> call(NoParams params) {
    return repository.getAllTaskLists(); 
  }
}
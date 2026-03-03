import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/todo_model.dart';
import '../../../core/network/dio_provider.dart';

part 'todo_repository.g.dart';

@riverpod
TodoRepository todoRepository(Ref ref) =>
    TodoRepository(ref.watch(dioProvider));

class TodoRepository {
  final Dio _dio;
  TodoRepository(this._dio);

  Future<List<TodoItem>> getTodos() async {
    final res = await _dio.get('/todos');
    return TodoResponse.fromJson(res.data).todos;
  }

  Future<TodoItem> getTodo(int id) async {
    final res = await _dio.get('/todos/$id');
    return TodoItem.fromJson(res.data);
  }

  Future<TodoItem> addTodo(String task) async {
    final res = await _dio.post(
      '/todos/add',
      data: {'todo': task, 'completed': false, 'userId': 1},
    );
    return TodoItem.fromJson(res.data);
  }

  Future<TodoItem> updateTodo(int id, bool completed) async {
    final res = await _dio.put('/todos/$id', data: {'completed': completed});
    return TodoItem.fromJson(res.data);
  }

  Future<void> deleteTodo(int id) async {
    await _dio.delete('/todos/$id');
  }
}

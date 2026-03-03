import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/todo_repository.dart';
import '../domain/todo_model.dart';

part 'todo_controller.g.dart';

/// The main controller for the Todo List.
/// In Riverpod 3, AsyncNotifier handles the Loading/Error/Data states automatically.
@riverpod
class TodoListController extends _$TodoListController {
  @override
  FutureOr<List<TodoItem>> build() async {
    // 1. Fetch the full list from API
    final allTodos = await ref.watch(todoRepositoryProvider).getTodos();

    // 2. Watch the search query
    final query = ref.watch(todoSearchQueryProvider).toLowerCase();

    // 3. Return the filtered list
    if (query.isEmpty) return allTodos;

    return allTodos.where((todo) {
      return todo.task.toLowerCase().contains(query);
    }).toList();
  }

  // --- CREATE ---
  Future<void> addTodo(String title) async {
    state = await AsyncValue.guard(() async {
      final newItem = await ref.read(todoRepositoryProvider).addTodo(title);
      final currentList = state.value ?? [];
      return [...currentList, newItem];
    });
  }

  // --- UPDATE (Title and/or Status) ---
  Future<void> updateTodo(int id, {String? task, bool? completed}) async {
    state = await AsyncValue.guard(() async {
      final updatedItem = await ref
          .read(todoRepositoryProvider)
          .updateTodo(id, completed ?? false);

      // Replace only the updated item in the list
      return state.value!.map((t) => t.id == id ? updatedItem : t).toList();
    });
  }

  // --- TOGGLE STATUS (Helper) ---
  Future<void> toggleTodo(TodoItem item) async {
    // Helper method specifically for the checkbox
    await updateTodo(item.id, completed: !item.completed);
  }

  // --- DELETE ---
  Future<void> deleteTodo(int id) async {
    state = await AsyncValue.guard(() async {
      await ref.read(todoRepositoryProvider).deleteTodo(id);

      // Remove the item from the local state list
      return state.value!.where((t) => t.id != id).toList();
    });
  }
}

/// A separate provider for single Todo details.
/// This allows the Detail Popup to have its own loading state without
/// affecting the main list's state.
@riverpod
Future<TodoItem> todoDetail(Ref ref, int id) {
  return ref.watch(todoRepositoryProvider).getTodo(id);
}

@riverpod
class TodoSearchQuery extends _$TodoSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_controller.dart';
import '../domain/todo_model.dart';
import 'todo_controller.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoState = ref.watch(todoListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: 'Search tasks...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  ref.read(todoSearchQueryProvider.notifier).update(value);
                },
              )
            : const Text(
                'Riverpod 3 CRUD',
                style: TextStyle(color: Colors.white),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  ref.read(todoSearchQueryProvider.notifier).update('');
                }
              });
            },
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(
                ref.watch(authControllerProvider).user?.image ?? '',
              ),
            ),
            onPressed: () => AppTheme.showThemeSelector(context, ref),
          ),
        ],
      ),
      body: todoState.when(
        data: (todos) => ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final item = todos[index];
            return _TodoListItem(item: item);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTodoDialog(context, ref),
        label: const Text('New Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  // --- CRUD Dialogs & Helpers ---

  void _showAddTodoDialog(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final isInputValid = textController.text.trim().length >= 3;

          return AlertDialog(
            title: const Text('Add New Task'),
            content: TextField(
              controller: textController,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'What needs to be done?',
                errorText: !isInputValid && textController.text.isNotEmpty
                    ? 'At least 3 characters'
                    : null,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isInputValid
                    ? () {
                        ref
                            .read(todoListControllerProvider.notifier)
                            .addTodo(textController.text.trim());
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TodoListItem extends ConsumerWidget {
  final TodoItem item;
  const _TodoListItem({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key('todo-${item.id}'),
      direction: DismissDirection.horizontal,

      // Swipe Right (Edit)
      background: Container(
        color: Colors.blue.shade400,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.edit, color: Colors.white),
      ),

      // Swipe Left (Delete)
      secondaryBackground: Container(
        color: Colors.red.shade400,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _showEditTodoDialog(context, ref, item);
          return false; // Snaps back after opening dialog
        } else {
          return await _confirmDelete(context);
        }
      },
      onDismissed: (_) {
        ref.read(todoListControllerProvider.notifier).deleteTodo(item.id);
      },

      child: ListTile(
        onTap: () => _showTodoDetail(context, ref, item.id),
        leading: Checkbox(
          value: item.completed,
          onChanged: (val) =>
              ref.read(todoListControllerProvider.notifier).toggleTodo(item),
        ),
        title: Text(
          item.task,
          style: TextStyle(
            decoration: item.completed ? TextDecoration.lineThrough : null,
            color: item.completed ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }

  // --- Individual Logic Helpers ---

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: const Text('Are you sure you want to remove this item?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showEditTodoDialog(BuildContext context, WidgetRef ref, TodoItem item) {
    final textController = TextEditingController(text: item.task);
    bool isCompleted = item.completed;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              CheckboxListTile(
                title: const Text('Completed'),
                value: isCompleted,
                onChanged: (v) => setState(() => isCompleted = v ?? false),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(todoListControllerProvider.notifier)
                    .updateTodo(
                      item.id,
                      task: textController.text.trim(),
                      completed: isCompleted,
                    );
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTodoDetail(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final detailAsync = ref.watch(todoDetailProvider(id));
          return AlertDialog(
            title: const Text('Task Detail'),
            content: detailAsync.when(
              data: (todo) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: ${todo.id}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    todo.task,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Status: ${todo.completed ? "Done" : "Pending"}'),
                ],
              ),
              loading: () => const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Error: $e'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
    );
  }
}

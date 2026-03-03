// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The main controller for the Todo List.
/// In Riverpod 3, AsyncNotifier handles the Loading/Error/Data states automatically.

@ProviderFor(TodoListController)
final todoListControllerProvider = TodoListControllerProvider._();

/// The main controller for the Todo List.
/// In Riverpod 3, AsyncNotifier handles the Loading/Error/Data states automatically.
final class TodoListControllerProvider
    extends $AsyncNotifierProvider<TodoListController, List<TodoItem>> {
  /// The main controller for the Todo List.
  /// In Riverpod 3, AsyncNotifier handles the Loading/Error/Data states automatically.
  TodoListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoListControllerHash();

  @$internal
  @override
  TodoListController create() => TodoListController();
}

String _$todoListControllerHash() =>
    r'2d81c71faeeca9d2d42521ed9130e7e4741f323d';

/// The main controller for the Todo List.
/// In Riverpod 3, AsyncNotifier handles the Loading/Error/Data states automatically.

abstract class _$TodoListController extends $AsyncNotifier<List<TodoItem>> {
  FutureOr<List<TodoItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<TodoItem>>, List<TodoItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<TodoItem>>, List<TodoItem>>,
              AsyncValue<List<TodoItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// A separate provider for single Todo details.
/// This allows the Detail Popup to have its own loading state without
/// affecting the main list's state.

@ProviderFor(todoDetail)
final todoDetailProvider = TodoDetailFamily._();

/// A separate provider for single Todo details.
/// This allows the Detail Popup to have its own loading state without
/// affecting the main list's state.

final class TodoDetailProvider
    extends
        $FunctionalProvider<AsyncValue<TodoItem>, TodoItem, FutureOr<TodoItem>>
    with $FutureModifier<TodoItem>, $FutureProvider<TodoItem> {
  /// A separate provider for single Todo details.
  /// This allows the Detail Popup to have its own loading state without
  /// affecting the main list's state.
  TodoDetailProvider._({
    required TodoDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'todoDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$todoDetailHash();

  @override
  String toString() {
    return r'todoDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TodoItem> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TodoItem> create(Ref ref) {
    final argument = this.argument as int;
    return todoDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TodoDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$todoDetailHash() => r'e834b9514934002c1e55943c61802c45ded9596c';

/// A separate provider for single Todo details.
/// This allows the Detail Popup to have its own loading state without
/// affecting the main list's state.

final class TodoDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TodoItem>, int> {
  TodoDetailFamily._()
    : super(
        retry: null,
        name: r'todoDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A separate provider for single Todo details.
  /// This allows the Detail Popup to have its own loading state without
  /// affecting the main list's state.

  TodoDetailProvider call(int id) =>
      TodoDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'todoDetailProvider';
}

@ProviderFor(TodoSearchQuery)
final todoSearchQueryProvider = TodoSearchQueryProvider._();

final class TodoSearchQueryProvider
    extends $NotifierProvider<TodoSearchQuery, String> {
  TodoSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoSearchQueryHash();

  @$internal
  @override
  TodoSearchQuery create() => TodoSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$todoSearchQueryHash() => r'98a330de26973969e0a45ebe3fde68acf396cf22';

abstract class _$TodoSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

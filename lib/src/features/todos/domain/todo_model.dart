import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
abstract class TodoItem with _$TodoItem {
  const TodoItem._();

  const factory TodoItem({
    required int id,
    @JsonKey(name: 'todo') required String task,
    required bool completed,
    required int userId,
  }) = _TodoItem;

  factory TodoItem.fromJson(Map<String, dynamic> json) =>
      _$TodoItemFromJson(json);
}

@freezed
abstract class TodoResponse with _$TodoResponse {
  const TodoResponse._();

  const factory TodoResponse({
    required List<TodoItem> todos,
    required int total,
    required int skip,
    required int limit,
  }) = _TodoResponse;

  factory TodoResponse.fromJson(Map<String, dynamic> json) =>
      _$TodoResponseFromJson(json);
}

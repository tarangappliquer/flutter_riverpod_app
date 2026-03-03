// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodoItem _$TodoItemFromJson(Map<String, dynamic> json) => _TodoItem(
  id: (json['id'] as num).toInt(),
  task: json['todo'] as String,
  completed: json['completed'] as bool,
  userId: (json['userId'] as num).toInt(),
);

Map<String, dynamic> _$TodoItemToJson(_TodoItem instance) => <String, dynamic>{
  'id': instance.id,
  'todo': instance.task,
  'completed': instance.completed,
  'userId': instance.userId,
};

_TodoResponse _$TodoResponseFromJson(Map<String, dynamic> json) =>
    _TodoResponse(
      todos: (json['todos'] as List<dynamic>)
          .map((e) => TodoItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      skip: (json['skip'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$TodoResponseToJson(_TodoResponse instance) =>
    <String, dynamic>{
      'todos': instance.todos,
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };

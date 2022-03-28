// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTodosRequest _$GetTodosRequestFromJson(Map<String, dynamic> json) =>
    GetTodosRequest(
      count: json['count'] as int? ?? defaultTodoCount,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$GetTodosRequestToJson(GetTodosRequest instance) =>
    <String, dynamic>{
      'count': instance.count,
      'token': instance.token,
    };

GetTodosResponse _$GetTodosResponseFromJson(Map<String, dynamic> json) =>
    GetTodosResponse(
      todos: (json['todos'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList(),
      token: json['token'] as String?,
      error: json['error'] as bool? ?? false,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GetTodosResponseToJson(GetTodosResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'messages': instance.messages,
      'token': instance.token,
      'todos': instance.todos,
    };

WriteTodosRequest _$WriteTodosRequestFromJson(Map<String, dynamic> json) =>
    WriteTodosRequest(
      todos: (json['todos'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WriteTodosRequestToJson(WriteTodosRequest instance) =>
    <String, dynamic>{
      'todos': instance.todos,
    };

WriteTodosResponse _$WriteTodosResponseFromJson(Map<String, dynamic> json) =>
    WriteTodosResponse(
      failedKeys: (json['failedKeys'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      error: json['error'] as bool? ?? false,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$WriteTodosResponseToJson(WriteTodosResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'messages': instance.messages,
      'failedKeys': instance.failedKeys,
    };

DeleteTodosRequest _$DeleteTodosRequestFromJson(Map<String, dynamic> json) =>
    DeleteTodosRequest(
      todoKeys:
          (json['todoKeys'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DeleteTodosRequestToJson(DeleteTodosRequest instance) =>
    <String, dynamic>{
      'todoKeys': instance.todoKeys,
    };

DeleteTodosResponse _$DeleteTodosResponseFromJson(Map<String, dynamic> json) =>
    DeleteTodosResponse(
      failedKeys: (json['failedKeys'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      error: json['error'] as bool? ?? false,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DeleteTodosResponseToJson(
        DeleteTodosResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'messages': instance.messages,
      'failedKeys': instance.failedKeys,
    };

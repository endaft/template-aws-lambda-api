// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      key: json['key'] as String,
      content: json['content'] as String,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      isComplete: json['isComplete'] as bool? ?? false,
    );

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'key': instance.key,
      'content': instance.content,
      'dueDate': instance.dueDate?.toIso8601String(),
      'isComplete': instance.isComplete,
    };

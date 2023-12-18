import 'package:meta/meta.dart';
import 'package:endaft_core/common.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/todo.dart';

part 'todos.g.dart';

const defaultTodoCount = 20;

@immutable
@JsonSerializable()
class GetTodosRequest extends RequestBase {
  GetTodosRequest({
    this.count = defaultTodoCount,
    this.token,
  }) : super();

  final int count;
  final String? token;

  @override
  List<Object?> get props => [count, token];

  factory GetTodosRequest.fromJson(Map<String, dynamic> json) =>
      _$GetTodosRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetTodosRequestToJson(this);
}

@immutable
@JsonSerializable()
class GetTodosResponse extends ResponseBase {
  GetTodosResponse({
    required this.todos,
    this.token,
    super.error,
    super.messages,
  });

  final String? token;
  final List<Todo> todos;

  @override
  List<Object?> get props => [...super.props, todos];

  factory GetTodosResponse.fromJson(Map<String, dynamic> json) =>
      _$GetTodosResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetTodosResponseToJson(this);
}

@immutable
@JsonSerializable()
class WriteTodosRequest extends RequestBase {
  WriteTodosRequest({required this.todos}) : super();

  final List<Todo> todos;

  @override
  List<Object?> get props => [todos];

  factory WriteTodosRequest.fromJson(Map<String, dynamic> json) =>
      _$WriteTodosRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WriteTodosRequestToJson(this);
}

@immutable
@JsonSerializable()
class WriteTodosResponse extends ResponseBase {
  WriteTodosResponse({
    this.failedKeys = const [],
    super.error,
    super.messages,
  });

  final List<String> failedKeys;

  @override
  List<Object?> get props => [...super.props, failedKeys];

  factory WriteTodosResponse.fromJson(Map<String, dynamic> json) =>
      _$WriteTodosResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WriteTodosResponseToJson(this);
}

@immutable
@JsonSerializable()
class DeleteTodosRequest extends RequestBase {
  DeleteTodosRequest({required this.todoKeys}) : super();

  final List<String> todoKeys;

  @override
  List<Object?> get props => [todoKeys];

  factory DeleteTodosRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteTodosRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DeleteTodosRequestToJson(this);
}

@immutable
@JsonSerializable()
class DeleteTodosResponse extends ResponseBase {
  DeleteTodosResponse({
    this.failedKeys = const [],
    super.error,
    super.messages,
  });

  final List<String> failedKeys;

  @override
  List<Object?> get props => [...super.props, failedKeys];

  factory DeleteTodosResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteTodosResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DeleteTodosResponseToJson(this);
}

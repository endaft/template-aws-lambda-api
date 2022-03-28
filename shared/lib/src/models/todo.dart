import 'package:meta/meta.dart';
import 'package:endaft_core/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@immutable
@JsonSerializable()
class Todo extends AppContract {
  Todo({
    required this.key,
    required this.content,
    this.dueDate,
    this.isComplete = false,
  });

  final String key;
  final String content;
  final DateTime? dueDate;
  final bool isComplete;

  Todo update({
    String? content,
    DateTime? dueDate,
    bool? isComplete,
  }) {
    return Todo(
      key: key,
      content: content ?? this.content,
      dueDate: dueDate ?? this.dueDate,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  List<Object?> get props => [key, content, dueDate];

  factory Todo.make({required String content, DateTime? dueDate}) {
    return Todo(
      key: DateTime.now().microsecondsSinceEpoch.toString(),
      content: content,
      dueDate: dueDate,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}

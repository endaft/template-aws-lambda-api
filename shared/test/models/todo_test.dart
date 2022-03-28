import 'package:test/test.dart';
import 'package:app_shared/client.dart';

void main() {
  group('Todo Model Tests', () {
    test('Verifies Todo Update Works As Expected', () {
      final todoDate1 = DateTime.now();
      final todoDate2 = DateTime.now();
      final todoContent1 = createWord(count: randomInt(2, 9));
      final todoContent2 = createWord(count: randomInt(2, 9));
      final todo1 = Todo.make(content: todoContent1, dueDate: todoDate1);
      final todo2 = todo1.update(content: todoContent2);
      final todo3 = todo2.update(dueDate: todoDate2);

      expect(todo1, isNotNull);
      expect(todo1.dueDate, equals(todoDate1));
      expect(todo1.content, equals(todoContent1));

      expect(todo2, isNotNull);
      expect(todo2.dueDate, equals(todoDate1));
      expect(todo2.dueDate, equals(todo1.dueDate));
      expect(todo2.content, equals(todoContent2));
      expect(todo2.content, isNot(equals(todo1.content)));

      expect(todo3, isNotNull);
      expect(todo3.dueDate, equals(todoDate2));
      expect(todo3.content, equals(todoContent2));
      expect(todo3.content, equals(todo2.content));
    });

    test('Verifies Todo Make Works As Expected', () {
      final todoDate = DateTime.now();
      final todoContent = createWord(count: randomInt(2, 9));
      final todo1 = Todo.make(content: todoContent);
      final todo2 = Todo.make(content: todoContent, dueDate: todoDate);

      expect(todo1, isNotNull);
      expect(todo1.content, equals(todoContent));
      expect(todo1.dueDate, isNull);

      expect(todo2, isNotNull);
      expect(todo2.content, equals(todoContent));
      expect(todo2.dueDate, equals(todoDate));

      expect(todo1, isNot(equals(todo2)));
    });
  });
}

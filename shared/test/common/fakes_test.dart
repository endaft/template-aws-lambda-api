import 'package:test/test.dart';
import 'package:app_shared/client.dart';

void main() {
  group('Fakes Tests', () {
    test('Verifies makeFakeTodos Works As Expected', () {
      final todos = makeFakeTodos();

      expect(todos, isNotNull);
      expect(todos, isNotEmpty);
      expect(todos.length, equals(20));
    });

    test('Verifies makeFakeTodos With Count Works As Expected', () {
      final count = 5;
      final todos = makeFakeTodos(count: count);

      expect(todos, isNotNull);
      expect(todos, isNotEmpty);
      expect(todos.length, equals(count));
    });
  });
}

import 'package:test/test.dart';
import 'package:app_shared/client.dart';

void main() {
  group('Error Tests', () {
    test('Verifies TodoError Works As Expected', () {
      final message = 'testing';
      final error = TodoError(message);

      expect(error, isNotNull);
      expect(error.message, equals(message));
    });

    test('Verifies FinanceError Works As Expected', () {
      final message = 'testing';
      final error = FinanceError(message);

      expect(error, isNotNull);
      expect(error.message, equals(message));
    });
  });
}

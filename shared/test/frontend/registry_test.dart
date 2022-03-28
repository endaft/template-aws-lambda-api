import 'package:test/test.dart';
import 'package:app_shared/client.dart';
import 'package:app_shared/client_test.dart';

void main() {
  group('Client Registry Tests', () {
    test('Client Registry Works As Expected', () async {
      ClientRegistry().useConfig(getTestConfig());

      expect(ClientRegistry(), isNotNull);
      expect(ClientRegistry(), equals(ClientRegistry()));
      expect(ClientRegistry().appApi, isNotNull);
      expect(ClientRegistry().appApi, equals(ClientRegistry().appApi));
    });
  });
}

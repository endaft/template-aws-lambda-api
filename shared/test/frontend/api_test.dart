import 'dart:convert';

import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:app_shared/client.dart';
import 'package:app_shared/client_test.dart';

void main() {
  group('Frontend API Tests', () {
    setUpAll(() {
      ClientRegistry().useConfig(getTestConfig(
        <String, String>{'AWS_COGNITO_ENABLED': 'false'},
      ));
      ClientRegistry().injector.removeByKey<http.Client>();
      ClientRegistry()
          .injector
          .registerSingleton<http.Client>(() => MockHttpClient());

      registerFallbackValue(<String, dynamic>{});
      registerFallbackValue(Uri.parse('http://testing'));
    });

    test('GetTodos Works As Expected', () async {
      final api = ClientRegistry().appApi;
      final client = ClientRegistry().httpClient as MockHttpClient;

      when(() => client.get(
            any(that: uriEndsWith('/todos')),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response(
            jsonEncode(GetTodosResponse(todos: []).toJson()),
            200,
          ));

      expect(() => api.getTodos(), returnsNormally);
    });

    test('GetMeta Works As Expected', () async {
      final api = ClientRegistry().appApi;
      final client = ClientRegistry().httpClient as MockHttpClient;

      when(() => client.get(
            any(that: uriEndsWith('/meta')),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response(
            jsonEncode(GetMetaResponse(
                meta: DeploymentCost(
              DateTime.now().add(Duration(days: -30)),
              DateTime.now(),
              [ServiceCost('testing', 42, 'USD', ServiceCostType.actual)],
            )).toJson()),
            200,
          ));

      expect(() => api.getMeta(), returnsNormally);
    });
  });
}

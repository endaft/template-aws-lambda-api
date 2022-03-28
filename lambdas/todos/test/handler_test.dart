import 'dart:convert';

import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_shared/server.dart';
import 'package:app_shared/server_test.dart';

import '../lib/main.dart' as todos;

void main() {
  group('Todos Tests', () {
    final todoItems = [Todo(key: 'testing', content: 'write tests')];
    final todoItemsKeys = todoItems.map((e) => e.key).toList();

    setUpAll(() {
      ServerRegistry().useConfig(getTestConfig());
      registerFallbackValue(GetTodosRequest());
      registerFallbackValue(WriteTodosRequest(todos: todoItems));
      registerFallbackValue(DeleteTodosRequest(todoKeys: todoItemsKeys));
    });

    setUp(() {
      ServerRegistry().injector.removeByKey<Runtime>();
      ServerRegistry().injector.registerSingleton<Runtime>(() => MockRuntime());
      ServerRegistry().injector.removeByKey<AppApiHandler>();
      ServerRegistry()
          .injector
          .registerSingleton<AppApiHandler>(() => MockApiHandler());
    });

    test('Handles GET Todos Request Errors As Expected', () async {
      final resp = MockRuntime().queue(getFakeContext(), makeEventData());
      final apiHandler = ServerRegistry().apiHandler as MockApiHandler;

      // Setup mocked get todos request that fails
      when(() => apiHandler.todosGet(any(that: isA<GetTodosRequest>())))
          .thenThrow(AppError('An unexpected error'));

      // Invoke the whole lambda
      expect(todos.main, returnsNormally);

      // Wait until we get the response
      final response = await resp;
      expect(response, isNotNull);
      expect(response, isA<AwsApiGatewayResponse>());
      expect(response.statusCode, equals(500));
      expect(response.body, isNotNull);
      expect(response.body, isA<String>());

      final error = ErrorResponse.fromJson(jsonDecode(response.body!));
      expect(error, isNotNull);
      expect(error, isA<ErrorResponse>());
    });

    test('Handles GET Todo Request As Expected', () async {
      final resp = MockRuntime().queue(getFakeContext(), makeEventData());
      final apiHandler = ServerRegistry().apiHandler as MockApiHandler;

      // Setup mocked get todos request
      when(() => apiHandler.todosGet(any(that: isA<GetTodosRequest>())))
          .thenAnswer((_) async => GetTodosResponse(todos: []));

      // Invoke the whole lambda
      expect(todos.main, returnsNormally);

      // Wait until we get the response
      final response = await resp;
      expect(response, isNotNull);
      expect(response, isA<AwsApiGatewayResponse>());
      expect(response.statusCode, equals(200));
    });

    test('Handles POST Todo Request As Expected', () async {
      final resp = MockRuntime().queue(
          getFakeContext(),
          makeEventData(
            httpMethod: HttpMethod.post,
            body: <String, dynamic>{'todos': todoItems},
          ));
      final apiHandler = ServerRegistry().apiHandler as MockApiHandler;

      // Setup mocked get todos request
      when(() => apiHandler.todosWrite(any(that: isA<WriteTodosRequest>())))
          .thenAnswer((_) async => WriteTodosResponse());

      // Invoke the whole lambda
      expect(todos.main, returnsNormally);

      // Wait until we get the response
      final response = await resp;
      expect(response, isNotNull);
      expect(response, isA<AwsApiGatewayResponse>());
      expect(response.statusCode, equals(200));
    });

    test('Handles DELETE Todo Request As Expected', () async {
      final resp = MockRuntime().queue(
          getFakeContext(),
          makeEventData(
            httpMethod: HttpMethod.delete,
            body: <String, dynamic>{
              'todoKeys': ['testing']
            },
          ));
      final apiHandler = ServerRegistry().apiHandler as MockApiHandler;

      // Setup mocked get todos request
      when(() => apiHandler.todosDelete(any(that: isA<DeleteTodosRequest>())))
          .thenAnswer((_) async => DeleteTodosResponse());

      // Invoke the whole lambda
      expect(todos.main, returnsNormally);

      // Wait until we get the response
      final response = await resp;
      expect(response, isNotNull);
      expect(response, isA<AwsApiGatewayResponse>());
      expect(response.statusCode, equals(200));
    });

    test('Handles Bad Request As Expected', () async {
      final resp = MockRuntime().queue(
        getFakeContext(),
        makeEventData(httpMethod: HttpMethod.patch),
      );
      final apiHandler = ServerRegistry().apiHandler as MockApiHandler;

      // Setup mocked get todos request
      when(() => apiHandler.todosWrite(any(that: isA<WriteTodosRequest>())))
          .thenAnswer((_) async => WriteTodosResponse());

      // Invoke the whole lambda
      expect(todos.main, returnsNormally);

      // Wait until we get the response
      final response = await resp;
      expect(response, isNotNull);
      expect(response, isA<AwsApiGatewayResponse>());
      expect(response.statusCode, equals(400));
    });
  });
}

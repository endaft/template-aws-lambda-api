import 'dart:convert';

import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_shared/server.dart';
import 'package:app_shared/server_test.dart';

import '../lib/main.dart' as gateway;

void main() {
  group('Gateway Tests', () {
    setUpAll(() {
      ServerRegistry().useConfig(getTestConfig());
      Event.registerEvent<CloudFrontOriginRequestEvent>(
        CloudFrontOriginRequestEvent.fromJson,
      );
      registerFallbackValue(CloudFrontOriginRequestEvent(
        records: <CloudFrontRecords>[],
      ));
    });

    setUp(() {
      ServerRegistry().injector
        ..removeByKey<Runtime>()
        ..registerSingleton<Runtime>(() => MockRuntime())
        ..removeByKey<AppApiHandler>()
        ..registerSingleton<AppApiHandler>(() => MockApiHandler());
    });

    test('Serves SPA As Expected', () async {
      final resp = MockRuntime().queue<CloudFrontOriginResponse>(
        getFakeContext(),
        makeEventDataOrigin(),
      );
      final apiHandler = ServerRegistry().apiHandler as MockApiHandler;

      // Setup mocked get todos request
      when(() => apiHandler.serveSpaFrom(
            event: any(named: 'event'),
          )).thenAnswer((_) async => CloudFrontOriginResponse());

      // Invoke the whole lambda
      expect(gateway.main, returnsNormally);

      // Wait until we get the response
      final response = await resp;
      expect(response, isNotNull);
      expect(response, isA<CloudFrontOriginResponse>());
      expect(response.status, 200);
    });

    test('Handles SPA Errors As Expected', () async {
      final resp = MockRuntime().queue<CloudFrontOriginResponse>(
        getFakeContext(),
        makeEventDataOrigin(),
      );
      final apiHandler = ServerRegistry().apiHandler as MockApiHandler;

      // Setup mocked get todos request
      when(() => apiHandler.serveSpaFrom(
            event: any(named: 'event'),
          )).thenThrow(AppError('Failed to serve SPA'));

      // Invoke the whole lambda
      expect(gateway.main, returnsNormally);

      // Wait until we get the response
      final response = await resp;
      expect(response, isNotNull);
      expect(response, isA<CloudFrontOriginResponse>());
      expect(response.status, 500);
    });
  });
}

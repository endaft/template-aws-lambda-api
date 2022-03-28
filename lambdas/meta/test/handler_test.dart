import 'dart:convert';

import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_shared/server.dart';
import 'package:app_shared/server_test.dart';

import '../lib/main.dart' as meta;

void main() {
  group('Meta Tests', () {
    setUpAll(() {
      ServerRegistry().useConfig(getTestConfig());
      registerFallbackValue(Expression());
      registerFallbackValue(Metric.blendedCost);
      registerFallbackValue(Granularity.monthly);
      registerFallbackValue(List<GroupDefinition>.empty());
      registerFallbackValue(DateInterval(
        end: DateTime.now().toIso8601String().split('T').first,
        start: DateTime.now()
            .add(Duration(days: -90))
            .toIso8601String()
            .split('T')
            .first,
      ));
    });

    setUp(() {
      ServerRegistry().injector.removeByKey<Runtime>();
      ServerRegistry().injector.registerSingleton<Runtime>(() => MockRuntime());

      ServerRegistry().injector.removeByKey<CostExplorer>();
      ServerRegistry()
          .injector
          .registerSingleton<CostExplorer>(() => MockCostExplorer());
    });

    test('Handles Meta Request Errors As Expected', () async {
      final resp = MockRuntime().queue(getFakeContext(), makeEventData());
      final ce = ServerRegistry().costExplorer as MockCostExplorer;

      // Setup mocked cost & usage error response
      when(() => ce.getCostAndUsageWithResources(
            filter: any(named: 'filter'),
            metrics: any(named: 'metrics'),
            groupBy: any(named: 'groupBy'),
            timePeriod: any(named: 'timePeriod'),
            granularity: any(named: 'granularity'),
            nextPageToken: any(named: 'nextPageToken'),
          )).thenThrow(DataUnavailableException());

      // Invoke the whole lambda
      expect(meta.main, returnsNormally);

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
      expect(error.messages.first,
          equals('There was a financial data availability error.'));
    });

    test('Handles Meta Request As Expected', () async {
      final resp = MockRuntime().queue(getFakeContext(), makeEventData());
      final ce = ServerRegistry().costExplorer as MockCostExplorer;

      // Setup mocked forecast response
      when(() => ce.getCostForecast(
            metric: any(named: 'metric'),
            timePeriod: any(named: 'timePeriod'),
            granularity: any(named: 'granularity'),
            filter: any(named: 'filter'),
          )).thenAnswer((_) async => GetCostForecastResponse(
            forecastResultsByTime: [],
            total: MetricValue(amount: '50', unit: 'USD'),
          ));

      // Setup mocked cost & usage response
      when(() => ce.getCostAndUsageWithResources(
                filter: any(named: 'filter'),
                metrics: any(named: 'metrics'),
                groupBy: any(named: 'groupBy'),
                timePeriod: any(named: 'timePeriod'),
                granularity: any(named: 'granularity'),
                nextPageToken: any(named: 'nextPageToken'),
              ))
          .thenAnswer(
              (_) async => GetCostAndUsageWithResourcesResponse(resultsByTime: [
                    ResultByTime(groups: [
                      Group(metrics: <String, MetricValue>{
                        "BlendedCost": MetricValue(amount: '50', unit: 'USD')
                      })
                    ])
                  ]));

      // Invoke the whole lambda
      expect(meta.main, returnsNormally);

      // Wait until we get the response
      final response = await resp;
      expect(response, isNotNull);
      expect(response, isA<AwsApiGatewayResponse>());
      expect(response.statusCode, equals(200));
    });
  });
}

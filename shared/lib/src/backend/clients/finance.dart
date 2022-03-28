import 'package:aws_ce_api/ce-2017-10-25.dart';
import 'package:aws_cur_api/cur-2017-01-06.dart';
import 'package:tuple/tuple.dart';

import '../registry.dart';
import '../../models/all.dart';
import '../../messages/all.dart';

export 'package:aws_cur_api/cur-2017-01-06.dart';
export 'package:aws_ce_api/ce-2017-10-25.dart' hide Context;

class FinanceClient {
  static const kAwsReqTimeout = Duration(seconds: 5);

  late CostExplorer _ce;

  FinanceClient() {
    _ce = ServerRegistry().costExplorer;
  }

  Tuple3<DateInterval, DateTime, DateTime> _getMonthInterval(
      [int monthsOffset = 0]) {
    var now = DateTime.now();
    var baseMonth = now.month + monthsOffset;
    var end = DateTime(now.year, baseMonth);
    var start = DateTime(now.year, baseMonth - 1);
    return Tuple3(
        DateInterval(
            end: end.toIso8601DateString(), start: start.toIso8601DateString()),
        start,
        end);
  }

  Expression _getFilterExpression(List<TagFilter> filters) {
    return Expression(
        and: filters
            .map<Expression>((e) => Expression(
                    tags:
                        TagValues(key: e.key, values: e.values, matchOptions: [
                  MatchOption.equals,
                  e.caseSensitive
                      ? MatchOption.caseSensitive
                      : MatchOption.caseInsensitive
                ])))
            .toList());
  }

  Future<ServiceCost> _getServiceCostForecast(
      DateInterval time, List<TagFilter> filters,
      [Metric metricType = Metric.blendedCost]) async {
    var expr = _getFilterExpression(filters);
    var resp = await _ce.getCostForecast(
        granularity: Granularity.monthly,
        metric: metricType,
        timePeriod: time,
        filter: expr);
    return ServiceCost(
        filters.isEmpty ? 'no-key' : filters.first.key,
        double.tryParse(resp.total?.amount ?? "") ?? double.nan,
        resp.total?.unit ?? "USD",
        ServiceCostType.forecasted);
  }

  Future<ServiceCost> _getServiceCostActual(
      DateInterval time, List<TagFilter> filters,
      [String metricName = "BlendedCost"]) async {
    var expr = _getFilterExpression(filters);
    var resp = await _ce.getCostAndUsageWithResources(
        filter: expr,
        timePeriod: time,
        granularity: Granularity.monthly,
        metrics: [metricName],
        groupBy: filters.isEmpty
            ? []
            : [
                GroupDefinition(
                    key: filters.first.key, type: GroupDefinitionType.tag)
              ]);

    var metric = resp.resultsByTime?.first.groups?.first.metrics![metricName];
    return ServiceCost(
        filters.isEmpty ? 'no-key' : filters.first.key,
        double.tryParse(metric?.amount ?? "") ?? double.nan,
        metric?.unit ?? "USD",
        ServiceCostType.actual);
  }

  Future<GetMetaResponse> getDeploymentCost(List<TagFilter> filters) async {
    var dateTime = _getMonthInterval(1);
    var time = dateTime.item1;
    var stop = dateTime.item3;
    var start = dateTime.item2;
    try {
      var services = await Future.wait([
        _getServiceCostActual(time, filters).timeout(kAwsReqTimeout),
        _getServiceCostForecast(time, filters).timeout(kAwsReqTimeout)
      ]);
      return GetMetaResponse(meta: DeploymentCost(start, stop, services));
    } on DataUnavailableException catch (e) {
      throw IntegrationError("There was a financial data availability error.",
          providerName: "AWS",
          serviceName: "Cost Explorer",
          serviceCode: e.code,
          serviceMessage: e.message);
    } on ValidationException catch (e) {
      throw IntegrationError(
          "There was a validation error obtaining financial data.",
          providerName: "AWS",
          serviceName: "Cost Explorer",
          serviceCode: e.code,
          serviceMessage: e.message);
    } on Exception catch (e) {
      throw IntegrationError("There was an error obtaining financial data.",
          providerName: "AWS",
          serviceName: "Cost Explorer",
          serviceMessage: e.toString());
    }
  }
}

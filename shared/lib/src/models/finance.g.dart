// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagFilter _$TagFilterFromJson(Map<String, dynamic> json) => TagFilter(
      json['key'] as String,
      (json['values'] as List<dynamic>).map((e) => e as String).toList(),
      caseSensitive: json['caseSensitive'] as bool? ?? false,
    );

Map<String, dynamic> _$TagFilterToJson(TagFilter instance) => <String, dynamic>{
      'key': instance.key,
      'values': instance.values,
      'caseSensitive': instance.caseSensitive,
    };

ServiceCost _$ServiceCostFromJson(Map<String, dynamic> json) => ServiceCost(
      json['name'] as String,
      (json['cost'] as num).toDouble(),
      json['unit'] as String,
      $enumDecode(_$ServiceCostTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$ServiceCostToJson(ServiceCost instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cost': instance.cost,
      'unit': instance.unit,
      'type': _$ServiceCostTypeEnumMap[instance.type],
    };

const _$ServiceCostTypeEnumMap = {
  ServiceCostType.actual: 'actual',
  ServiceCostType.forecasted: 'forecasted',
};

DeploymentCost _$DeploymentCostFromJson(Map<String, dynamic> json) =>
    DeploymentCost(
      DateTime.parse(json['from'] as String),
      DateTime.parse(json['thru'] as String),
      (json['services'] as List<dynamic>)
          .map((e) => ServiceCost.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DeploymentCostToJson(DeploymentCost instance) =>
    <String, dynamic>{
      'from': instance.from.toIso8601String(),
      'thru': instance.thru.toIso8601String(),
      'services': instance.services,
    };

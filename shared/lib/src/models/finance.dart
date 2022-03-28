import 'package:meta/meta.dart';
import 'package:endaft_core/client.dart';
import 'package:json_annotation/json_annotation.dart';

import './enums.dart';

part 'finance.g.dart';

/// Defines a tag filter used to filter financial API data
@immutable
@JsonSerializable()
class TagFilter extends AppContract {
  TagFilter(this.key, this.values, {this.caseSensitive = false});

  /// The name/key of the tag
  final String key;

  /// The required tag values
  final List<String> values;

  /// Whether or not to compare case
  final bool caseSensitive;

  @override
  List<Object?> get props => [...super.props, key, values];

  factory TagFilter.fromJson(Map<String, dynamic> json) =>
      _$TagFilterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TagFilterToJson(this);
}

/// Represents the cost of a service
@immutable
@JsonSerializable()
class ServiceCost extends AppContract {
  ServiceCost(this.name, this.cost, this.unit, this.type);

  /// The service name
  final String name;

  /// The service cost
  final double cost;

  /// The service cost unit
  final String unit;

  /// The service cost type
  final ServiceCostType type;

  @override
  List<Object?> get props => [...super.props, name, cost, unit];

  factory ServiceCost.fromJson(Map<String, dynamic> json) =>
      _$ServiceCostFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ServiceCostToJson(this);
}

/// Represents the ranged cost of a deployment
@immutable
@JsonSerializable()
class DeploymentCost extends AppContract {
  DeploymentCost(this.from, this.thru, this.services);

  /// The beginning of the reported period
  final DateTime from;

  /// The end of the reported period
  final DateTime thru;

  /// The [ServiceCost]s of the deployment for the specified period
  final List<ServiceCost> services;

  @override
  List<Object?> get props => [...super.props, from, thru, services];

  factory DeploymentCost.fromJson(Map<String, dynamic> json) =>
      _$DeploymentCostFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DeploymentCostToJson(this);
}

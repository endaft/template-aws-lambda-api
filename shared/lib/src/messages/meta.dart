import 'package:meta/meta.dart';
import 'package:endaft_core/common.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/finance.dart';

part 'meta.g.dart';

@immutable
@JsonSerializable()
class GetMetaRequest extends RequestBase {
  GetMetaRequest() : super();

  @override
  List<Object?> get props => [];

  factory GetMetaRequest.fromJson(Map<String, dynamic> json) =>
      _$GetMetaRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetMetaRequestToJson(this);
}

@immutable
@JsonSerializable()
class GetMetaResponse extends ResponseBase {
  GetMetaResponse({
    super.error,
    super.messages,
    required this.meta,
  });

  final DeploymentCost meta;

  @override
  List<Object?> get props => [...super.props, meta];

  factory GetMetaResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMetaResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetMetaResponseToJson(this);
}

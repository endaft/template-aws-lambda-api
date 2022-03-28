// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMetaRequest _$GetMetaRequestFromJson(Map<String, dynamic> json) =>
    GetMetaRequest();

Map<String, dynamic> _$GetMetaRequestToJson(GetMetaRequest instance) =>
    <String, dynamic>{};

GetMetaResponse _$GetMetaResponseFromJson(Map<String, dynamic> json) =>
    GetMetaResponse(
      error: json['error'] as bool? ?? false,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      meta: DeploymentCost.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetMetaResponseToJson(GetMetaResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'messages': instance.messages,
      'meta': instance.meta,
    };

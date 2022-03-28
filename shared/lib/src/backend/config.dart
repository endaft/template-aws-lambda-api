import 'dart:io';

import 'package:endaft_core/server.dart';

abstract class AwsConfig {
  String get region;
}

abstract class DocumentDbConfig implements AwsConfig {
  String get tableName;
}

class ServerConfig extends BaseServerConfig
    implements AwsConfig, DocumentDbConfig {
  ServerConfig([Map<String, String>? env]) : super(env ?? Platform.environment);

  @override
  String get region => getOrThrow('AWS_REGION');

  @override
  String get tableName => getOrThrow('DATA_TABLE_NAME');
}

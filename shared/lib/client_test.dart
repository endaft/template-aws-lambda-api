import 'dart:collection';

import 'client.dart';

export 'package:endaft_core/client_test.dart';

Map<String, String> getTestEnv([Map<String, String>? overrides]) {
  return UnmodifiableMapView(Map<String, String>.from({})
    ..addAll({
      'API_BASE_URL': 'http://testing',
      'API_TIMEOUT_SECONDS': '30',
      'AWS_COGNITO_ENABLED': 'true',
      'AWS_COGNITO_CLIENT_ID': '1234567890FAKECLIENTID0987654321',
      'AWS_COGNITO_CLIENT_SECRET': '1234567890FAKECLIENTSECRET0987654321',
      'AWS_COGNITO_ENDPOINT': 'https:/id.test.my-great.app',
      'AWS_COGNITO_USER_POOL_ID': '1234567890_FAKEUSERPOOLID_0987654321',
    })
    ..addAll(overrides ?? {}));
}

ClientConfig getTestConfig([Map<String, String>? overrides]) {
  return ClientConfig(getTestEnv(overrides));
}

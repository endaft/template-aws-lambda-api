import 'package:test/test.dart';
import 'package:app_shared/client.dart';
import 'package:app_shared/client_test.dart';

void main() {
  group('Client Config Tests', () {
    test('Empty Config Throws As Expected', () async {
      ClientRegistry().useConfig(ClientConfig());
      final config = ClientRegistry().config;

      expect(config, isNotNull);
      expect(() => config.baseUrl, throwsA(isA<MissingConfigError>()));
      expect(() => config.timeoutSeconds, throwsA(isA<MissingConfigError>()));
      expect(config.resolveUrl, isNotNull);
      expect(config.cognitoEnabled, equals(true));
      expect(() => config.cognitoClientId, throwsA(isA<MissingConfigError>()));
      expect(
        () => config.cognitoClientSecret,
        throwsA(isA<MissingConfigError>()),
      );
      expect(
        () => config.cognitoEndpoint,
        throwsA(isA<MissingConfigError>()),
      );
      expect(
        () => config.cognitoUserPoolId,
        throwsA(isA<MissingConfigError>()),
      );
    });

    test('Full Config Works As Expected', () async {
      final clientId = '1234567890FAKECLIENTID0987654321';
      final clientSecret = '1234567890FAKECLIENTSECRET0987654321';
      final userPoolId = '1234567890_FAKEUSERPOOLID_0987654321';
      final endpoint = 'https:/id.test.my-great.app';
      ClientRegistry().useConfig(getTestConfig(
        <String, String>{
          'AWS_COGNITO_ENABLED': 'false',
          'AWS_COGNITO_CLIENT_ID': clientId,
          'AWS_COGNITO_CLIENT_SECRET': clientSecret,
          'AWS_COGNITO_ENDPOINT': endpoint,
          'AWS_COGNITO_USER_POOL_ID': userPoolId,
        },
      ));
      final config = ClientRegistry().config;

      expect(config, isNotNull);
      expect(config.baseUrl, equals('http://testing'));
      expect(config.timeoutSeconds, equals(30));
      expect(config.resolveUrl, isNotNull);
      expect(config.resolveUrl('foo'), uriStartsWith('http://testing/foo'));
      expect(config.cognitoEnabled, equals(false));
      expect(config.cognitoClientId, equals(clientId));
      expect(config.cognitoClientSecret, equals(clientSecret));
      expect(config.cognitoEndpoint, equals(endpoint));
      expect(config.cognitoUserPoolId, equals(userPoolId));
    });
  });
}

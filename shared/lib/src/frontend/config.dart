import 'package:endaft_core/client.dart';

class ClientConfig extends BaseClientConfig {
  ClientConfig([Map<String, String>? env]) : super(env ?? <String, String>{});

  /// Gets the [BaseClientConfig.baseUrl] from `API_BASE_URL` in the provided env.
  @override
  String get baseUrl => getOrThrow('API_BASE_URL');

  /// Gets the [BaseClientConfig.timeoutSeconds] from `API_TIMEOUT_SECONDS` in the provided env.
  @override
  int get timeoutSeconds => int.parse(getOrThrow('API_TIMEOUT_SECONDS'));

  @override
  Uri resolveUrl(String relative) => Uri.parse(baseUrl).resolve(relative);

  @override
  bool get cognitoEnabled =>
      getOr('AWS_COGNITO_ENABLED', fallback: 'true') == 'true';

  @override
  String get cognitoClientId => getOrThrow('AWS_COGNITO_CLIENT_ID');

  @override
  String? get cognitoClientSecret => getOrThrow('AWS_COGNITO_CLIENT_SECRET');

  @override
  String? get cognitoEndpoint => getOrThrow('AWS_COGNITO_ENDPOINT');

  @override
  String get cognitoUserPoolId => getOrThrow('AWS_COGNITO_USER_POOL_ID');
}

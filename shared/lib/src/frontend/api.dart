import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:endaft_core/client.dart';

import 'config.dart';
import '../messages/all.dart';

class AppApi extends BaseAppApi<ClientConfig> {
  AppApi({required ClientConfig config, required http.Client httpClient})
      : super(config: config, httpClient: httpClient);

  Future<GetTodosResponse?> getTodos({
    int count = defaultTodoCount,
    String? token,
    ApiTimeoutHandler<GetTodosResponse> onTimeout,
  }) =>
      makeRequest(
        url: '/todos',
        request: GetTodosRequest(count: count, token: token),
        config: config,
        fromJson: GetTodosResponse.fromJson,
        onTimeout: onTimeout,
      );

  Future<GetMetaResponse?> getMeta({
    ApiTimeoutHandler<GetMetaResponse> onTimeout,
  }) =>
      makeRequest(
        url: '/meta',
        request: GetMetaRequest(),
        config: config,
        fromJson: GetMetaResponse.fromJson,
        onTimeout: onTimeout,
      );
}

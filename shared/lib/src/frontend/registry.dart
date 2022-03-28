import 'package:http/http.dart' as http;
import 'package:endaft_core/client.dart';

import 'api.dart';
import 'config.dart';

/// The client-side injection registry.
class ClientRegistry extends BaseClientRegistry<ClientConfig> {
  ClientRegistry._privateConstructor();
  static final ClientRegistry _instance = ClientRegistry._privateConstructor();

  @override
  void setup(ClientConfig config) {
    // Register default implementations here
    injector
      ..clearAll()
      ..registerSingleton<ClientConfig>(() => config)
      ..registerSingleton<http.Client>(() => http.Client())
      ..register<AppApi>(withConfig((c) => AppApi(
            config: c,
            httpClient: injector.get<http.Client>(),
          )));
  }

  /// Access the singleton [ClientRegistry] instance.
  factory ClientRegistry() => _instance;

  /// Gets the [AppApi] for handling requests.
  @override
  AppApi get appApi => injector.get<AppApi>();
}

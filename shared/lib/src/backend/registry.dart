import 'package:http/http.dart' as http;
import 'package:injector/injector.dart';
import 'package:endaft_core/server.dart';
import 'package:aws_ce_api/ce-2017-10-25.dart';

import 'config.dart';
import 'handler.dart';
import 'clients/document_db.dart';

/// The server-side injection registry.
class ServerRegistry extends BaseServerRegistry<ServerConfig> {
  ServerRegistry._privateConstructor();
  static final ServerRegistry _instance = ServerRegistry._privateConstructor();

  @override
  void setup(ServerConfig config) {
    // Register default implementations here
    injector
      ..clearAll()
      ..registerSingleton<ServerConfig>(() => config)
      ..registerSingleton<http.Client>(() => http.Client())
      ..register<Runtime>(Factory.singleton(() => Runtime()))
      ..register<CostExplorer>(withConfig(
        (config) => CostExplorer(region: config.region),
      ))
      ..register<DocumentDbClient>(withConfig(
        (config) => DocumentDbClient(
          region: config.region,
          tableName: config.tableName,
        ),
      ))
      ..register<AppApiHandler>(withConfig((config) => AppApiHandler(
            db: docDb,
            config: config,
            httpClient: httpClient,
          )));
  }

  /// Access the singleton [ServerRegistry] instance.
  factory ServerRegistry() => _instance;

  /// Gets the AWS [CostExplorer].
  CostExplorer get costExplorer => injector.get<CostExplorer>();

  /// Gets the [DocumentDbClient].
  DocumentDbClient get docDb => injector.get<DocumentDbClient>();

  /// Gets the [AppApiHandler].
  AppApiHandler get apiHandler => injector.get<AppApiHandler>();
}

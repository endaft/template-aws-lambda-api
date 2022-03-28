import 'package:app_shared/server.dart';

void main() async {
  final api = ServerRegistry().apiHandler;
  final Handler<AwsApiGatewayEvent> handler = (context, event) async {
    try {
      return (await api.metaGet(GetMetaRequest())).asApiResponse();
    } on AppError catch (e) {
      return e.toResponse().asApiResponse();
    }
  };

  ServerRegistry().runtime
    ..registerHandler<AwsApiGatewayEvent>("bootstrap", handler)
    ..invoke();
}

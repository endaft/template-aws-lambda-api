import 'package:app_shared/server.dart';

void main() async {
  final api = ServerRegistry().apiHandler;
  final Handler<CloudFrontOriginRequestEvent> handler = (context, event) async {
    try {
      return await api.serveSpaFrom(event: event);
    } on AppError catch (e) {
      return e.toResponse().asOriginResponse();
    }
  };

  ServerRegistry().runtime
    ..registerHandler<CloudFrontOriginRequestEvent>("bootstrap", handler)
    ..invoke();
}

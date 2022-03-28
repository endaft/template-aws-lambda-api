import 'package:app_shared/server.dart';

void main() async {
  final Handler<AwsApiGatewayEvent> handler = (context, event) async {
    try {
      final params = event.pathParameters;
      final api = ServerRegistry().apiHandler;
      switch (event.httpMethod) {
        case 'GET':
          {
            String? token = params?["token"];
            int count = params.parseIntOr('count', defaultTodoCount);
            final request = GetTodosRequest(count: count, token: token);
            return (await api.todosGet(request)).asApiResponse();
          }
        case 'POST':
          {
            final posted = event.getJsonBody();
            final request = WriteTodosRequest.fromJson(posted);
            return (await api.todosWrite(request)).asApiResponse();
          }
        case 'DELETE':
          {
            var posted = event.getJsonBody();
            final request = DeleteTodosRequest.fromJson(posted);
            return (await api.todosDelete(request)).asApiResponse();
          }
        default:
          return AwsApiGatewayResponse(statusCode: 400);
      }
    } on AppError catch (e) {
      return e.toResponse().asApiResponse();
    }
  };

  ServerRegistry().runtime
    ..registerHandler<AwsApiGatewayEvent>("bootstrap", handler)
    ..invoke();
}

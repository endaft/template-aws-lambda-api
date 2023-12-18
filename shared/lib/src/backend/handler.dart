import 'package:app_shared/server.dart';

import 'clients/finance.dart';
import 'clients/document_db.dart';

class AppApiHandler extends BaseAppApiHandler<ServerConfig> {
  AppApiHandler({
    required DocumentDbClient db,
    required super.config,
    required super.httpClient,
  }) {
    _db = db;
  }

  late final DocumentDbClient _db;

  Future<GetTodosResponse> todosGet(GetTodosRequest request) async {
    return GetTodosResponse(todos: makeFakeTodos());
    // final user = request.get<UserData>((_) => throw SecurityError.noUser());
    // return _db.readTodos(
    //   user.id,
    //   count: request.count,
    //   token: request.token,
    // );
  }

  Future<WriteTodosResponse> todosWrite(WriteTodosRequest request) async {
    final user = request.get<UserData>((_) => throw SecurityError.noUser());
    return _db.writeTodos(user.id, request.todos);
  }

  Future<DeleteTodosResponse> todosDelete(DeleteTodosRequest request) async {
    final user = request.get<UserData>((_) => throw SecurityError.noUser());
    return _db.deleteTodos(user.id, request.todoKeys);
  }

  Future<GetMetaResponse> metaGet(GetMetaRequest request) async {
    /// You could ad filters here to only show some of the financial data.
    List<TagFilter> filters = [];
    return FinanceClient().getDeploymentCost(filters);
  }
}

import 'package:test/test.dart';
import 'package:app_shared/client.dart';

import '../utils.dart';

void main() {
  group('Messages JSON Tests', () {
    test('(De)Serializes JSON As Expected', () {
      testJson(
        ctor: () => GetMetaRequest(),
        fromJson: GetMetaRequest.fromJson,
      );

      testJson(
        ctor: () => GetMetaResponse(
            meta: DeploymentCost(
          DateTime.now().add(Duration(days: -1)),
          DateTime.now(),
          [ServiceCost('test', 42, 'USD', ServiceCostType.actual)],
        )),
        fromJson: GetMetaResponse.fromJson,
      );

      testJson(
        ctor: () => GetTodosRequest(),
        fromJson: GetTodosRequest.fromJson,
      );

      testJson(
        ctor: () => GetTodosResponse(
          todos: [Todo(key: 'test', content: 'testing')],
          token: 'paging_token',
        ),
        fromJson: GetTodosResponse.fromJson,
      );

      testJson(
        ctor: () => WriteTodosRequest(
          todos: [Todo(key: 'test', content: 'testing')],
        ),
        fromJson: WriteTodosRequest.fromJson,
      );

      testJson(
        ctor: () => WriteTodosResponse(),
        fromJson: WriteTodosResponse.fromJson,
      );

      testJson<WriteTodosResponse>(
        ctor: () => WriteTodosResponse(
          failedKeys: ['test'],
          error: true,
          messages: ['Failed to write'],
        ),
        fromJson: WriteTodosResponse.fromJson,
        expects: (ctor, json) {
          expect(ctor.failedKeys, equals(json.failedKeys));
        },
      );

      testJson(
        ctor: () => DeleteTodosRequest(todoKeys: ['test']),
        fromJson: DeleteTodosRequest.fromJson,
      );

      testJson(
        ctor: () => DeleteTodosResponse(failedKeys: ['test']),
        fromJson: DeleteTodosResponse.fromJson,
      );

      testJson(
        ctor: () => DeleteTodosResponse(),
        fromJson: DeleteTodosResponse.fromJson,
      );
    });
  });
}

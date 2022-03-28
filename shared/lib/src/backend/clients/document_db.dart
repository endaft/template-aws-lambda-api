import 'package:collection/collection.dart';
import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';

import 'dynamo_mapper.dart';
import '../../models/all.dart';
import '../../messages/all.dart';

class DocumentDbClient {
  /// The default number of items returned from a query
  static const defaultItemCount = 20;

  static const pKSuffixTodos = "todos";
  static const tableDataName = "data";
  static const tablePKName = "pk";
  static const tableSKName = "sk";

  late DynamoDB _dynamo;
  final String tableName;

  DocumentDbClient({required this.tableName, required String region}) {
    _dynamo = DynamoDB(region: region);
  }

  Future<QueryOutput> _pagedUserQuery(
      {required String userId,
      required String pkSuffix,
      required String? token,
      int count = defaultItemCount}) async {
    var startKey = getStartKeyFromToken(token, tablePKName, tableSKName);
    return _dynamo.query(
        limit: count,
        tableName: tableName,
        exclusiveStartKey: startKey,
        attributesToGet: [
          tablePKName,
          tableSKName,
          tableDataName
        ],
        keyConditions: {
          tablePKName: Condition(
              comparisonOperator: ComparisonOperator.eq,
              attributeValueList: [AttributeValue(s: "$userId-$pkSuffix")])
        });
  }

  Future<GetTodosResponse> readTodos(String userId,
      {int count = defaultItemCount, String? token}) async {
    try {
      var result = await _pagedUserQuery(
          userId: userId, pkSuffix: pKSuffixTodos, token: token);
      return GetTodosResponse(
          todos: result.items
                  ?.map((e) => recordDataToJson(e, tableDataName))
                  .whereNotNull()
                  .map((e) => Todo.fromJson(e))
                  .toList() ??
              <Todo>[],
          token: getTokenFromStartKey(result.lastEvaluatedKey));
    } catch (error, stackTrace) {
      throw TodoError(Error.safeToString(error), stackTrace);
    }
  }

  Future<WriteTodosResponse> writeTodos(String userId, List<Todo> data) async {
    try {
      var results = await _dynamo.batchWriteItem(requestItems: {
        tableName: data
            .map((e) => WriteRequest(
                putRequest: PutRequest(item: denormalizeMap(e.toJson()))))
            .toList()
      });
      return WriteTodosResponse(
        failedKeys: results.unprocessedItems?.values.flattened
                .map((e) => e.putRequest?.item[tableSKName]?.s)
                .whereNotNull()
                .toList() ??
            [],
      );
    } catch (error, stackTrace) {
      throw TodoError(Error.safeToString(error), stackTrace);
    }
  }

  Future<DeleteTodosResponse> deleteTodos(
      String userId, List<String> todoKeys) async {
    try {
      var results = await _dynamo.batchWriteItem(requestItems: {
        tableName: todoKeys
            .map((e) => WriteRequest(
                deleteRequest: DeleteRequest(
                    key: makeFullKey(tablePKName, tableSKName,
                        "$userId-$pKSuffixTodos", e))))
            .toList()
      });
      return DeleteTodosResponse(
        failedKeys: results.unprocessedItems?.values.flattened
                .map((e) => e.deleteRequest?.key[tableSKName]?.s)
                .whereNotNull()
                .toList() ??
            [],
      );
    } catch (error, stackTrace) {
      throw TodoError(Error.safeToString(error), stackTrace);
    }
  }
}

import 'package:test/test.dart';
import 'package:app_shared/client.dart';

import '../utils.dart';

void main() {
  group('Models JSON Tests', () {
    test('(De)Serializes JSON As Expected', () {
      var strings = createWord(count: 50).split(' ');

      testJson(
        ctor: () {
          return DeploymentCost(
              DateTime.now(),
              DateTime.now().add(const Duration(days: 5)),
              [ServiceCost(strings.first, 2, 'foo', ServiceCostType.actual)]);
        },
        fromJson: DeploymentCost.fromJson,
      );

      testJson(
        ctor: () => ServiceCost(
          strings.first,
          2,
          'foo',
          ServiceCostType.actual,
        ),
        fromJson: ServiceCost.fromJson,
      );

      testJson(
        ctor: () {
          return TagFilter('Name', ['my-great-app'], caseSensitive: true);
        },
        fromJson: TagFilter.fromJson,
      );

      testJson(
        ctor: () => Todo(
          key: 'test',
          content: 'testing contracts',
          dueDate: DateTime.now(),
        ),
        fromJson: Todo.fromJson,
      );
    });
  });
}

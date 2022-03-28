import 'package:endaft_core/extras.dart';

import '../models/todo.dart' show Todo;

DateTime? _maybeRandomDate(RandomNumber rndNum, RandomBool rndBool) {
  if (!rndBool()) return null;

  var date = DateTime.now();
  var daysOffset = rndBool() ? rndNum(0, 90) : -rndNum(0, 90);
  date = date.add(Duration(days: daysOffset));

  return date;
}

Todo _makeRandomTodo(int index, RandomNumber rndNum, RandomBool rndBool) {
  final key =
      List<String>.generate(20, (index) => rndNum(0, 9).toString()).join('');
  DateTime? maybeDueDate = _maybeRandomDate(rndNum, rndBool);
  return Todo(
    key: key,
    content: createWord(count: rndNum(4, 6)),
    dueDate: maybeDueDate,
  );
}

List<Todo> makeFakeTodos({int count = 20}) {
  return makeFakes<Todo>(factory: _makeRandomTodo, count: count);
}

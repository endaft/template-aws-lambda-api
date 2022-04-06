import 'package:endaft/endaft.dart' as endaft;

final logger = endaft.Logger();

Future<bool> check() async {
  return endaft.CheckCommand(logger).run();
}

Future<bool> validate() async {
  return endaft.CheckCommand(logger).run();
}

Future<bool> test() async {
  return endaft.TestCommand(logger).run();
}

Future<bool> shared() async {
  return endaft.SharedCommand(logger).run();
}

Future<bool> docker() async {
  return endaft.DockerCommand(logger).run();
}

Future<bool> aggregate() async {
  return endaft.AggregateCommand(logger).run();
}

void main() async {
  List<endaft.WorkerFunc> sequence = [
    check,
    validate,
    test,
    shared,
    docker,
    aggregate,
  ];
  for (var task in sequence) {
    final result = await task();
    if (!result) break;
  }
}

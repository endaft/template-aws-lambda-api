import 'package:endaft/endaft.dart' as endaft;

final logger = endaft.Logger();

Future<void> check() async {
  await endaft.CheckCommand(logger).run();
}

Future<void> test() async {
  await endaft.TestCommand(logger).run();
}

Future<void> build() async {
  await endaft.BuildCommand(logger).run();
}

Future<void> aggregate() async {
  await endaft.AggregateCommand(logger).run();
}

void main() async {
  await check();
  await test();
  await build();
  await aggregate();
}

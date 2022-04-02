import 'package:endaft/endaft.dart' as endaft;

final logger = endaft.Logger();

Future<void> check() async {
  await endaft.CheckCommand(logger).run();
}

Future<void> install() async {
  print('The template installer');
  // Add references to 'shared'
  // Run 'dart pub get'
}

void main() async {
  await check();
  await install();
}

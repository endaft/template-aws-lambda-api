import 'package:endaft_core/common.dart';

class TodoError extends AppError {
  TodoError(String message, [StackTrace? stackTrace])
      : super(message, stackTrace);
}

class FinanceError extends AppError {
  FinanceError(String message, [StackTrace? stackTrace])
      : super(message, stackTrace);
}

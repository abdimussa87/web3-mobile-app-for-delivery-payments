import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    colors: false,
  ),
);
void logPrint(dynamic value) {
  logger.i(value);
}

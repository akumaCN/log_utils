part of '../log_utils_lib.dart';

final class LogPrint extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      print(line);
    }
  }
}

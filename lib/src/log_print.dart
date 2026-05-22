part of '../log_utils_lib.dart';

typedef LogLineWriter = void Function(String line);

final class LogPrint extends LogOutput {
  LogPrint({
    LogLineWriter? writer,
    this.wrapWidth = 1024,
  }) : _writer = writer;

  final LogLineWriter? _writer;
  final int wrapWidth;

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      final writer = _writer;
      if (writer != null) {
        writer(line);
        continue;
      }

      debugPrint(line, wrapWidth: wrapWidth);
    }
  }
}

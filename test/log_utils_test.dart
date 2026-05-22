import 'package:flutter_test/flutter_test.dart';
import 'package:log_utils_plus/log_utils_lib.dart';
import 'package:logger/logger.dart' show Logger;

void main() {
  late List<OutputEvent> outputEvents;
  late void Function(OutputEvent) outputListener;

  setUp(() {
    outputEvents = <OutputEvent>[];
    outputListener = outputEvents.add;
    Logger.addOutputListener(outputListener);
    LogUtils.resetConfiguration();
  });

  tearDown(() {
    Logger.removeOutputListener(outputListener);
    LogUtils.resetConfiguration();
  });

  test('emits debug logs by default', () {
    LogUtils.d('hello');

    expect(outputEvents, hasLength(1));
    expect(outputEvents.single.level, Level.debug);
    expect(outputEvents.single.lines.join('\n'), contains('hello'));
  });

  test('respects level filtering', () {
    LogUtils.setLevel(Level.error);

    LogUtils.d('skip me');
    LogUtils.e('keep me');

    expect(outputEvents, hasLength(1));
    expect(outputEvents.single.level, Level.error);
    expect(outputEvents.single.lines.join('\n'), contains('keep me'));
  });

  test('disable and enable control all logging', () {
    LogUtils.disable();
    LogUtils.i('hidden');
    expect(outputEvents, isEmpty);

    LogUtils.enable();
    LogUtils.i('visible again');
    expect(outputEvents, hasLength(1));
    expect(outputEvents.single.lines.join('\n'), contains('visible again'));
  });

  test('logTimeEvent returns elapsed duration for the same key', () {
    var tick = 0;
    final base = DateTime(2026, 1, 1, 10, 0, 0);
    LogUtils.configure(
      nowProvider: () => base.add(Duration(milliseconds: tick)),
      printEmojis: false,
      colors: false,
    );

    final first = LogUtils.logTimeEvent('first', key: 'network');
    tick = 275;
    final second = LogUtils.logTimeEvent('second', key: 'network');

    expect(first, Duration.zero);
    expect(second, const Duration(milliseconds: 275));
    expect(outputEvents, hasLength(2));
    expect(outputEvents.last.lines.join('\n'),
        contains('[network] second (+275ms)'));
  });

  test('resetTime clears a single timing key', () {
    var tick = 0;
    final base = DateTime(2026, 1, 1, 10, 0, 0);
    LogUtils.configure(
      nowProvider: () => base.add(Duration(milliseconds: tick)),
      printEmojis: false,
      colors: false,
    );

    LogUtils.logTimeEvent('first', key: 'db');
    tick = 120;
    LogUtils.resetTime(key: 'db');
    final elapsed = LogUtils.logTimeEvent('after reset', key: 'db');

    expect(elapsed, Duration.zero);
    expect(outputEvents.last.lines.join('\n'),
        contains('[db] after reset (+0ms)'));
  });
}

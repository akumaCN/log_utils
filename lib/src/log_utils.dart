part of '../log_utils_lib.dart';
class LogUtils {
  LogUtils._();
  static final Logger _instance = _createLogger();
  static final Logger _printTimeInstance = _createLogger(printTime: true);

  static final ProductionFilter _filter = ProductionFilter();

  /// Change the log level
  static void setLevel(Level newLevel) {
    _filter.level = newLevel;
  }

  /// Disable all logging
  static void disable() {
    _filter.level = Level.off;
  }

  /// Enable all logging
  static void enable() {
    _filter.level = Level.all;
  }

  ///创建日志实例
  static Logger _createLogger({bool printTime = false}) {
    return Logger(
      printer: PrettyPrinter(
        methodCount: printTime ? 2 : 0,
        errorMethodCount: 10, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        dateTimeFormat: printTime ? DateTimeFormat.onlyTime : DateTimeFormat.none,
        excludeBox: {
          Level.trace: true,
          Level.debug: true,
          Level.info: true,
          Level.warning: false,
          Level.error: false,
          Level.fatal: false,
        },
        levelColors: {
          Level.trace: AnsiColor.fg(AnsiColor.grey(0.5)),
          Level.debug: const AnsiColor.fg(28),
          Level.info: const AnsiColor.fg(32),
          Level.warning: const AnsiColor.fg(214),
          Level.error: const AnsiColor.fg(196),
          Level.fatal: const AnsiColor.fg(199),
        },
        levelEmojis: {
          Level.trace: "🔍",
          Level.debug: "🛠️",
          Level.info: "💡",
          Level.warning: "⚠️",
          Level.error: "💣",
          Level.fatal: "☠️",
        },
      ),
      filter: _filter, // Use in production to filter logs
      output: LogPrint(),
    );
  }

  static Logger _getLogger(DateTime? time) {
    if (time != null) {
      return _printTimeInstance;
    } else {
      return _instance;
    }
  }

  /// Log a verbose message.
  static void t(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _getLogger(time).t(message, time: time, error: error, stackTrace: stackTrace);
  }

  /// Log a debug message.
  static void d(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _getLogger(time).d(message, time: time, error: error, stackTrace: stackTrace);
  }

  /// Log an info message.
  static void i(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _getLogger(time).i(message, time: time, error: error, stackTrace: stackTrace);
  }

  /// Log a warning message.
  static void w(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _getLogger(time).w(message, time: time, error: error, stackTrace: stackTrace);
  }

  /// Log an error message.
  static void e(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _getLogger(time).e(message, time: time, error: error, stackTrace: stackTrace);
  }

  static void f(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _getLogger(time).f(message, time: time, error: error, stackTrace: stackTrace);
  }

  static final Map<String, int> _lastPrintTimes = {};
  static const String _defaultKey = "_default";

  /// 重置某个 key 的时间（默认全局）
  static void resetTime({String? key}) {
    _lastPrintTimes[key ?? _defaultKey] = 0;
  }

  /// 记录时间事件
  static void logTimeEvent(
    dynamic message, {
    String? key,
    bool printTime = false,
  }) {
    final k = key ?? _defaultKey;
    int interval = 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (_lastPrintTimes.containsKey(k) && _lastPrintTimes[k] != 0) {
      interval = currentTime - (_lastPrintTimes[k] ?? 0);
    }

    _lastPrintTimes[k] = currentTime;
    d("[$k] logTimeEvent:$message => $interval", time: printTime ? DateTime.now() : null);
  }
}

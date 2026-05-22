part of '../log_utils_lib.dart';

class LogUtils {
  LogUtils._();

  static final ProductionFilter _filter = ProductionFilter();
  static final Map<String, DateTime> _lastPrintTimes = {};

  static const String _defaultKey = '_default';
  static const int _defaultLineLength = 120;
  static const int _defaultMethodCount = 0;
  static const int _defaultTimedMethodCount = 2;
  static const int _defaultErrorMethodCount = 10;

  static bool _colors = true;
  static bool _printEmojis = true;
  static int _lineLength = _defaultLineLength;
  static int _methodCount = _defaultMethodCount;
  static int _timedMethodCount = _defaultTimedMethodCount;
  static int _errorMethodCount = _defaultErrorMethodCount;
  static LogOutput _output = LogPrint();
  static DateTime Function() _nowProvider = DateTime.now;
  static Map<Level, AnsiColor> _levelColors = {
    Level.trace: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: const AnsiColor.fg(28),
    Level.info: const AnsiColor.fg(32),
    Level.warning: const AnsiColor.fg(214),
    Level.error: const AnsiColor.fg(196),
    Level.fatal: const AnsiColor.fg(199),
  };
  static Map<Level, String> _levelEmojis = {
    Level.trace: '🔍',
    Level.debug: '🛠️',
    Level.info: '💡',
    Level.warning: '⚠️',
    Level.error: '💣',
    Level.fatal: '☠️',
  };

  static Logger _instance = _createLogger();
  static Logger _printTimeInstance = _createLogger(printTime: true);

  static Level get level => _filter.level ?? Logger.level;
  static bool get isEnabled => level != Level.off;

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

  /// Updates logger behavior without changing the static calling style.
  static void configure({
    Level? level,
    LogOutput? output,
    bool? colors,
    bool? printEmojis,
    int? lineLength,
    int? methodCount,
    int? timedMethodCount,
    int? errorMethodCount,
    DateTime Function()? nowProvider,
    Map<Level, AnsiColor>? levelColors,
    Map<Level, String>? levelEmojis,
  }) {
    if (output != null) {
      _output = output;
    }
    if (colors != null) {
      _colors = colors;
    }
    if (printEmojis != null) {
      _printEmojis = printEmojis;
    }
    if (lineLength != null) {
      _lineLength = lineLength;
    }
    if (methodCount != null) {
      _methodCount = methodCount;
    }
    if (timedMethodCount != null) {
      _timedMethodCount = timedMethodCount;
    }
    if (errorMethodCount != null) {
      _errorMethodCount = errorMethodCount;
    }
    if (nowProvider != null) {
      _nowProvider = nowProvider;
    }
    if (levelColors != null) {
      _levelColors = Map<Level, AnsiColor>.from(levelColors);
    }
    if (levelEmojis != null) {
      _levelEmojis = Map<Level, String>.from(levelEmojis);
    }

    _rebuildLoggers();
    if (level != null) {
      setLevel(level);
    }
  }

  /// Restores the default logger configuration.
  static void resetConfiguration() {
    _colors = true;
    _printEmojis = true;
    _lineLength = _defaultLineLength;
    _methodCount = _defaultMethodCount;
    _timedMethodCount = _defaultTimedMethodCount;
    _errorMethodCount = _defaultErrorMethodCount;
    _output = LogPrint();
    _nowProvider = DateTime.now;
    _levelColors = {
      Level.trace: AnsiColor.fg(AnsiColor.grey(0.5)),
      Level.debug: const AnsiColor.fg(28),
      Level.info: const AnsiColor.fg(32),
      Level.warning: const AnsiColor.fg(214),
      Level.error: const AnsiColor.fg(196),
      Level.fatal: const AnsiColor.fg(199),
    };
    _levelEmojis = {
      Level.trace: '🔍',
      Level.debug: '🛠️',
      Level.info: '💡',
      Level.warning: '⚠️',
      Level.error: '💣',
      Level.fatal: '☠️',
    };
    _filter.level = Logger.level;
    _lastPrintTimes.clear();
    _rebuildLoggers();
  }

  static void _rebuildLoggers() {
    _instance = _createLogger();
    _printTimeInstance = _createLogger(printTime: true);
  }

  /// Creates a logger instance with the current package configuration.
  static Logger _createLogger({bool printTime = false}) {
    return Logger(
      printer: PrettyPrinter(
        methodCount: printTime ? _timedMethodCount : _methodCount,
        errorMethodCount: _errorMethodCount,
        lineLength: _lineLength,
        colors: _colors,
        printEmojis: _printEmojis,
        dateTimeFormat:
            printTime ? DateTimeFormat.onlyTime : DateTimeFormat.none,
        excludeBox: {
          Level.trace: true,
          Level.debug: true,
          Level.info: true,
          Level.warning: false,
          Level.error: false,
          Level.fatal: false,
        },
        levelColors: _levelColors,
        levelEmojis: _levelEmojis,
      ),
      filter: _filter,
      output: _output,
    );
  }

  static Logger _getLogger(DateTime? time) {
    return time != null ? _printTimeInstance : _instance;
  }

  /// Logs a message at a specific level.
  static void log(
    Level level,
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _getLogger(time).log(
      level,
      message,
      time: time,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a verbose message.
  static void t(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    log(Level.trace, message, time: time, error: error, stackTrace: stackTrace);
  }

  /// Log a debug message.
  static void d(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    log(Level.debug, message, time: time, error: error, stackTrace: stackTrace);
  }

  /// Log an info message.
  static void i(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    log(Level.info, message, time: time, error: error, stackTrace: stackTrace);
  }

  /// Log a warning message.
  static void w(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    log(Level.warning, message,
        time: time, error: error, stackTrace: stackTrace);
  }

  /// Log an error message.
  static void e(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    log(Level.error, message, time: time, error: error, stackTrace: stackTrace);
  }

  static void f(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    log(Level.fatal, message, time: time, error: error, stackTrace: stackTrace);
  }

  /// Resets the last timestamp for a specific key.
  static void resetTime({String? key}) {
    _lastPrintTimes.remove(key ?? _defaultKey);
  }

  /// Clears all timing checkpoints.
  static void resetAllTimes() {
    _lastPrintTimes.clear();
  }

  /// Records a time checkpoint and returns the elapsed duration.
  static Duration logTimeEvent(
    dynamic message, {
    String? key,
    bool printTime = false,
    Level level = Level.debug,
  }) {
    final resolvedKey = (key == null || key.trim().isEmpty) ? _defaultKey : key;
    final currentTime = _nowProvider();
    final previousTime = _lastPrintTimes[resolvedKey];
    final interval = previousTime == null
        ? Duration.zero
        : currentTime.difference(previousTime);

    _lastPrintTimes[resolvedKey] = currentTime;

    log(
      level,
      '[$resolvedKey] $message (+${interval.inMilliseconds}ms)',
      time: printTime ? currentTime : null,
    );

    return interval;
  }
}

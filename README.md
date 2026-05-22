# log_utils_plus

A lightweight Flutter logging utility built on top of [`logger`](https://pub.dev/packages/logger).

`log_utils_plus` keeps the simple static API of `LogUtils.d/i/w/e/f`, while adding runtime configuration, level control, and lightweight timing checkpoints for debugging and performance tracing.

## Features

- Simple static logging API
- Runtime log level control
- Custom output and style configuration
- Timing checkpoints with `logTimeEvent()`
- Works well for app debugging and lightweight profiling

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  log_utils_plus: ^1.2.0
```

Import it in your code:

```dart
import 'package:log_utils_plus/log_utils_lib.dart';
```

## Quick start

Basic logging:

```dart
LogUtils.d('debug message');
LogUtils.i('login success');
LogUtils.w('cache is stale');
LogUtils.e(
  'request failed',
  error: exception,
  stackTrace: stackTrace,
);
```

Control log level:

```dart
LogUtils.setLevel(Level.warning);

LogUtils.d('this will be ignored');
LogUtils.w('this will still be printed');

LogUtils.disable();
LogUtils.enable();
```

## Configuration

Customize logger behavior at runtime:

```dart
LogUtils.configure(
  colors: false,
  printEmojis: false,
  lineLength: 100,
  output: LogPrint(
    writer: (line) {
      print(line);
    },
  ),
);
```

Reset to defaults:

```dart
LogUtils.resetConfiguration();
```

## Timing checkpoints

Use `logTimeEvent()` to track elapsed time between checkpoints with the same key:

```dart
LogUtils.logTimeEvent('fetch profile start', key: 'profile');

// do something

final elapsed = LogUtils.logTimeEvent(
  'fetch profile finish',
  key: 'profile',
  printTime: true,
);

print('elapsed: ${elapsed.inMilliseconds}ms');
```

Reset a single key or all keys:

```dart
LogUtils.resetTime(key: 'profile');
LogUtils.resetAllTimes();
```

## API overview

- `LogUtils.t()` trace log
- `LogUtils.d()` debug log
- `LogUtils.i()` info log
- `LogUtils.w()` warning log
- `LogUtils.e()` error log
- `LogUtils.f()` fatal log
- `LogUtils.log()` generic level-based logging
- `LogUtils.configure()` update logger configuration
- `LogUtils.resetConfiguration()` restore default configuration
- `LogUtils.logTimeEvent()` record and return elapsed time

## Repository

- Homepage: [https://github.com/akumaCN/log_utils](https://github.com/akumaCN/log_utils)
- Repository: [https://github.com/akumaCN/log_utils](https://github.com/akumaCN/log_utils)

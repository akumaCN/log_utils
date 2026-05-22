# log_utils

`log_utils` 是一个基于 [`logger`](https://pub.dev/packages/logger) 封装的 Flutter 日志工具，保留简单的静态调用方式，同时补上了常用的级别控制、输出配置和耗时打点能力。

## Features

- 直接使用 `LogUtils.d/i/w/e/f` 输出日志
- 支持 `setLevel`、`disable`、`enable` 控制日志级别
- 支持 `configure` 自定义颜色、emoji、输出目标和时间提供器
- 内置 `logTimeEvent`，可记录同一 key 的间隔耗时
- 适合调试期和业务埋点式日志场景

## Getting started

在 `pubspec.yaml` 中引入：

```yaml
dependencies:
  log_utils:
    git:
      url: https://github.com/akumaCN/log_utils.git
```

然后在代码中导入：

```dart
import 'package:log_utils/log_utils_lib.dart';
```

## Usage

基础日志：

```dart
LogUtils.d('debug message');
LogUtils.i('user login success');
LogUtils.w('cache is stale');
LogUtils.e('request failed', error: exception, stackTrace: stackTrace);
```

控制日志级别：

```dart
LogUtils.setLevel(Level.warning);

LogUtils.d('this will be ignored');
LogUtils.w('this will still be printed');

LogUtils.disable();
LogUtils.enable();
```

自定义输出与样式：

```dart
LogUtils.configure(
  colors: false,
  printEmojis: false,
  output: LogPrint(
    writer: (line) {
      // 写入本地文件、上报平台或自定义控制台
      print(line);
    },
  ),
);
```

记录耗时：

```dart
LogUtils.logTimeEvent('fetch profile start', key: 'profile');

// ... do something

final elapsed = LogUtils.logTimeEvent(
  'fetch profile finish',
  key: 'profile',
  printTime: true,
);

print('elapsed: ${elapsed.inMilliseconds}ms');
```

## API notes

- `logTimeEvent` 首次调用会返回 `Duration.zero`
- `resetTime(key: ...)` 会清除单个计时 key
- `resetAllTimes()` 会清空全部计时状态
- `resetConfiguration()` 会恢复默认日志配置

# log_utils_plus

一个基于 [`logger`](https://pub.dev/packages/logger) 封装的 Flutter 日志工具。

`log_utils_plus` 保留了简单直接的 `LogUtils.d/i/w/e/f` 静态调用方式，同时补充了运行时配置、日志级别控制和轻量级耗时打点能力，适合日常调试、问题排查和简单性能追踪。

[English README](README.md)

## 功能特性

- 简单易用的静态日志 API
- 支持运行时调整日志级别
- 支持自定义输出方式和显示风格
- 支持通过 `logTimeEvent()` 记录耗时打点
- 适合业务调试和轻量性能分析

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  log_utils_plus: ^1.2.0
```

然后在代码中导入：

```dart
import 'package:log_utils_plus/log_utils_lib.dart';
```

## 快速开始

基础日志：

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

控制日志级别：

```dart
LogUtils.setLevel(Level.warning);

LogUtils.d('this will be ignored');
LogUtils.w('this will still be printed');

LogUtils.disable();
LogUtils.enable();
```

## 配置能力

你可以在运行时修改日志行为：

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

恢复默认配置：

```dart
LogUtils.resetConfiguration();
```

## 耗时打点

你可以使用 `logTimeEvent()` 对同一个 key 做前后打点，并拿到两次之间的耗时：

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

重置单个 key 或全部打点状态：

```dart
LogUtils.resetTime(key: 'profile');
LogUtils.resetAllTimes();
```

## API 一览

- `LogUtils.t()` 输出 trace 日志
- `LogUtils.d()` 输出 debug 日志
- `LogUtils.i()` 输出 info 日志
- `LogUtils.w()` 输出 warning 日志
- `LogUtils.e()` 输出 error 日志
- `LogUtils.f()` 输出 fatal 日志
- `LogUtils.log()` 通用级别日志输出
- `LogUtils.configure()` 修改日志配置
- `LogUtils.resetConfiguration()` 恢复默认配置
- `LogUtils.logTimeEvent()` 记录并返回耗时

## 仓库地址

- 首页：[https://github.com/akumaCN/log_utils](https://github.com/akumaCN/log_utils)
- 仓库：[https://github.com/akumaCN/log_utils](https://github.com/akumaCN/log_utils)

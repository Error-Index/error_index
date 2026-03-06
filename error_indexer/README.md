# error_indexer

A powerful, annotations-driven package that provides the runtime symbols needed to track, namespace, and aggregate error points across your entire Dart and Flutter project.

Used in conjunction with `error_indexer_generator`, it eliminates manual tracking of string-based error codes by extracting them directly from your source files into a single, strongly-typed registry.

## Installation

Add both the builder and the runtime package to your `pubspec.yaml`:

```yaml
dependencies:
  error_indexer: ^1.0.0

dev_dependencies:
  build_runner: ^2.4.8
  error_indexer_generator: ^1.0.0
```

## Setup

See the [error_indexer_generator README](https://pub.dev/packages/error_indexer_generator) for complete usage instructions and generation examples.

# error_indexer_generator

A robust `build_runner` generator designed to pair with the `error_indexer` runtime package. It statically analyzes your codebase to extract `@ErrorScope` and `@ErrorPoint` annotations, dynamically generating centralized, namespaced error registries that guarantee compile-time duplicate validation.

## Installation

Add both the builder and the runtime package to your `pubspec.yaml`:

```yaml
dependencies:
  error_indexer: ^1.0.0

dev_dependencies:
  build_runner: ^2.4.8
  error_indexer_generator: ^1.0.0
```

## How It Works

1. **Annotate your code** in your main app using the runtime package:
```dart
import 'package:error_indexer/error_indexer.dart';

@ErrorScope('PAY_REPO')
class PaymentRepository {
  @ErrorPoint('GET_METHODS')
  void getMethods() {}

  @ErrorPoint('PROCESS_PAY')
  void processPayment() {}
}
```

2. **Trigger the aggregation** by creating an initialization file (e.g. `lib/setup.dart`):

```dart
// lib/setup.dart
import 'package:error_indexer/error_indexer.dart';
import 'setup.error.dart'; // This will be automatically generated!

/// You can customize the generated class name suffix if you want:
/// @ErrorIndexInit(classSuffix: 'Registry')
@ErrorIndexInit()
void configureErrorRegistry() {
  print('Ready to use generated Error Index!');
}
```

3. **Run your builder** using the standard dart build tool:

```sh
dart run build_runner build -d
```

4. **Verify the Output** inside `lib/setup.error.dart`:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:error_indexer/error_indexer.dart';

abstract class PaymentRepositoryErrorIndex {
  PaymentRepositoryErrorIndex._();

  static const getMethods = ErrorMetadata(
    scopeCode: 'PAY_REPO',
    pointCode: 'GET_METHODS',
    className: 'PaymentRepository',
    methodName: 'getMethods',
  );

  static const processPayment = ErrorMetadata(
    scopeCode: 'PAY_REPO',
    pointCode: 'PROCESS_PAY',
    className: 'PaymentRepository',
    methodName: 'processPayment',
  );
}
```

### Compile-Time Duplicate Validation
If two distinct methods across your repository declare the exact same `['SCOPE_CODE']` and `['POINT_CODE']`, the generator will **halt the build** and print a strictly guided exception detailing exactly which class and method caused the collision.

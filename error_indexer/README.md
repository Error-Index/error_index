# error_indexer

[![Pub Version](https://img.shields.io/pub/v/error_indexer.svg)](https://pub.dev/packages/error_indexer)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A powerful, annotations-driven package that provides the runtime symbols needed to track, namespace, and aggregate error points across your entire Dart and Flutter project.

Used in conjunction with `error_indexer_generator`, it completely eliminates manual tracking of string-based error codes. By simply annotating your classes and methods, the generator extracts them directly from your source files into a single, strongly-typed registry with guaranteed compile-time uniqueness validation.

---

## 🚀 Why Use `error_indexer`?

Modern architectural designs (like Clean Architecture) often heavily decouple error generation from the presentation layer. When tracking analytic events, crash logs, or API failure payloads, developers end up maintaining huge, fragile files full of hardcoded string constants like `'AUTH_LOGIN_FAILED'` or `'PAYMENT_TIMEOUT'`.

**`error_indexer` solves this by flipping the paradigm.**

Instead of maintaining a massive centralized file yourself, **you define the error context exactly where the error happens** utilizing simple annotations. The companion `error_indexer_generator` then magically finds them, extracts them, and assembles them into a beautiful typed registry tree perfectly integrated with your IDE's autocomplete.

### Key Benefits
* **Strongly Typed**: No more typos in error string matching. Access errors via constants like `AuthRepositoryErrorIndex.login`.
* **Zero Duplication Guarantee**: If two developers accidentally use the exact same `"SCOPE_CODE"` / `"POINT_CODE"` combination, the builder immediately crashes and refuses to compile, pointing directly to the file at fault.
* **Namespaced Output**: Group errors automatically based on their origin class.
* **Maintainable**: The definition of an error lives right on top of the method that throws it. No context swapping!

---

## 📦 Installation

Add both the runtime package and the code generator to your `pubspec.yaml`:

```yaml
dependencies:
  error_indexer: ^1.0.4

dev_dependencies:
  build_runner: ^2.4.0
  error_indexer_generator: ^1.0.4
```

*(Note: Always check for the latest versions on Pub)*

---

## 🛠 Setup & Usage

### 1. Annotate Your Code

Start by decorating the classes and functions in your application where distinct operations or failures can originate. Use `@ErrorScope` to define the domain, and `@ErrorPoint` to define the specific mechanism.

```dart
import 'package:error_indexer/error_indexer.dart';

@ErrorScope('PAY_REPO')
class PaymentRepository {
  @ErrorPoint('GET_METHODS')
  void getMethods() {
    // Operations...
  }

  @ErrorPoint('PROCESS_PAY')
  void processPayment() {
    // Operations...
  }
}

@ErrorScope('AUTH_REPO')
class AuthRepository {
  @ErrorPoint('LOGIN')
  void login() {
    // Operations...
  }
}
```

### 2. Configure The Output Target

Create a single file anywhere in your project (for example, `lib/error_setup.dart`). This file tells the generator where to collect and output all the aggregated nodes from your entire project.

By applying the `@ErrorIndexInit()` annotation, the generator will output a companion file named `<YOUR_FILE_NAME>.error.dart`!

```dart
// lib/error_setup.dart
import 'package:error_indexer/error_indexer.dart';

// The generator will create this file for you automatically:
import 'error_setup.error.dart'; 

/// Simply annotate any top-level element to trigger generation.
/// You can optionally customize the suffix of the generated classes.
@ErrorIndexInit(classSuffix: 'Registry')
void configureErrorRegistry() {
  print('Error Registry Initialized!');
}
```

### 3. Run Build Runner

Fire up `build_runner` to let the `error_indexer_generator` do its magic.

```bash
dart run build_runner build -d
```

### 4. Harness The Result

The builder will scan your entire codebase, aggregate the results, and generate the `<fileName>.error.dart` file automatically grouped by class:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:error_indexer/error_indexer.dart';

abstract class PaymentRepositoryRegistry {
  PaymentRepositoryRegistry._();

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

abstract class AuthRepositoryRegistry {
  AuthRepositoryRegistry._();

  // ... Extracted Metadata
}
```

Now, anywhere in your application, you can reference the exact failure contexts with full autocompletion safety:

```dart
try {
  paymentRepo.processPayment();
} catch (e) {
  final payload = {
    'error_domain': PaymentRepositoryRegistry.processPayment.scopeCode,
    'error_trigger': PaymentRepositoryRegistry.processPayment.pointCode,
    'message': e.toString(),
  };
  analyticsService.logError(payload);
}
```

---

## 🚫 The Duplicate Prevention Feature

The beauty of a centralized system paired with distributed code files is the **validation layer**.
If Developer A creates an error in `profile_repo.dart`:
```dart
@ErrorScope('USER')
class ProfileRepo {
  @ErrorPoint('INFO')
  void fetch() {}
}
```
And Developer B makes a pull request creating an error in `auth_repo.dart`:
```dart
@ErrorScope('USER')
class AuthRepo {
  @ErrorPoint('INFO')
  void authUser() {}
}
```

**The project will fail to build.**

The `error_indexer_generator` compiler will detect the `USER-INFO` hash collision during the aggregation phase and throw a fatal compilation error directly into the terminal, identifying exactly which class and method caused the overlap, guaranteeing that your analytics or error monitoring environments never receive ambiguous or overlapping tracker codes.

## 🤝 Contributing & Found Issues
Feel free to open an Issue or submit a Pull Request on our [GitHub Repository](https://github.com/Error-Index/error_index). All contributions are welcome!

## ✨ Contributors
Thank you to all the people who have contributed to this project:
- [divloopz](mailto:divloopz@gmail.com)
- [Ahmed Al-Kamel](mailto:ahmedalkamel.it@gmail.com)
- [Albukheiti](mailto:albukheiti@gmail.com)

# error_indexer_generator

[![Pub Version](https://img.shields.io/pub/v/error_indexer_generator.svg)](https://pub.dev/packages/error_indexer_generator)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A robust `build_runner` generator designed to pair directly with the [error_indexer](https://pub.dev/packages/error_indexer) runtime package. 

It implements a state-of-the-art **two-pass Extractor-Aggregator** pattern to statically analyze your entire codebase, extract your distributed `@ErrorScope` and `@ErrorPoint` annotations, and dynamically aggregate them into a single centralized, namespaced error registry file structure.

---

## ⚙️ How it Works Under the Hood

Unlike simple `.g.dart` generators which operate on a constrained 1-to-1 input/output file mapping, `error_indexer_generator` implements a far more complex system needed to aggregate data across an entire project:

1. **Extraction Phase (`error_indexer_extractor`)**: As a background worker, this builder silently scans every `.dart` file looking for our Error annotations. When it finds them, it caches fragmented metadata payloads into hidden `.error_index.json` intermediate records.
2. **Aggregation Phase (`error_indexer_aggregator`)**: This builder runs globally across the project. It explicitly seeks out the single `@ErrorIndexInit` annotation marker inside your codebase. Whenever found, it fetches the globally cached intermediate JSON fragments, validates them against constraints (e.g., hash collisions), and constructs the final compiled `abstract class` hierarchy within your output file.

---

## 📦 Installation

Add both the builder and the runtime package to your `pubspec.yaml`:

```yaml
dependencies:
  error_indexer: ^1.0.5

dev_dependencies:
  build_runner: ^2.4.0
  error_indexer_generator: ^1.0.5
```

*(Note: Always check for the latest versions on Pub)*

## 🛠 Complete Usage Instructions

Check out the full documentation, architecture breakdown, and usage examples on the companion [error_indexer Runtime Package README](https://pub.dev/packages/error_indexer).

---

## 🤝 Contributing
Feel free to open an Issue or submit a Pull Request on our [GitHub Repository](https://github.com/Error-Index/error_index) if you find bugs or have feature improvement ideas!

## ✨ Main Contributors
Thank you to all the people who have contributed to this project:

| ![divloopz](https://avatars.githubusercontent.com/u/244216080?v=4&s=200) | ![Ahmed Al-Kamel](https://avatars.githubusercontent.com/u/109754192?v=4&s=200) | ![Albukheiti](https://avatars.githubusercontent.com/u/101047629?v=4&s=200) | 
|:------------------------------------------------------------------------:|:------------------------------------------------------------------------------:|:--------------------------------------------------------------------------:|
|                 [divloopz](https://github.com/divloopz)                  |               [Ahmed Al-Kamel](https://github.com/Ahmed-Alkamel)               |                [Albukheiti](https://github.com/albukheity)                 |


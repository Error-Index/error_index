## 1.0.5
- Added support for generating custom separators defined in `@ErrorIndexInit`.
- Inject original `filePath` as comment in generation to track source file properly.
- Inject `fullErrorCode` as comment above generated variables.

## 1.0.3

- **Compatibility**: Broadened constraints for `analyzer` (`>=5.12.0 <11.0.0`), `source_gen`, and `build` to fix breaking conflicts with tools relying on older analyzer versions (like `retrofit_generator <14.0.0`).

## 1.0.2

- **Dependencies**: Bumps `analyzer`, `build`, and `source_gen` to latest versions.
- **Fix**: Updated `formatOutput` parameter signature for compatibility with `source_gen ^4.1.1`.

## 1.0.1

- **Docs**: Overhauled `README.md` and added clear usage documentation.

## 1.0.0

- Initial release.
- Incorporates robust a two-pass architecture (Extractor and Aggregator) to assemble JSON files project-wide before generating strongly-typed metadata nodes inside a `.error.dart` endpoint file dynamically based on `@ErrorIndexInit`.

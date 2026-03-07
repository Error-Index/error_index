import 'dart:async';
import 'dart:convert';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart';

const _initChecker = TypeChecker.fromUrl(
  'package:error_indexer/src/annotations.dart#ErrorIndexInit',
);

/// Step 2: Aggregates all `.error_index.json` files and generates `<filename>.error.dart`.
class ErrorIndexerAggregator extends Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        // Output a .error.dart file next to the annotated file
        '.dart': ['.error.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Check if THIS specific file has @ErrorIndexInit
    final resolver = buildStep.resolver;
    if (!await resolver.isLibrary(buildStep.inputId)) return;
    final library = await resolver.libraryFor(buildStep.inputId);

    // Check top-level elements and classes for @ErrorIndexInit
    bool hasInitAnnotation = false;
    String classSuffix = 'ErrorIndex'; // Default suffix
    String separator = '-'; // Default separator

    final libraryReader = LibraryReader(library);
    for (var element in libraryReader.allElements) {
      if (_initChecker.hasAnnotationOfExact(element)) {
        hasInitAnnotation = true;

        final annotation = _initChecker.firstAnnotationOfExact(element);
        if (annotation != null) {
          final reader = ConstantReader(annotation);
          final suffixValue = reader.read('classSuffix');
          if (!suffixValue.isNull) {
            classSuffix = suffixValue.stringValue;
          }
          final separatorValue = reader.read('separator');
          if (!separatorValue.isNull) {
            separator = separatorValue.stringValue;
          }
        }
        break;
      }
    }

    if (!hasInitAnnotation) return;

    final results = <Map<String, dynamic>>[];
    final knownCodes = <String>{};

    // Find all files matching the '.error_index.json' extension
    final assets = buildStep.findAssets(Glob('**/*.error_index.json'));

    await for (final id in assets) {
      final content = await buildStep.readAsString(id);
      if (content.isEmpty) continue;

      final cleanContent = content
          .split('\n')
          .where((line) => !line.trimLeft().startsWith('//'))
          .join('\n');

      if (cleanContent.trim().isEmpty) continue;

      final List<dynamic> jsonList = jsonDecode(cleanContent);

      for (var item in jsonList) {
        final mapItem = item as Map<String, dynamic>;
        final scopeCode = mapItem['scopeCode'] as String;
        final pointCode = mapItem['pointCode'] as String;
        final fullCode = '$scopeCode$separator$pointCode';

        // STRICT Validation: duplicate check
        if (knownCodes.contains(fullCode)) {
          throw InvalidGenerationSourceError(
            'Duplicate Full Error Code found: "$fullCode" in class ${mapItem['className']} method ${mapItem['methodName']}. Full code must be unique across the project.',
          );
        }
        knownCodes.add(fullCode);
        results.add(mapItem);
      }
    }

    if (results.isEmpty) return;

    // Sort by class name, then method name to group them logically
    results.sort((a, b) {
      int classCompare = (a['className'] as String).compareTo(
        b['className'] as String,
      );
      if (classCompare != 0) return classCompare;
      return (a['methodName'] as String).compareTo(b['methodName'] as String);
    });

    // Group by className
    final Map<String, List<Map<String, dynamic>>> groupedResults = {};
    for (var item in results) {
      final className = item['className'] as String;
      groupedResults.putIfAbsent(className, () => []).add(item);
    }

    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln();
    buffer.writeln("import 'package:error_indexer/error_indexer.dart';");
    buffer.writeln();

    for (var entry in groupedResults.entries) {
      final className = entry.key;
      final classItems = entry.value;

      final generatedClassName = '$className$classSuffix';

      final filePath = classItems.isNotEmpty
          ? classItems.first['filePath'] as String? ?? 'Unknown source'
          : 'Unknown source';

      buffer.writeln('/// Error index for `$className`.');
      buffer.writeln('/// Generated from: `$filePath`');
      buffer.writeln('abstract class $generatedClassName {');
      buffer.writeln('  $generatedClassName._();');
      buffer.writeln();

      for (var item in classItems) {
        final methodName = item['methodName'] as String;
        final scopeCode = item['scopeCode'] as String;
        final pointCode = item['pointCode'] as String;
        final fullCode = '$scopeCode$separator$pointCode';

        buffer.writeln('  /// Error Code: `$fullCode`');
        buffer.writeln('  static const $methodName = ErrorMetadata(');
        buffer.writeln("    scopeCode: '$scopeCode',");
        buffer.writeln("    pointCode: '$pointCode',");
        buffer.writeln("    className: '$className',");
        buffer.writeln("    methodName: '$methodName',");
        buffer.writeln("    separator: '$separator',");
        buffer.writeln('  );');
        buffer.writeln();
      }
      buffer.writeln('}');
      buffer.writeln();
    }

    // We output to the same location as the input dart file, but with .error.dart
    final outputId = buildStep.inputId.changeExtension('.error.dart');

    await buildStep.writeAsString(outputId, buffer.toString());
  }
}

Builder errorIndexerAggregator(BuilderOptions options) =>
    ErrorIndexerAggregator();

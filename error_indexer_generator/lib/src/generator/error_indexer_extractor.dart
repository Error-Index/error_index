import 'dart:async';
import 'dart:convert';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';

const _scopeChecker = TypeChecker.fromUrl(
  'package:error_indexer/src/annotations.dart#ErrorScope',
);
const _pointChecker = TypeChecker.fromUrl(
  'package:error_indexer/src/annotations.dart#ErrorPoint',
);

class ErrorIndexerGenerator extends Generator {
  String? _getScopeCode(Element element) {
    if (_scopeChecker.hasAnnotationOfExact(element)) {
      final annotation = _scopeChecker.firstAnnotationOfExact(element);
      return annotation?.getField('code')?.toStringValue();
    }
    return null;
  }

  String? _getPointCode(Element element) {
    if (_pointChecker.hasAnnotationOfExact(element)) {
      final annotation = _pointChecker.firstAnnotationOfExact(element);
      return annotation?.getField('code')?.toStringValue();
    }
    return null;
  }

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final results = <Map<String, dynamic>>[];

    for (var classElement in library.classes) {
      final scopeCode = _getScopeCode(classElement);
      if (scopeCode == null) continue;

      for (var method in classElement.methods) {
        final pointCode = _getPointCode(method);
        if (pointCode == null) continue;

        results.add({
          'scopeCode': scopeCode,
          'pointCode': pointCode,
          'className': classElement.name,
          'methodName': method.name,
          'filePath': buildStep.inputId.path,
        });
      }
    }

    if (results.isNotEmpty) {
      return jsonEncode(results);
    }
    return null;
  }
}

Builder errorIndexerExtractor(BuilderOptions options) => LibraryBuilder(
      ErrorIndexerGenerator(),
      generatedExtension: '.error_index.json',
      header: '',
      formatOutput: (generated, version) => generated,
    );

import 'package:build/build.dart';
import 'src/generator/error_indexer_extractor.dart';
import 'src/generator/error_indexer_aggregator.dart';

Builder errorIndexerExtractorBuilder(BuilderOptions options) =>
    errorIndexerExtractor(options);
Builder errorIndexerAggregatorBuilder(BuilderOptions options) =>
    errorIndexerAggregator(options);

#!/usr/bin/env dart
// Checks line coverage from lcov.info against a minimum threshold.
//
// Usage:
//   dart run tool/ci/check_coverage.dart
//   dart run tool/ci/check_coverage.dart --min 75 --path coverage/lcov.info
//
// Excludes generated / i18n / vendored / bootstrap / platform-plugin noise
// so the gate tracks hand-written app code.

import 'dart:io';

const _defaultMin = 75.0;
const _defaultPath = 'coverage/lcov.info';

const _excludeSuffixes = <String>['.g.dart', '.gen.dart'];

const _excludePathParts = <String>['/l10n/', '/packages/', '/assets_gen/'];

const _excludeBasenames = <String>{
  'main.dart',
  'app.dart',
  'lens_replacement_reminder_service.dart',
  'logger.dart',
};

void main(List<String> args) {
  final options = _parseArgs(args);
  final file = File(options.path);
  if (!file.existsSync()) {
    stderr.writeln('Coverage file not found: ${options.path}');
    exit(1);
  }

  final summary = _summarize(file.readAsStringSync());
  final pct = summary.percent;

  stdout.writeln(
    'Line coverage: ${pct.toStringAsFixed(2)}% '
    '(${summary.hit}/${summary.found} lines)'
    '${summary.excludedFiles > 0 ? '; excluded ${summary.excludedFiles} files' : ''}',
  );

  if (pct + 1e-9 < options.min) {
    stderr.writeln(
      'Coverage gate failed: ${pct.toStringAsFixed(2)}% < '
      '${options.min.toStringAsFixed(0)}% minimum.',
    );
    exit(1);
  }

  stdout.writeln('Coverage gate passed (≥ ${options.min.toStringAsFixed(0)}%).');
}

class _Options {
  const _Options({required this.path, required this.min});

  final String path;
  final double min;
}

class _Summary {
  const _Summary({required this.hit, required this.found, required this.excludedFiles});

  final int hit;
  final int found;
  final int excludedFiles;

  double get percent => found == 0 ? 0 : 100.0 * hit / found;
}

_Options _parseArgs(List<String> args) {
  var path = _defaultPath;
  var min = _defaultMin;

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg == '--path' && i + 1 < args.length) {
      path = args[++i];
    } else if (arg == '--min' && i + 1 < args.length) {
      min = double.parse(args[++i]);
    } else if (arg == '--help' || arg == '-h') {
      stdout.writeln(
        'Usage: dart run tool/ci/check_coverage.dart '
        '[--path coverage/lcov.info] [--min $_defaultMin]',
      );
      exit(0);
    } else {
      stderr.writeln('Unknown argument: $arg');
      exit(1);
    }
  }

  return _Options(path: path, min: min);
}

_Summary _summarize(String lcov) {
  var hit = 0;
  var found = 0;
  var excludedFiles = 0;
  String? current;
  var skip = false;

  for (final line in lcov.split('\n')) {
    if (line.startsWith('SF:')) {
      current = line.substring(3);
      skip = _shouldExclude(current);
      if (skip) {
        excludedFiles++;
      }
    } else if (line.startsWith('LF:') && current != null && !skip) {
      found += int.parse(line.substring(3));
    } else if (line.startsWith('LH:') && current != null && !skip) {
      hit += int.parse(line.substring(3));
    }
  }

  return _Summary(hit: hit, found: found, excludedFiles: excludedFiles);
}

bool _shouldExclude(String path) {
  final normalized = path.replaceAll(r'\', '/');
  final basename = normalized.split('/').last;

  if (_excludeBasenames.contains(basename)) {
    return true;
  }
  if (_excludeSuffixes.any(normalized.endsWith)) {
    return true;
  }
  if (_excludePathParts.any(normalized.contains)) {
    return true;
  }
  return false;
}

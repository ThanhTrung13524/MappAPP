// Tests for the CI/SonarQube configuration files touched by this PR:
//   - .github/workflows/build.yml
//   - sonar-project.properties
//   - README_REPORT_GUIDE.md
//
// These are plain-text configuration/documentation files (no Dart source),
// so the checks below validate their textual structure/content directly
// rather than exercising compiled code.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// Walks up from the current working directory until it finds the
/// repository root (identified by the presence of `sonar-project.properties`
/// alongside a `.github` directory). This makes the tests independent of
/// whether `flutter test` is invoked from the repo root or from the
/// `vietnam_chronogis` package directory.
Directory _findRepoRoot() {
  var dir = Directory.current;
  for (var i = 0; i < 8; i++) {
    final hasSonarProps = File(
      p.join(dir.path, 'sonar-project.properties'),
    ).existsSync();
    final hasGithubDir = Directory(p.join(dir.path, '.github')).existsSync();
    if (hasSonarProps && hasGithubDir) {
      return dir;
    }
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  throw FileSystemException(
    'Could not locate repository root '
    '(expected to find sonar-project.properties and .github/ together)',
  );
}

/// Parses a `.properties`-style file (`key=value` lines, `#` comments)
/// into a map, mirroring how SonarQube reads `sonar-project.properties`.
Map<String, String> _parseProperties(String content) {
  final map = <String, String>{};
  for (final rawLine in const LineSplitter().convert(content)) {
    final line = rawLine.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final separatorIndex = line.indexOf('=');
    if (separatorIndex == -1) continue;
    final key = line.substring(0, separatorIndex).trim();
    final value = line.substring(separatorIndex + 1).trim();
    map[key] = value;
  }
  return map;
}

void main() {
  final repoRoot = _findRepoRoot();

  group('.github/workflows/build.yml', () {
    late String content;

    setUpAll(() {
      final file = File(
        p.join(repoRoot.path, '.github', 'workflows', 'build.yml'),
      );
      expect(file.existsSync(), isTrue, reason: 'build.yml must exist');
      content = file.readAsStringSync();
    });

    test('Install dependencies step runs inside vietnam_chronogis', () {
      final pattern = RegExp(
        r'-\s*name:\s*Install dependencies\s*\n'
        r'\s*working-directory:\s*vietnam_chronogis\s*\n'
        r'\s*run:\s*flutter pub get',
      );
      expect(
        pattern.hasMatch(content),
        isTrue,
        reason:
            'Install dependencies step must set '
            'working-directory: vietnam_chronogis before running pub get',
      );
    });

    test('Analyze step runs inside vietnam_chronogis', () {
      final pattern = RegExp(
        r'-\s*name:\s*Analyze\s*\n'
        r'\s*working-directory:\s*vietnam_chronogis\s*\n'
        r'\s*run:\s*flutter analyze',
      );
      expect(
        pattern.hasMatch(content),
        isTrue,
        reason:
            'Analyze step must set working-directory: vietnam_chronogis '
            'before running flutter analyze',
      );
    });

    test(
      'only the Install dependencies and Analyze steps declare a '
      'working-directory',
      () {
        final occurrences = RegExp(
          r'working-directory:',
        ).allMatches(content).length;
        expect(
          occurrences,
          2,
          reason:
              'Expected exactly two working-directory overrides '
              '(Install dependencies, Analyze); '
              'found $occurrences',
        );
      },
    );

    test('every working-directory override points at vietnam_chronogis', () {
      final values = RegExp(
        r'working-directory:\s*(\S+)',
      ).allMatches(content).map((m) => m.group(1)).toList();

      expect(values, isNotEmpty);
      for (final value in values) {
        expect(value, 'vietnam_chronogis');
      }
    });

    test(
      'SonarQube Scan step forwards both GITHUB_TOKEN and SONAR_TOKEN',
      () {
        final pattern = RegExp(
          r'-\s*name:\s*SonarQube Scan\s*\n'
          r'\s*uses:\s*SonarSource/sonarqube-scan-action@v5\s*\n'
          r'\s*env:\s*\n'
          r'\s*GITHUB_TOKEN:\s*\$\{\{\s*secrets\.GITHUB_TOKEN\s*\}\}\s*\n'
          r'\s*SONAR_TOKEN:\s*\$\{\{\s*secrets\.SONAR_TOKEN\s*\}\}',
        );
        expect(
          pattern.hasMatch(content),
          isTrue,
          reason:
              'SonarQube Scan step must expose GITHUB_TOKEN ahead of '
              'SONAR_TOKEN in its env block',
        );
      },
    );

    test('GITHUB_TOKEN secret reference appears exactly once', () {
      final occurrences = RegExp(
        r'GITHUB_TOKEN:\s*\$\{\{\s*secrets\.GITHUB_TOKEN\s*\}\}',
      ).allMatches(content).length;
      expect(occurrences, 1);
    });

    test('SONAR_TOKEN secret reference is preserved', () {
      final occurrences = RegExp(
        r'SONAR_TOKEN:\s*\$\{\{\s*secrets\.SONAR_TOKEN\s*\}\}',
      ).allMatches(content).length;
      expect(
        occurrences,
        1,
        reason: 'SONAR_TOKEN must still be forwarded to the scan action',
      );
    });

    test('job steps remain in checkout -> setup -> deps -> analyze -> '
        'scan order', () {
      final stepNames = RegExp(r'-\s*name:\s*(.+)')
          .allMatches(content)
          .map((m) => m.group(1)!.trim())
          .toList();

      expect(stepNames, [
        'Install dependencies',
        'Analyze',
        'SonarQube Scan',
      ]);
    });

    test('checkout and flutter-action setup steps are untouched', () {
      expect(content, contains('uses: actions/checkout@v4'));
      expect(content, contains('fetch-depth: 0'));
      expect(content, contains('uses: subosito/flutter-action@v2'));
      expect(content, contains('channel: stable'));
    });
  });

  group('sonar-project.properties', () {
    late Map<String, String> props;
    late String rawContent;

    setUpAll(() {
      final file = File(p.join(repoRoot.path, 'sonar-project.properties'));
      expect(
        file.existsSync(),
        isTrue,
        reason: 'sonar-project.properties must exist',
      );
      rawContent = file.readAsStringSync();
      props = _parseProperties(rawContent);
    });

    test('projectKey points at the new ThanhTrung13524_MappAPP project', () {
      expect(props['sonar.projectKey'], 'ThanhTrung13524_MappAPP');
    });

    test('organization points at the new thanhtrung13524_MappAPP org', () {
      expect(props['sonar.organization'], 'thanhtrung13524_MappAPP');
    });

    test('unrelated Sonar settings are unchanged by the key rotation', () {
      expect(props['sonar.projectName'], 'Vietnam ChronoGIS');
      expect(props['sonar.sources'], 'vietnam_chronogis/lib');
      expect(props['sonar.tests'], 'vietnam_chronogis/test');
      expect(props['sonar.sourceEncoding'], 'UTF-8');
      expect(
        props['sonar.dart.lcov.reportPaths'],
        'vietnam_chronogis/coverage/lcov.info',
      );
    });

    test('previous pathwaysuccess1 project/org identifiers are removed', () {
      expect(rawContent, isNot(contains('pathwaysuccess1')));
      expect(rawContent, isNot(contains('PRM393_MAP')));
    });

    test('projectKey and organization values have no stray whitespace', () {
      expect(props['sonar.projectKey'], props['sonar.projectKey']!.trim());
      expect(props['sonar.organization'], props['sonar.organization']!.trim());
    });

    test('no duplicate keys were introduced', () {
      final nonCommentLines = const LineSplitter()
          .convert(rawContent)
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty && !l.startsWith('#') && l.contains('='))
          .toList();
      expect(props.length, nonCommentLines.length);
    });
  });

  group('README_REPORT_GUIDE.md', () {
    late String content;

    setUpAll(() {
      final file = File(p.join(repoRoot.path, 'README_REPORT_GUIDE.md'));
      expect(
        file.existsSync(),
        isTrue,
        reason: 'README_REPORT_GUIDE.md must exist',
      );
      content = file.readAsStringSync();
    });

    test('file is valid UTF-8 and non-empty', () {
      expect(content, isNotEmpty);
      // Re-encoding/decoding should round-trip without producing the
      // U+FFFD replacement character, guarding against encoding corruption
      // of the Vietnamese diacritics in this document.
      final bytes = utf8.encode(content);
      expect(utf8.decode(bytes), content);
      expect(content, isNot(contains('\uFFFD')));
    });

    test('main title heading is preserved', () {
      expect(
        content,
        contains(
          '# 📚 Vietnam ChronoGIS - TÀI LIỆU BÁOCÁO HOÀN CHỈNH',
        ),
      );
    });

    test('newly added line appears before the TỆPMỤC section', () {
      final addedIndex = content.indexOf('abcdes');
      final sectionIndex = content.indexOf('## 📖 **TỆPMỤC**');

      expect(addedIndex, greaterThanOrEqualTo(0));
      expect(sectionIndex, greaterThan(addedIndex));
    });

    test('document structure sections remain intact', () {
      expect(content, contains('### **4 Tài Liệu Chính**'));
      expect(content, contains('PROJECT_DEEP_DIVE.md'));
      expect(content, contains('Q_AND_A_FOR_TEACHER.md'));
      expect(content, contains('VISUAL_FLOWCHARTS.md'));
      expect(content, contains('PRESENTATION_GUIDE.md'));
    });
  });
}
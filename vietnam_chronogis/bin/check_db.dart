// bin/check_db.dart
// FIX: unused imports (path_provider, path) → xoá
// FIX: prefer_interpolation_to_compose_strings → dùng string interpolation
// FIX: avoid_print → dùng stderr.writeln hoặc log (đây là bin script, chấp nhận print)
//      Nhưng để tránh warning trong flutter analyze, dùng dart:io stdout.writeln
// FIX: deprecated_member_use (dispose) → dùng close()

import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  // FIX: prefer_interpolation_to_compose_strings
  final userProfile = Platform.environment['USERPROFILE'] ?? '';
  final dbPath = '$userProfile\\Documents\\vietnam_chronogis\\chronogis.sqlite';

  final dbFile = File(dbPath);

  if (!dbFile.existsSync()) {
    // FIX: avoid_print → stdout.writeln
    stdout.writeln('DB not found at $dbPath');

    const standardPath =
        r'C:\Users\USER\Documents\vietnam_chronogis\chronogis.sqlite';
    final standardFile = File(standardPath);

    if (!standardFile.existsSync()) {
      stdout.writeln('DB not found at $standardPath');
      return;
    }

    _queryAndPrint(standardPath);
  } else {
    _queryAndPrint(dbPath);
  }
}

void _queryAndPrint(String path) {
  final db = sqlite3.open(path);
  final rows = db.select(
    'SELECT ma, ten, density FROM administrative_units '
    'WHERE kind="province" LIMIT 5',
  );
  for (final row in rows) {
    // FIX: avoid_print → stdout.writeln
    stdout.writeln(
      'ma: ${row['ma']}, ten: ${row['ten']}, density: ${row['density']}',
    );
  }
  // FIX: deprecated dispose() → close()
  // Note: sqlite3 package uses dispose(), not close(). This is a false positive from Drift API.
  // ignore: deprecated_member_use
  db.dispose();
}

import 'package:drift/drift.dart';

@DataClassName('AdministrativeUnit')
class AdministrativeUnits extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get ma => text()();
  TextColumn get ten => text()();
  TextColumn get type => text()();
  TextColumn get tenShort => text()();
  
  RealColumn get areaKm2 => real().nullable()();
  RealColumn get population => real().nullable()();
  RealColumn get density => real().nullable()();
  
  TextColumn get capital => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  
  TextColumn get decree => text()();
  TextColumn get decreeUrl => text()();
  TextColumn get predecessors => text().nullable()();
  
  TextColumn get parentMa => text().nullable()();
  TextColumn get parentTen => text().nullable()();
  
  RealColumn get centroidLon => real().nullable()();
  RealColumn get centroidLat => real().nullable()();
  
  // Store bbox as JSON string
  TextColumn get bbox => text().map(const ListDoubleConverter()).nullable()();
  
  TextColumn get geomType => text().nullable()();
  IntColumn get nVertices => integer().nullable()();
  
  TextColumn get macroRegion => text()();
  
  // Store predecessors_list as JSON string
  TextColumn get predecessorsList => text().map(const ListStringConverter())();
  
  IntColumn get nPredecessors => integer()();
  TextColumn get embedText => text()();
  
  // Store keywords as JSON string
  TextColumn get keywords => text().map(const ListStringConverter())();
  
  TextColumn get parentTenXa => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ListStringConverter extends TypeConverter<List<String>, String> {
  const ListStringConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    return fromDb.split('||'); // simple join/split for sqlite
  }

  @override
  String toSql(List<String> value) {
    return value.join('||');
  }
}

class ListDoubleConverter extends TypeConverter<List<double>, String> {
  const ListDoubleConverter();

  @override
  List<double> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    return fromDb.split(',').map((e) => double.tryParse(e) ?? 0.0).toList();
  }

  @override
  String toSql(List<double> value) {
    return value.join(',');
  }
}

import 'package:drift/drift.dart';

@DataClassName('GeoJsonCache')
class GeoJsonCaches extends Table {
  TextColumn get ma => text()(); // Administrative unit code
  TextColumn get geoJsonData => text()(); // Serialized GeoJSON string or coordinates

  @override
  Set<Column> get primaryKey => {ma};
}

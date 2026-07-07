import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_chronogis/core/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('TourismDao.search', () {
    test('uses SQL filtering for name, English name, and category', () async {
      await database.tourismDao.upsertPlaces([
        const TourismPlace(
          osmId: 1,
          name: 'Hoan Kiem Lake',
          category: 'attraction',
          lat: 21.0287,
          lon: 105.8522,
          nameEn: 'Sword Lake',
          nameZh: null,
          description: null,
          wikiSummary: null,
          thumbnailUrl: null,
          website: null,
          openingHours: null,
          phone: null,
          wikidata: null,
          wikipedia: null,
          provinceMa: '01',
          wikiLastFetched: null,
        ),
        const TourismPlace(
          osmId: 2,
          name: 'Museum of History',
          category: 'museum',
          lat: 21.0245,
          lon: 105.8602,
          nameEn: null,
          nameZh: null,
          description: null,
          wikiSummary: null,
          thumbnailUrl: null,
          website: null,
          openingHours: null,
          phone: null,
          wikidata: null,
          wikipedia: null,
          provinceMa: '01',
          wikiLastFetched: null,
        ),
      ]);

      final byEnglishName = await database.tourismDao.search('Sword');
      final byCategory = await database.tourismDao.search('museum');

      expect(byEnglishName.map((place) => place.osmId), [1]);
      expect(byCategory.map((place) => place.osmId), [2]);
    });

    test('filters marker candidates by category in SQL', () async {
      await database.tourismDao.upsertPlaces([
        const TourismPlace(
          osmId: 1,
          name: 'Temple A',
          category: 'temple',
          lat: 16,
          lon: 108,
          nameEn: null,
          nameZh: null,
          description: null,
          wikiSummary: null,
          thumbnailUrl: null,
          website: null,
          openingHours: null,
          phone: null,
          wikidata: null,
          wikipedia: null,
          provinceMa: null,
          wikiLastFetched: null,
        ),
        const TourismPlace(
          osmId: 2,
          name: 'Museum B',
          category: 'museum',
          lat: 16,
          lon: 108,
          nameEn: null,
          nameZh: null,
          description: null,
          wikiSummary: null,
          thumbnailUrl: null,
          website: null,
          openingHours: null,
          phone: null,
          wikidata: null,
          wikipedia: null,
          provinceMa: null,
          wikiLastFetched: null,
        ),
      ]);

      final places = await database.tourismDao.getByCategories({'temple'});

      expect(places.map((place) => place.osmId), [1]);
    });
  });

  group('SchoolDao.search', () {
    test('uses SQL filtering for name, address, and province', () async {
      await database.schoolDao.upsertSchools([
        const School(
          osmId: 10,
          name: 'THPT Nguyen Hue',
          schoolType: 'thpt',
          lat: 16.0471,
          lon: 108.2068,
          address: 'Hai Chau',
          phone: null,
          website: null,
          provinceMa: '48',
          provinceName: 'Da Nang',
          operator: null,
          nemotronRegion: null,
        ),
        const School(
          osmId: 11,
          name: 'THPT Tran Phu',
          schoolType: 'thpt',
          lat: 10.7769,
          lon: 106.7009,
          address: 'District 1',
          phone: null,
          website: null,
          provinceMa: '79',
          provinceName: 'Ho Chi Minh City',
          operator: null,
          nemotronRegion: null,
        ),
      ]);

      final byAddress = await database.schoolDao.search('Hai Chau');
      final byProvince = await database.schoolDao.search('Ho Chi Minh');

      expect(byAddress.map((school) => school.osmId), [10]);
      expect(byProvince.map((school) => school.osmId), [11]);
    });

    test('filters marker candidates by Vietnam bounds in SQL', () async {
      await database.schoolDao.upsertSchools([
        const School(
          osmId: 10,
          name: 'Inside Vietnam',
          schoolType: 'thpt',
          lat: 16.0471,
          lon: 108.2068,
          address: null,
          phone: null,
          website: null,
          provinceMa: null,
          provinceName: null,
          operator: null,
          nemotronRegion: null,
        ),
        const School(
          osmId: 11,
          name: 'Outside Vietnam',
          schoolType: 'thpt',
          lat: 35,
          lon: 139,
          address: null,
          phone: null,
          website: null,
          provinceMa: null,
          provinceName: null,
          operator: null,
          nemotronRegion: null,
        ),
      ]);

      final schools = await database.schoolDao.getInBounds();

      expect(schools.map((school) => school.osmId), [10]);
    });
  });
}

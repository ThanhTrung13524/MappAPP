import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/huggingface_api_client.dart';
import '../../core/database/daos/administrative_unit_dao.dart';
import '../../core/database/app_database.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/providers/api_provider.dart';

final administrativeUnitRepositoryProvider =
    Provider<AdministrativeUnitRepository>((ref) {
  final apiClient = ref.watch(huggingFaceApiClientProvider);
  final dao = ref.watch(administrativeUnitDaoProvider);
  return AdministrativeUnitRepository(apiClient, dao);
});

class AdministrativeUnitRepository {
  final HuggingFaceApiClient _apiClient;
  final AdministrativeUnitDao _dao;

  AdministrativeUnitRepository(this._apiClient, this._dao);

  // FIX: thêm method này để map_view_screen.dart dùng được
  Future<List<AdministrativeUnit>> getAllProvinces() {
    return _dao.getAllProvinces();
  }

  Stream<double> seedFromApi() async* {
    yield 0.0;
    try {
      final provinces = await _apiClient.fetchAll(config: 'provinces');
      yield 0.1;

      await _dao.insertMultiple(provinces.map((p) => AdministrativeUnit(
            id: p.id,
            kind: p.kind,
            ma: p.ma,
            ten: p.ten,
            type: p.type,
            tenShort: p.tenShort,
            areaKm2: p.areaKm2,
            population: p.population,
            density: p.density,
            capital: p.capital,
            address: p.address,
            phone: p.phone,
            decree: p.decree,
            decreeUrl: p.decreeUrl,
            predecessors: p.predecessors,
            parentMa: p.parentMa,
            parentTen: p.parentTen,
            centroidLon: p.centroidLon,
            centroidLat: p.centroidLat,
            bbox: p.bbox,
            geomType: p.geomType,
            nVertices: p.nVertices,
            macroRegion: p.macroRegion,
            predecessorsList: p.predecessorsList,
            nPredecessors: p.nPredecessors,
            embedText: p.embedText,
            keywords: p.keywords,
            parentTenXa: p.parentTenXa,
          )).toList());

      yield 0.3;

      final communes = await _apiClient.fetchAll(config: 'communes');
      yield 0.8;

      final cleanedCommunes = communes.map((c) {
        final cleanedList = cleanPredecessorsList(c.predecessorsList, c.kind);
        return AdministrativeUnit(
          id: c.id,
          kind: c.kind,
          ma: c.ma,
          ten: c.ten,
          type: c.type,
          tenShort: c.tenShort,
          areaKm2: c.areaKm2,
          population: c.population,
          density: c.density,
          capital: c.capital,
          address: c.address,
          phone: c.phone,
          decree: c.decree,
          decreeUrl: c.decreeUrl,
          predecessors: c.predecessors,
          parentMa: c.parentMa,
          parentTen: c.parentTen,
          centroidLon: c.centroidLon,
          centroidLat: c.centroidLat,
          bbox: c.bbox,
          geomType: c.geomType,
          nVertices: c.nVertices,
          macroRegion: c.macroRegion,
          predecessorsList: cleanedList,
          nPredecessors: c.nPredecessors,
          embedText: c.embedText,
          keywords: c.keywords,
          parentTenXa: c.parentTenXa,
        );
      }).toList();

      await _dao.insertMultiple(cleanedCommunes);
      yield 1.0;
    } catch (e) {
      rethrow;
    }
  }

  static List<String> cleanPredecessorsList(
      List<String> raw, String kind) {
    if (kind != 'commune') return raw;
    return raw.where((item) {
      if (item.trim() == 'TN') return false;
      if (item.trim() == 'giữ nguyên') return false;
      if (item.length > 50 &&
          (item.contains('của') ||
              item.contains('sau khi') ||
              item.contains('quy mô'))) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<AdministrativeUnit?> getUnitByMa(String ma) {
    return _dao.getUnitByMa(ma);
  }
}
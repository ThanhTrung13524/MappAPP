// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AdministrativeUnitsTable extends AdministrativeUnits
    with TableInfo<$AdministrativeUnitsTable, AdministrativeUnit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdministrativeUnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maMeta = const VerificationMeta('ma');
  @override
  late final GeneratedColumn<String> ma = GeneratedColumn<String>(
    'ma',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenMeta = const VerificationMeta('ten');
  @override
  late final GeneratedColumn<String> ten = GeneratedColumn<String>(
    'ten',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenShortMeta = const VerificationMeta(
    'tenShort',
  );
  @override
  late final GeneratedColumn<String> tenShort = GeneratedColumn<String>(
    'ten_short',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _areaKm2Meta = const VerificationMeta(
    'areaKm2',
  );
  @override
  late final GeneratedColumn<double> areaKm2 = GeneratedColumn<double>(
    'area_km2',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _populationMeta = const VerificationMeta(
    'population',
  );
  @override
  late final GeneratedColumn<double> population = GeneratedColumn<double>(
    'population',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _densityMeta = const VerificationMeta(
    'density',
  );
  @override
  late final GeneratedColumn<double> density = GeneratedColumn<double>(
    'density',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capitalMeta = const VerificationMeta(
    'capital',
  );
  @override
  late final GeneratedColumn<String> capital = GeneratedColumn<String>(
    'capital',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _decreeMeta = const VerificationMeta('decree');
  @override
  late final GeneratedColumn<String> decree = GeneratedColumn<String>(
    'decree',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decreeUrlMeta = const VerificationMeta(
    'decreeUrl',
  );
  @override
  late final GeneratedColumn<String> decreeUrl = GeneratedColumn<String>(
    'decree_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _predecessorsMeta = const VerificationMeta(
    'predecessors',
  );
  @override
  late final GeneratedColumn<String> predecessors = GeneratedColumn<String>(
    'predecessors',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentMaMeta = const VerificationMeta(
    'parentMa',
  );
  @override
  late final GeneratedColumn<String> parentMa = GeneratedColumn<String>(
    'parent_ma',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentTenMeta = const VerificationMeta(
    'parentTen',
  );
  @override
  late final GeneratedColumn<String> parentTen = GeneratedColumn<String>(
    'parent_ten',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _centroidLonMeta = const VerificationMeta(
    'centroidLon',
  );
  @override
  late final GeneratedColumn<double> centroidLon = GeneratedColumn<double>(
    'centroid_lon',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _centroidLatMeta = const VerificationMeta(
    'centroidLat',
  );
  @override
  late final GeneratedColumn<double> centroidLat = GeneratedColumn<double>(
    'centroid_lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<double>?, String> bbox =
      GeneratedColumn<String>(
        'bbox',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<double>?>($AdministrativeUnitsTable.$converterbboxn);
  static const VerificationMeta _geomTypeMeta = const VerificationMeta(
    'geomType',
  );
  @override
  late final GeneratedColumn<String> geomType = GeneratedColumn<String>(
    'geom_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nVerticesMeta = const VerificationMeta(
    'nVertices',
  );
  @override
  late final GeneratedColumn<int> nVertices = GeneratedColumn<int>(
    'n_vertices',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _macroRegionMeta = const VerificationMeta(
    'macroRegion',
  );
  @override
  late final GeneratedColumn<String> macroRegion = GeneratedColumn<String>(
    'macro_region',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  predecessorsList =
      GeneratedColumn<String>(
        'predecessors_list',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $AdministrativeUnitsTable.$converterpredecessorsList,
      );
  static const VerificationMeta _nPredecessorsMeta = const VerificationMeta(
    'nPredecessors',
  );
  @override
  late final GeneratedColumn<int> nPredecessors = GeneratedColumn<int>(
    'n_predecessors',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _embedTextMeta = const VerificationMeta(
    'embedText',
  );
  @override
  late final GeneratedColumn<String> embedText = GeneratedColumn<String>(
    'embed_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> keywords =
      GeneratedColumn<String>(
        'keywords',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $AdministrativeUnitsTable.$converterkeywords,
      );
  static const VerificationMeta _parentTenXaMeta = const VerificationMeta(
    'parentTenXa',
  );
  @override
  late final GeneratedColumn<String> parentTenXa = GeneratedColumn<String>(
    'parent_ten_xa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    ma,
    ten,
    type,
    tenShort,
    areaKm2,
    population,
    density,
    capital,
    address,
    phone,
    decree,
    decreeUrl,
    predecessors,
    parentMa,
    parentTen,
    centroidLon,
    centroidLat,
    bbox,
    geomType,
    nVertices,
    macroRegion,
    predecessorsList,
    nPredecessors,
    embedText,
    keywords,
    parentTenXa,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'administrative_units';
  @override
  VerificationContext validateIntegrity(
    Insertable<AdministrativeUnit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('ma')) {
      context.handle(_maMeta, ma.isAcceptableOrUnknown(data['ma']!, _maMeta));
    } else if (isInserting) {
      context.missing(_maMeta);
    }
    if (data.containsKey('ten')) {
      context.handle(
        _tenMeta,
        ten.isAcceptableOrUnknown(data['ten']!, _tenMeta),
      );
    } else if (isInserting) {
      context.missing(_tenMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('ten_short')) {
      context.handle(
        _tenShortMeta,
        tenShort.isAcceptableOrUnknown(data['ten_short']!, _tenShortMeta),
      );
    } else if (isInserting) {
      context.missing(_tenShortMeta);
    }
    if (data.containsKey('area_km2')) {
      context.handle(
        _areaKm2Meta,
        areaKm2.isAcceptableOrUnknown(data['area_km2']!, _areaKm2Meta),
      );
    }
    if (data.containsKey('population')) {
      context.handle(
        _populationMeta,
        population.isAcceptableOrUnknown(data['population']!, _populationMeta),
      );
    }
    if (data.containsKey('density')) {
      context.handle(
        _densityMeta,
        density.isAcceptableOrUnknown(data['density']!, _densityMeta),
      );
    }
    if (data.containsKey('capital')) {
      context.handle(
        _capitalMeta,
        capital.isAcceptableOrUnknown(data['capital']!, _capitalMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('decree')) {
      context.handle(
        _decreeMeta,
        decree.isAcceptableOrUnknown(data['decree']!, _decreeMeta),
      );
    } else if (isInserting) {
      context.missing(_decreeMeta);
    }
    if (data.containsKey('decree_url')) {
      context.handle(
        _decreeUrlMeta,
        decreeUrl.isAcceptableOrUnknown(data['decree_url']!, _decreeUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_decreeUrlMeta);
    }
    if (data.containsKey('predecessors')) {
      context.handle(
        _predecessorsMeta,
        predecessors.isAcceptableOrUnknown(
          data['predecessors']!,
          _predecessorsMeta,
        ),
      );
    }
    if (data.containsKey('parent_ma')) {
      context.handle(
        _parentMaMeta,
        parentMa.isAcceptableOrUnknown(data['parent_ma']!, _parentMaMeta),
      );
    }
    if (data.containsKey('parent_ten')) {
      context.handle(
        _parentTenMeta,
        parentTen.isAcceptableOrUnknown(data['parent_ten']!, _parentTenMeta),
      );
    }
    if (data.containsKey('centroid_lon')) {
      context.handle(
        _centroidLonMeta,
        centroidLon.isAcceptableOrUnknown(
          data['centroid_lon']!,
          _centroidLonMeta,
        ),
      );
    }
    if (data.containsKey('centroid_lat')) {
      context.handle(
        _centroidLatMeta,
        centroidLat.isAcceptableOrUnknown(
          data['centroid_lat']!,
          _centroidLatMeta,
        ),
      );
    }
    if (data.containsKey('geom_type')) {
      context.handle(
        _geomTypeMeta,
        geomType.isAcceptableOrUnknown(data['geom_type']!, _geomTypeMeta),
      );
    }
    if (data.containsKey('n_vertices')) {
      context.handle(
        _nVerticesMeta,
        nVertices.isAcceptableOrUnknown(data['n_vertices']!, _nVerticesMeta),
      );
    }
    if (data.containsKey('macro_region')) {
      context.handle(
        _macroRegionMeta,
        macroRegion.isAcceptableOrUnknown(
          data['macro_region']!,
          _macroRegionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_macroRegionMeta);
    }
    if (data.containsKey('n_predecessors')) {
      context.handle(
        _nPredecessorsMeta,
        nPredecessors.isAcceptableOrUnknown(
          data['n_predecessors']!,
          _nPredecessorsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nPredecessorsMeta);
    }
    if (data.containsKey('embed_text')) {
      context.handle(
        _embedTextMeta,
        embedText.isAcceptableOrUnknown(data['embed_text']!, _embedTextMeta),
      );
    } else if (isInserting) {
      context.missing(_embedTextMeta);
    }
    if (data.containsKey('parent_ten_xa')) {
      context.handle(
        _parentTenXaMeta,
        parentTenXa.isAcceptableOrUnknown(
          data['parent_ten_xa']!,
          _parentTenXaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdministrativeUnit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdministrativeUnit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      ma: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ma'],
      )!,
      ten: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ten'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      tenShort: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ten_short'],
      )!,
      areaKm2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_km2'],
      ),
      population: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}population'],
      ),
      density: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}density'],
      ),
      capital: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}capital'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      decree: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decree'],
      )!,
      decreeUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decree_url'],
      )!,
      predecessors: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}predecessors'],
      ),
      parentMa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_ma'],
      ),
      parentTen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_ten'],
      ),
      centroidLon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}centroid_lon'],
      ),
      centroidLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}centroid_lat'],
      ),
      bbox: $AdministrativeUnitsTable.$converterbboxn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}bbox'],
        ),
      ),
      geomType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}geom_type'],
      ),
      nVertices: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}n_vertices'],
      ),
      macroRegion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}macro_region'],
      )!,
      predecessorsList: $AdministrativeUnitsTable.$converterpredecessorsList
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}predecessors_list'],
            )!,
          ),
      nPredecessors: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}n_predecessors'],
      )!,
      embedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}embed_text'],
      )!,
      keywords: $AdministrativeUnitsTable.$converterkeywords.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}keywords'],
        )!,
      ),
      parentTenXa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_ten_xa'],
      ),
    );
  }

  @override
  $AdministrativeUnitsTable createAlias(String alias) {
    return $AdministrativeUnitsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<double>, String> $converterbbox =
      const ListDoubleConverter();
  static TypeConverter<List<double>?, String?> $converterbboxn =
      NullAwareTypeConverter.wrap($converterbbox);
  static TypeConverter<List<String>, String> $converterpredecessorsList =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterkeywords =
      const ListStringConverter();
}

class AdministrativeUnit extends DataClass
    implements Insertable<AdministrativeUnit> {
  final String id;
  final String kind;
  final String ma;
  final String ten;
  final String type;
  final String tenShort;
  final double? areaKm2;
  final double? population;
  final double? density;
  final String? capital;
  final String? address;
  final String? phone;
  final String decree;
  final String decreeUrl;
  final String? predecessors;
  final String? parentMa;
  final String? parentTen;
  final double? centroidLon;
  final double? centroidLat;
  final List<double>? bbox;
  final String? geomType;
  final int? nVertices;
  final String macroRegion;
  final List<String> predecessorsList;
  final int nPredecessors;
  final String embedText;
  final List<String> keywords;
  final String? parentTenXa;
  const AdministrativeUnit({
    required this.id,
    required this.kind,
    required this.ma,
    required this.ten,
    required this.type,
    required this.tenShort,
    this.areaKm2,
    this.population,
    this.density,
    this.capital,
    this.address,
    this.phone,
    required this.decree,
    required this.decreeUrl,
    this.predecessors,
    this.parentMa,
    this.parentTen,
    this.centroidLon,
    this.centroidLat,
    this.bbox,
    this.geomType,
    this.nVertices,
    required this.macroRegion,
    required this.predecessorsList,
    required this.nPredecessors,
    required this.embedText,
    required this.keywords,
    this.parentTenXa,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['ma'] = Variable<String>(ma);
    map['ten'] = Variable<String>(ten);
    map['type'] = Variable<String>(type);
    map['ten_short'] = Variable<String>(tenShort);
    if (!nullToAbsent || areaKm2 != null) {
      map['area_km2'] = Variable<double>(areaKm2);
    }
    if (!nullToAbsent || population != null) {
      map['population'] = Variable<double>(population);
    }
    if (!nullToAbsent || density != null) {
      map['density'] = Variable<double>(density);
    }
    if (!nullToAbsent || capital != null) {
      map['capital'] = Variable<String>(capital);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['decree'] = Variable<String>(decree);
    map['decree_url'] = Variable<String>(decreeUrl);
    if (!nullToAbsent || predecessors != null) {
      map['predecessors'] = Variable<String>(predecessors);
    }
    if (!nullToAbsent || parentMa != null) {
      map['parent_ma'] = Variable<String>(parentMa);
    }
    if (!nullToAbsent || parentTen != null) {
      map['parent_ten'] = Variable<String>(parentTen);
    }
    if (!nullToAbsent || centroidLon != null) {
      map['centroid_lon'] = Variable<double>(centroidLon);
    }
    if (!nullToAbsent || centroidLat != null) {
      map['centroid_lat'] = Variable<double>(centroidLat);
    }
    if (!nullToAbsent || bbox != null) {
      map['bbox'] = Variable<String>(
        $AdministrativeUnitsTable.$converterbboxn.toSql(bbox),
      );
    }
    if (!nullToAbsent || geomType != null) {
      map['geom_type'] = Variable<String>(geomType);
    }
    if (!nullToAbsent || nVertices != null) {
      map['n_vertices'] = Variable<int>(nVertices);
    }
    map['macro_region'] = Variable<String>(macroRegion);
    {
      map['predecessors_list'] = Variable<String>(
        $AdministrativeUnitsTable.$converterpredecessorsList.toSql(
          predecessorsList,
        ),
      );
    }
    map['n_predecessors'] = Variable<int>(nPredecessors);
    map['embed_text'] = Variable<String>(embedText);
    {
      map['keywords'] = Variable<String>(
        $AdministrativeUnitsTable.$converterkeywords.toSql(keywords),
      );
    }
    if (!nullToAbsent || parentTenXa != null) {
      map['parent_ten_xa'] = Variable<String>(parentTenXa);
    }
    return map;
  }

  AdministrativeUnitsCompanion toCompanion(bool nullToAbsent) {
    return AdministrativeUnitsCompanion(
      id: Value(id),
      kind: Value(kind),
      ma: Value(ma),
      ten: Value(ten),
      type: Value(type),
      tenShort: Value(tenShort),
      areaKm2: areaKm2 == null && nullToAbsent
          ? const Value.absent()
          : Value(areaKm2),
      population: population == null && nullToAbsent
          ? const Value.absent()
          : Value(population),
      density: density == null && nullToAbsent
          ? const Value.absent()
          : Value(density),
      capital: capital == null && nullToAbsent
          ? const Value.absent()
          : Value(capital),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      decree: Value(decree),
      decreeUrl: Value(decreeUrl),
      predecessors: predecessors == null && nullToAbsent
          ? const Value.absent()
          : Value(predecessors),
      parentMa: parentMa == null && nullToAbsent
          ? const Value.absent()
          : Value(parentMa),
      parentTen: parentTen == null && nullToAbsent
          ? const Value.absent()
          : Value(parentTen),
      centroidLon: centroidLon == null && nullToAbsent
          ? const Value.absent()
          : Value(centroidLon),
      centroidLat: centroidLat == null && nullToAbsent
          ? const Value.absent()
          : Value(centroidLat),
      bbox: bbox == null && nullToAbsent ? const Value.absent() : Value(bbox),
      geomType: geomType == null && nullToAbsent
          ? const Value.absent()
          : Value(geomType),
      nVertices: nVertices == null && nullToAbsent
          ? const Value.absent()
          : Value(nVertices),
      macroRegion: Value(macroRegion),
      predecessorsList: Value(predecessorsList),
      nPredecessors: Value(nPredecessors),
      embedText: Value(embedText),
      keywords: Value(keywords),
      parentTenXa: parentTenXa == null && nullToAbsent
          ? const Value.absent()
          : Value(parentTenXa),
    );
  }

  factory AdministrativeUnit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdministrativeUnit(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      ma: serializer.fromJson<String>(json['ma']),
      ten: serializer.fromJson<String>(json['ten']),
      type: serializer.fromJson<String>(json['type']),
      tenShort: serializer.fromJson<String>(json['tenShort']),
      areaKm2: serializer.fromJson<double?>(json['areaKm2']),
      population: serializer.fromJson<double?>(json['population']),
      density: serializer.fromJson<double?>(json['density']),
      capital: serializer.fromJson<String?>(json['capital']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      decree: serializer.fromJson<String>(json['decree']),
      decreeUrl: serializer.fromJson<String>(json['decreeUrl']),
      predecessors: serializer.fromJson<String?>(json['predecessors']),
      parentMa: serializer.fromJson<String?>(json['parentMa']),
      parentTen: serializer.fromJson<String?>(json['parentTen']),
      centroidLon: serializer.fromJson<double?>(json['centroidLon']),
      centroidLat: serializer.fromJson<double?>(json['centroidLat']),
      bbox: serializer.fromJson<List<double>?>(json['bbox']),
      geomType: serializer.fromJson<String?>(json['geomType']),
      nVertices: serializer.fromJson<int?>(json['nVertices']),
      macroRegion: serializer.fromJson<String>(json['macroRegion']),
      predecessorsList: serializer.fromJson<List<String>>(
        json['predecessorsList'],
      ),
      nPredecessors: serializer.fromJson<int>(json['nPredecessors']),
      embedText: serializer.fromJson<String>(json['embedText']),
      keywords: serializer.fromJson<List<String>>(json['keywords']),
      parentTenXa: serializer.fromJson<String?>(json['parentTenXa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'ma': serializer.toJson<String>(ma),
      'ten': serializer.toJson<String>(ten),
      'type': serializer.toJson<String>(type),
      'tenShort': serializer.toJson<String>(tenShort),
      'areaKm2': serializer.toJson<double?>(areaKm2),
      'population': serializer.toJson<double?>(population),
      'density': serializer.toJson<double?>(density),
      'capital': serializer.toJson<String?>(capital),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'decree': serializer.toJson<String>(decree),
      'decreeUrl': serializer.toJson<String>(decreeUrl),
      'predecessors': serializer.toJson<String?>(predecessors),
      'parentMa': serializer.toJson<String?>(parentMa),
      'parentTen': serializer.toJson<String?>(parentTen),
      'centroidLon': serializer.toJson<double?>(centroidLon),
      'centroidLat': serializer.toJson<double?>(centroidLat),
      'bbox': serializer.toJson<List<double>?>(bbox),
      'geomType': serializer.toJson<String?>(geomType),
      'nVertices': serializer.toJson<int?>(nVertices),
      'macroRegion': serializer.toJson<String>(macroRegion),
      'predecessorsList': serializer.toJson<List<String>>(predecessorsList),
      'nPredecessors': serializer.toJson<int>(nPredecessors),
      'embedText': serializer.toJson<String>(embedText),
      'keywords': serializer.toJson<List<String>>(keywords),
      'parentTenXa': serializer.toJson<String?>(parentTenXa),
    };
  }

  AdministrativeUnit copyWith({
    String? id,
    String? kind,
    String? ma,
    String? ten,
    String? type,
    String? tenShort,
    Value<double?> areaKm2 = const Value.absent(),
    Value<double?> population = const Value.absent(),
    Value<double?> density = const Value.absent(),
    Value<String?> capital = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    String? decree,
    String? decreeUrl,
    Value<String?> predecessors = const Value.absent(),
    Value<String?> parentMa = const Value.absent(),
    Value<String?> parentTen = const Value.absent(),
    Value<double?> centroidLon = const Value.absent(),
    Value<double?> centroidLat = const Value.absent(),
    Value<List<double>?> bbox = const Value.absent(),
    Value<String?> geomType = const Value.absent(),
    Value<int?> nVertices = const Value.absent(),
    String? macroRegion,
    List<String>? predecessorsList,
    int? nPredecessors,
    String? embedText,
    List<String>? keywords,
    Value<String?> parentTenXa = const Value.absent(),
  }) => AdministrativeUnit(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    ma: ma ?? this.ma,
    ten: ten ?? this.ten,
    type: type ?? this.type,
    tenShort: tenShort ?? this.tenShort,
    areaKm2: areaKm2.present ? areaKm2.value : this.areaKm2,
    population: population.present ? population.value : this.population,
    density: density.present ? density.value : this.density,
    capital: capital.present ? capital.value : this.capital,
    address: address.present ? address.value : this.address,
    phone: phone.present ? phone.value : this.phone,
    decree: decree ?? this.decree,
    decreeUrl: decreeUrl ?? this.decreeUrl,
    predecessors: predecessors.present ? predecessors.value : this.predecessors,
    parentMa: parentMa.present ? parentMa.value : this.parentMa,
    parentTen: parentTen.present ? parentTen.value : this.parentTen,
    centroidLon: centroidLon.present ? centroidLon.value : this.centroidLon,
    centroidLat: centroidLat.present ? centroidLat.value : this.centroidLat,
    bbox: bbox.present ? bbox.value : this.bbox,
    geomType: geomType.present ? geomType.value : this.geomType,
    nVertices: nVertices.present ? nVertices.value : this.nVertices,
    macroRegion: macroRegion ?? this.macroRegion,
    predecessorsList: predecessorsList ?? this.predecessorsList,
    nPredecessors: nPredecessors ?? this.nPredecessors,
    embedText: embedText ?? this.embedText,
    keywords: keywords ?? this.keywords,
    parentTenXa: parentTenXa.present ? parentTenXa.value : this.parentTenXa,
  );
  AdministrativeUnit copyWithCompanion(AdministrativeUnitsCompanion data) {
    return AdministrativeUnit(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      ma: data.ma.present ? data.ma.value : this.ma,
      ten: data.ten.present ? data.ten.value : this.ten,
      type: data.type.present ? data.type.value : this.type,
      tenShort: data.tenShort.present ? data.tenShort.value : this.tenShort,
      areaKm2: data.areaKm2.present ? data.areaKm2.value : this.areaKm2,
      population: data.population.present
          ? data.population.value
          : this.population,
      density: data.density.present ? data.density.value : this.density,
      capital: data.capital.present ? data.capital.value : this.capital,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      decree: data.decree.present ? data.decree.value : this.decree,
      decreeUrl: data.decreeUrl.present ? data.decreeUrl.value : this.decreeUrl,
      predecessors: data.predecessors.present
          ? data.predecessors.value
          : this.predecessors,
      parentMa: data.parentMa.present ? data.parentMa.value : this.parentMa,
      parentTen: data.parentTen.present ? data.parentTen.value : this.parentTen,
      centroidLon: data.centroidLon.present
          ? data.centroidLon.value
          : this.centroidLon,
      centroidLat: data.centroidLat.present
          ? data.centroidLat.value
          : this.centroidLat,
      bbox: data.bbox.present ? data.bbox.value : this.bbox,
      geomType: data.geomType.present ? data.geomType.value : this.geomType,
      nVertices: data.nVertices.present ? data.nVertices.value : this.nVertices,
      macroRegion: data.macroRegion.present
          ? data.macroRegion.value
          : this.macroRegion,
      predecessorsList: data.predecessorsList.present
          ? data.predecessorsList.value
          : this.predecessorsList,
      nPredecessors: data.nPredecessors.present
          ? data.nPredecessors.value
          : this.nPredecessors,
      embedText: data.embedText.present ? data.embedText.value : this.embedText,
      keywords: data.keywords.present ? data.keywords.value : this.keywords,
      parentTenXa: data.parentTenXa.present
          ? data.parentTenXa.value
          : this.parentTenXa,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdministrativeUnit(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('ma: $ma, ')
          ..write('ten: $ten, ')
          ..write('type: $type, ')
          ..write('tenShort: $tenShort, ')
          ..write('areaKm2: $areaKm2, ')
          ..write('population: $population, ')
          ..write('density: $density, ')
          ..write('capital: $capital, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('decree: $decree, ')
          ..write('decreeUrl: $decreeUrl, ')
          ..write('predecessors: $predecessors, ')
          ..write('parentMa: $parentMa, ')
          ..write('parentTen: $parentTen, ')
          ..write('centroidLon: $centroidLon, ')
          ..write('centroidLat: $centroidLat, ')
          ..write('bbox: $bbox, ')
          ..write('geomType: $geomType, ')
          ..write('nVertices: $nVertices, ')
          ..write('macroRegion: $macroRegion, ')
          ..write('predecessorsList: $predecessorsList, ')
          ..write('nPredecessors: $nPredecessors, ')
          ..write('embedText: $embedText, ')
          ..write('keywords: $keywords, ')
          ..write('parentTenXa: $parentTenXa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    kind,
    ma,
    ten,
    type,
    tenShort,
    areaKm2,
    population,
    density,
    capital,
    address,
    phone,
    decree,
    decreeUrl,
    predecessors,
    parentMa,
    parentTen,
    centroidLon,
    centroidLat,
    bbox,
    geomType,
    nVertices,
    macroRegion,
    predecessorsList,
    nPredecessors,
    embedText,
    keywords,
    parentTenXa,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdministrativeUnit &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.ma == this.ma &&
          other.ten == this.ten &&
          other.type == this.type &&
          other.tenShort == this.tenShort &&
          other.areaKm2 == this.areaKm2 &&
          other.population == this.population &&
          other.density == this.density &&
          other.capital == this.capital &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.decree == this.decree &&
          other.decreeUrl == this.decreeUrl &&
          other.predecessors == this.predecessors &&
          other.parentMa == this.parentMa &&
          other.parentTen == this.parentTen &&
          other.centroidLon == this.centroidLon &&
          other.centroidLat == this.centroidLat &&
          other.bbox == this.bbox &&
          other.geomType == this.geomType &&
          other.nVertices == this.nVertices &&
          other.macroRegion == this.macroRegion &&
          other.predecessorsList == this.predecessorsList &&
          other.nPredecessors == this.nPredecessors &&
          other.embedText == this.embedText &&
          other.keywords == this.keywords &&
          other.parentTenXa == this.parentTenXa);
}

class AdministrativeUnitsCompanion extends UpdateCompanion<AdministrativeUnit> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String> ma;
  final Value<String> ten;
  final Value<String> type;
  final Value<String> tenShort;
  final Value<double?> areaKm2;
  final Value<double?> population;
  final Value<double?> density;
  final Value<String?> capital;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String> decree;
  final Value<String> decreeUrl;
  final Value<String?> predecessors;
  final Value<String?> parentMa;
  final Value<String?> parentTen;
  final Value<double?> centroidLon;
  final Value<double?> centroidLat;
  final Value<List<double>?> bbox;
  final Value<String?> geomType;
  final Value<int?> nVertices;
  final Value<String> macroRegion;
  final Value<List<String>> predecessorsList;
  final Value<int> nPredecessors;
  final Value<String> embedText;
  final Value<List<String>> keywords;
  final Value<String?> parentTenXa;
  final Value<int> rowid;
  const AdministrativeUnitsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.ma = const Value.absent(),
    this.ten = const Value.absent(),
    this.type = const Value.absent(),
    this.tenShort = const Value.absent(),
    this.areaKm2 = const Value.absent(),
    this.population = const Value.absent(),
    this.density = const Value.absent(),
    this.capital = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.decree = const Value.absent(),
    this.decreeUrl = const Value.absent(),
    this.predecessors = const Value.absent(),
    this.parentMa = const Value.absent(),
    this.parentTen = const Value.absent(),
    this.centroidLon = const Value.absent(),
    this.centroidLat = const Value.absent(),
    this.bbox = const Value.absent(),
    this.geomType = const Value.absent(),
    this.nVertices = const Value.absent(),
    this.macroRegion = const Value.absent(),
    this.predecessorsList = const Value.absent(),
    this.nPredecessors = const Value.absent(),
    this.embedText = const Value.absent(),
    this.keywords = const Value.absent(),
    this.parentTenXa = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AdministrativeUnitsCompanion.insert({
    required String id,
    required String kind,
    required String ma,
    required String ten,
    required String type,
    required String tenShort,
    this.areaKm2 = const Value.absent(),
    this.population = const Value.absent(),
    this.density = const Value.absent(),
    this.capital = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    required String decree,
    required String decreeUrl,
    this.predecessors = const Value.absent(),
    this.parentMa = const Value.absent(),
    this.parentTen = const Value.absent(),
    this.centroidLon = const Value.absent(),
    this.centroidLat = const Value.absent(),
    this.bbox = const Value.absent(),
    this.geomType = const Value.absent(),
    this.nVertices = const Value.absent(),
    required String macroRegion,
    required List<String> predecessorsList,
    required int nPredecessors,
    required String embedText,
    required List<String> keywords,
    this.parentTenXa = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       ma = Value(ma),
       ten = Value(ten),
       type = Value(type),
       tenShort = Value(tenShort),
       decree = Value(decree),
       decreeUrl = Value(decreeUrl),
       macroRegion = Value(macroRegion),
       predecessorsList = Value(predecessorsList),
       nPredecessors = Value(nPredecessors),
       embedText = Value(embedText),
       keywords = Value(keywords);
  static Insertable<AdministrativeUnit> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? ma,
    Expression<String>? ten,
    Expression<String>? type,
    Expression<String>? tenShort,
    Expression<double>? areaKm2,
    Expression<double>? population,
    Expression<double>? density,
    Expression<String>? capital,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? decree,
    Expression<String>? decreeUrl,
    Expression<String>? predecessors,
    Expression<String>? parentMa,
    Expression<String>? parentTen,
    Expression<double>? centroidLon,
    Expression<double>? centroidLat,
    Expression<String>? bbox,
    Expression<String>? geomType,
    Expression<int>? nVertices,
    Expression<String>? macroRegion,
    Expression<String>? predecessorsList,
    Expression<int>? nPredecessors,
    Expression<String>? embedText,
    Expression<String>? keywords,
    Expression<String>? parentTenXa,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (ma != null) 'ma': ma,
      if (ten != null) 'ten': ten,
      if (type != null) 'type': type,
      if (tenShort != null) 'ten_short': tenShort,
      if (areaKm2 != null) 'area_km2': areaKm2,
      if (population != null) 'population': population,
      if (density != null) 'density': density,
      if (capital != null) 'capital': capital,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (decree != null) 'decree': decree,
      if (decreeUrl != null) 'decree_url': decreeUrl,
      if (predecessors != null) 'predecessors': predecessors,
      if (parentMa != null) 'parent_ma': parentMa,
      if (parentTen != null) 'parent_ten': parentTen,
      if (centroidLon != null) 'centroid_lon': centroidLon,
      if (centroidLat != null) 'centroid_lat': centroidLat,
      if (bbox != null) 'bbox': bbox,
      if (geomType != null) 'geom_type': geomType,
      if (nVertices != null) 'n_vertices': nVertices,
      if (macroRegion != null) 'macro_region': macroRegion,
      if (predecessorsList != null) 'predecessors_list': predecessorsList,
      if (nPredecessors != null) 'n_predecessors': nPredecessors,
      if (embedText != null) 'embed_text': embedText,
      if (keywords != null) 'keywords': keywords,
      if (parentTenXa != null) 'parent_ten_xa': parentTenXa,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AdministrativeUnitsCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String>? ma,
    Value<String>? ten,
    Value<String>? type,
    Value<String>? tenShort,
    Value<double?>? areaKm2,
    Value<double?>? population,
    Value<double?>? density,
    Value<String?>? capital,
    Value<String?>? address,
    Value<String?>? phone,
    Value<String>? decree,
    Value<String>? decreeUrl,
    Value<String?>? predecessors,
    Value<String?>? parentMa,
    Value<String?>? parentTen,
    Value<double?>? centroidLon,
    Value<double?>? centroidLat,
    Value<List<double>?>? bbox,
    Value<String?>? geomType,
    Value<int?>? nVertices,
    Value<String>? macroRegion,
    Value<List<String>>? predecessorsList,
    Value<int>? nPredecessors,
    Value<String>? embedText,
    Value<List<String>>? keywords,
    Value<String?>? parentTenXa,
    Value<int>? rowid,
  }) {
    return AdministrativeUnitsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      ma: ma ?? this.ma,
      ten: ten ?? this.ten,
      type: type ?? this.type,
      tenShort: tenShort ?? this.tenShort,
      areaKm2: areaKm2 ?? this.areaKm2,
      population: population ?? this.population,
      density: density ?? this.density,
      capital: capital ?? this.capital,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      decree: decree ?? this.decree,
      decreeUrl: decreeUrl ?? this.decreeUrl,
      predecessors: predecessors ?? this.predecessors,
      parentMa: parentMa ?? this.parentMa,
      parentTen: parentTen ?? this.parentTen,
      centroidLon: centroidLon ?? this.centroidLon,
      centroidLat: centroidLat ?? this.centroidLat,
      bbox: bbox ?? this.bbox,
      geomType: geomType ?? this.geomType,
      nVertices: nVertices ?? this.nVertices,
      macroRegion: macroRegion ?? this.macroRegion,
      predecessorsList: predecessorsList ?? this.predecessorsList,
      nPredecessors: nPredecessors ?? this.nPredecessors,
      embedText: embedText ?? this.embedText,
      keywords: keywords ?? this.keywords,
      parentTenXa: parentTenXa ?? this.parentTenXa,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (ma.present) {
      map['ma'] = Variable<String>(ma.value);
    }
    if (ten.present) {
      map['ten'] = Variable<String>(ten.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (tenShort.present) {
      map['ten_short'] = Variable<String>(tenShort.value);
    }
    if (areaKm2.present) {
      map['area_km2'] = Variable<double>(areaKm2.value);
    }
    if (population.present) {
      map['population'] = Variable<double>(population.value);
    }
    if (density.present) {
      map['density'] = Variable<double>(density.value);
    }
    if (capital.present) {
      map['capital'] = Variable<String>(capital.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (decree.present) {
      map['decree'] = Variable<String>(decree.value);
    }
    if (decreeUrl.present) {
      map['decree_url'] = Variable<String>(decreeUrl.value);
    }
    if (predecessors.present) {
      map['predecessors'] = Variable<String>(predecessors.value);
    }
    if (parentMa.present) {
      map['parent_ma'] = Variable<String>(parentMa.value);
    }
    if (parentTen.present) {
      map['parent_ten'] = Variable<String>(parentTen.value);
    }
    if (centroidLon.present) {
      map['centroid_lon'] = Variable<double>(centroidLon.value);
    }
    if (centroidLat.present) {
      map['centroid_lat'] = Variable<double>(centroidLat.value);
    }
    if (bbox.present) {
      map['bbox'] = Variable<String>(
        $AdministrativeUnitsTable.$converterbboxn.toSql(bbox.value),
      );
    }
    if (geomType.present) {
      map['geom_type'] = Variable<String>(geomType.value);
    }
    if (nVertices.present) {
      map['n_vertices'] = Variable<int>(nVertices.value);
    }
    if (macroRegion.present) {
      map['macro_region'] = Variable<String>(macroRegion.value);
    }
    if (predecessorsList.present) {
      map['predecessors_list'] = Variable<String>(
        $AdministrativeUnitsTable.$converterpredecessorsList.toSql(
          predecessorsList.value,
        ),
      );
    }
    if (nPredecessors.present) {
      map['n_predecessors'] = Variable<int>(nPredecessors.value);
    }
    if (embedText.present) {
      map['embed_text'] = Variable<String>(embedText.value);
    }
    if (keywords.present) {
      map['keywords'] = Variable<String>(
        $AdministrativeUnitsTable.$converterkeywords.toSql(keywords.value),
      );
    }
    if (parentTenXa.present) {
      map['parent_ten_xa'] = Variable<String>(parentTenXa.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdministrativeUnitsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('ma: $ma, ')
          ..write('ten: $ten, ')
          ..write('type: $type, ')
          ..write('tenShort: $tenShort, ')
          ..write('areaKm2: $areaKm2, ')
          ..write('population: $population, ')
          ..write('density: $density, ')
          ..write('capital: $capital, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('decree: $decree, ')
          ..write('decreeUrl: $decreeUrl, ')
          ..write('predecessors: $predecessors, ')
          ..write('parentMa: $parentMa, ')
          ..write('parentTen: $parentTen, ')
          ..write('centroidLon: $centroidLon, ')
          ..write('centroidLat: $centroidLat, ')
          ..write('bbox: $bbox, ')
          ..write('geomType: $geomType, ')
          ..write('nVertices: $nVertices, ')
          ..write('macroRegion: $macroRegion, ')
          ..write('predecessorsList: $predecessorsList, ')
          ..write('nPredecessors: $nPredecessors, ')
          ..write('embedText: $embedText, ')
          ..write('keywords: $keywords, ')
          ..write('parentTenXa: $parentTenXa, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HistoricalEventsTable extends HistoricalEvents
    with TableInfo<$HistoricalEventsTable, HistoricalEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoricalEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startYearMeta = const VerificationMeta(
    'startYear',
  );
  @override
  late final GeneratedColumn<int> startYear = GeneratedColumn<int>(
    'start_year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endYearMeta = const VerificationMeta(
    'endYear',
  );
  @override
  late final GeneratedColumn<int> endYear = GeneratedColumn<int>(
    'end_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relatedProvinceMasMeta =
      const VerificationMeta('relatedProvinceMas');
  @override
  late final GeneratedColumn<String> relatedProvinceMas =
      GeneratedColumn<String>(
        'related_province_mas',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    startYear,
    endYear,
    eventType,
    relatedProvinceMas,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historical_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistoricalEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('start_year')) {
      context.handle(
        _startYearMeta,
        startYear.isAcceptableOrUnknown(data['start_year']!, _startYearMeta),
      );
    } else if (isInserting) {
      context.missing(_startYearMeta);
    }
    if (data.containsKey('end_year')) {
      context.handle(
        _endYearMeta,
        endYear.isAcceptableOrUnknown(data['end_year']!, _endYearMeta),
      );
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('related_province_mas')) {
      context.handle(
        _relatedProvinceMasMeta,
        relatedProvinceMas.isAcceptableOrUnknown(
          data['related_province_mas']!,
          _relatedProvinceMasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relatedProvinceMasMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoricalEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoricalEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      startYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_year'],
      )!,
      endYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_year'],
      ),
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      relatedProvinceMas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_province_mas'],
      )!,
    );
  }

  @override
  $HistoricalEventsTable createAlias(String alias) {
    return $HistoricalEventsTable(attachedDatabase, alias);
  }
}

class HistoricalEvent extends DataClass implements Insertable<HistoricalEvent> {
  final int id;
  final String title;
  final String description;
  final int startYear;
  final int? endYear;
  final String eventType;
  final String relatedProvinceMas;
  const HistoricalEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startYear,
    this.endYear,
    required this.eventType,
    required this.relatedProvinceMas,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['start_year'] = Variable<int>(startYear);
    if (!nullToAbsent || endYear != null) {
      map['end_year'] = Variable<int>(endYear);
    }
    map['event_type'] = Variable<String>(eventType);
    map['related_province_mas'] = Variable<String>(relatedProvinceMas);
    return map;
  }

  HistoricalEventsCompanion toCompanion(bool nullToAbsent) {
    return HistoricalEventsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      startYear: Value(startYear),
      endYear: endYear == null && nullToAbsent
          ? const Value.absent()
          : Value(endYear),
      eventType: Value(eventType),
      relatedProvinceMas: Value(relatedProvinceMas),
    );
  }

  factory HistoricalEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoricalEvent(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      startYear: serializer.fromJson<int>(json['startYear']),
      endYear: serializer.fromJson<int?>(json['endYear']),
      eventType: serializer.fromJson<String>(json['eventType']),
      relatedProvinceMas: serializer.fromJson<String>(
        json['relatedProvinceMas'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'startYear': serializer.toJson<int>(startYear),
      'endYear': serializer.toJson<int?>(endYear),
      'eventType': serializer.toJson<String>(eventType),
      'relatedProvinceMas': serializer.toJson<String>(relatedProvinceMas),
    };
  }

  HistoricalEvent copyWith({
    int? id,
    String? title,
    String? description,
    int? startYear,
    Value<int?> endYear = const Value.absent(),
    String? eventType,
    String? relatedProvinceMas,
  }) => HistoricalEvent(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    startYear: startYear ?? this.startYear,
    endYear: endYear.present ? endYear.value : this.endYear,
    eventType: eventType ?? this.eventType,
    relatedProvinceMas: relatedProvinceMas ?? this.relatedProvinceMas,
  );
  HistoricalEvent copyWithCompanion(HistoricalEventsCompanion data) {
    return HistoricalEvent(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      startYear: data.startYear.present ? data.startYear.value : this.startYear,
      endYear: data.endYear.present ? data.endYear.value : this.endYear,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      relatedProvinceMas: data.relatedProvinceMas.present
          ? data.relatedProvinceMas.value
          : this.relatedProvinceMas,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoricalEvent(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startYear: $startYear, ')
          ..write('endYear: $endYear, ')
          ..write('eventType: $eventType, ')
          ..write('relatedProvinceMas: $relatedProvinceMas')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    startYear,
    endYear,
    eventType,
    relatedProvinceMas,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoricalEvent &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.startYear == this.startYear &&
          other.endYear == this.endYear &&
          other.eventType == this.eventType &&
          other.relatedProvinceMas == this.relatedProvinceMas);
}

class HistoricalEventsCompanion extends UpdateCompanion<HistoricalEvent> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<int> startYear;
  final Value<int?> endYear;
  final Value<String> eventType;
  final Value<String> relatedProvinceMas;
  const HistoricalEventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.startYear = const Value.absent(),
    this.endYear = const Value.absent(),
    this.eventType = const Value.absent(),
    this.relatedProvinceMas = const Value.absent(),
  });
  HistoricalEventsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    required int startYear,
    this.endYear = const Value.absent(),
    required String eventType,
    required String relatedProvinceMas,
  }) : title = Value(title),
       description = Value(description),
       startYear = Value(startYear),
       eventType = Value(eventType),
       relatedProvinceMas = Value(relatedProvinceMas);
  static Insertable<HistoricalEvent> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? startYear,
    Expression<int>? endYear,
    Expression<String>? eventType,
    Expression<String>? relatedProvinceMas,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (startYear != null) 'start_year': startYear,
      if (endYear != null) 'end_year': endYear,
      if (eventType != null) 'event_type': eventType,
      if (relatedProvinceMas != null)
        'related_province_mas': relatedProvinceMas,
    });
  }

  HistoricalEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? description,
    Value<int>? startYear,
    Value<int?>? endYear,
    Value<String>? eventType,
    Value<String>? relatedProvinceMas,
  }) {
    return HistoricalEventsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      eventType: eventType ?? this.eventType,
      relatedProvinceMas: relatedProvinceMas ?? this.relatedProvinceMas,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startYear.present) {
      map['start_year'] = Variable<int>(startYear.value);
    }
    if (endYear.present) {
      map['end_year'] = Variable<int>(endYear.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (relatedProvinceMas.present) {
      map['related_province_mas'] = Variable<String>(relatedProvinceMas.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoricalEventsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startYear: $startYear, ')
          ..write('endYear: $endYear, ')
          ..write('eventType: $eventType, ')
          ..write('relatedProvinceMas: $relatedProvinceMas')
          ..write(')'))
        .toString();
  }
}

class $GeoJsonCachesTable extends GeoJsonCaches
    with TableInfo<$GeoJsonCachesTable, GeoJsonCache> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeoJsonCachesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _maMeta = const VerificationMeta('ma');
  @override
  late final GeneratedColumn<String> ma = GeneratedColumn<String>(
    'ma',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _geoJsonDataMeta = const VerificationMeta(
    'geoJsonData',
  );
  @override
  late final GeneratedColumn<String> geoJsonData = GeneratedColumn<String>(
    'geo_json_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [ma, geoJsonData];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'geo_json_caches';
  @override
  VerificationContext validateIntegrity(
    Insertable<GeoJsonCache> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ma')) {
      context.handle(_maMeta, ma.isAcceptableOrUnknown(data['ma']!, _maMeta));
    } else if (isInserting) {
      context.missing(_maMeta);
    }
    if (data.containsKey('geo_json_data')) {
      context.handle(
        _geoJsonDataMeta,
        geoJsonData.isAcceptableOrUnknown(
          data['geo_json_data']!,
          _geoJsonDataMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_geoJsonDataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ma};
  @override
  GeoJsonCache map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GeoJsonCache(
      ma: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ma'],
      )!,
      geoJsonData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}geo_json_data'],
      )!,
    );
  }

  @override
  $GeoJsonCachesTable createAlias(String alias) {
    return $GeoJsonCachesTable(attachedDatabase, alias);
  }
}

class GeoJsonCache extends DataClass implements Insertable<GeoJsonCache> {
  final String ma;
  final String geoJsonData;
  const GeoJsonCache({required this.ma, required this.geoJsonData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ma'] = Variable<String>(ma);
    map['geo_json_data'] = Variable<String>(geoJsonData);
    return map;
  }

  GeoJsonCachesCompanion toCompanion(bool nullToAbsent) {
    return GeoJsonCachesCompanion(
      ma: Value(ma),
      geoJsonData: Value(geoJsonData),
    );
  }

  factory GeoJsonCache.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GeoJsonCache(
      ma: serializer.fromJson<String>(json['ma']),
      geoJsonData: serializer.fromJson<String>(json['geoJsonData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ma': serializer.toJson<String>(ma),
      'geoJsonData': serializer.toJson<String>(geoJsonData),
    };
  }

  GeoJsonCache copyWith({String? ma, String? geoJsonData}) => GeoJsonCache(
    ma: ma ?? this.ma,
    geoJsonData: geoJsonData ?? this.geoJsonData,
  );
  GeoJsonCache copyWithCompanion(GeoJsonCachesCompanion data) {
    return GeoJsonCache(
      ma: data.ma.present ? data.ma.value : this.ma,
      geoJsonData: data.geoJsonData.present
          ? data.geoJsonData.value
          : this.geoJsonData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GeoJsonCache(')
          ..write('ma: $ma, ')
          ..write('geoJsonData: $geoJsonData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ma, geoJsonData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeoJsonCache &&
          other.ma == this.ma &&
          other.geoJsonData == this.geoJsonData);
}

class GeoJsonCachesCompanion extends UpdateCompanion<GeoJsonCache> {
  final Value<String> ma;
  final Value<String> geoJsonData;
  final Value<int> rowid;
  const GeoJsonCachesCompanion({
    this.ma = const Value.absent(),
    this.geoJsonData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GeoJsonCachesCompanion.insert({
    required String ma,
    required String geoJsonData,
    this.rowid = const Value.absent(),
  }) : ma = Value(ma),
       geoJsonData = Value(geoJsonData);
  static Insertable<GeoJsonCache> custom({
    Expression<String>? ma,
    Expression<String>? geoJsonData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ma != null) 'ma': ma,
      if (geoJsonData != null) 'geo_json_data': geoJsonData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GeoJsonCachesCompanion copyWith({
    Value<String>? ma,
    Value<String>? geoJsonData,
    Value<int>? rowid,
  }) {
    return GeoJsonCachesCompanion(
      ma: ma ?? this.ma,
      geoJsonData: geoJsonData ?? this.geoJsonData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ma.present) {
      map['ma'] = Variable<String>(ma.value);
    }
    if (geoJsonData.present) {
      map['geo_json_data'] = Variable<String>(geoJsonData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeoJsonCachesCompanion(')
          ..write('ma: $ma, ')
          ..write('geoJsonData: $geoJsonData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatHistoryMessagesTable extends ChatHistoryMessages
    with TableInfo<$ChatHistoryMessagesTable, ChatHistoryMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatHistoryMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextJsonMeta = const VerificationMeta(
    'contextJson',
  );
  @override
  late final GeneratedColumn<String> contextJson = GeneratedColumn<String>(
    'context_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    role,
    content,
    timestamp,
    contextJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_history_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatHistoryMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('context_json')) {
      context.handle(
        _contextJsonMeta,
        contextJson.isAcceptableOrUnknown(
          data['context_json']!,
          _contextJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatHistoryMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatHistoryMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      contextJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_json'],
      ),
    );
  }

  @override
  $ChatHistoryMessagesTable createAlias(String alias) {
    return $ChatHistoryMessagesTable(attachedDatabase, alias);
  }
}

class ChatHistoryMessage extends DataClass
    implements Insertable<ChatHistoryMessage> {
  final String id;
  final String role;
  final String content;
  final DateTime timestamp;
  final String? contextJson;
  const ChatHistoryMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.contextJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || contextJson != null) {
      map['context_json'] = Variable<String>(contextJson);
    }
    return map;
  }

  ChatHistoryMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatHistoryMessagesCompanion(
      id: Value(id),
      role: Value(role),
      content: Value(content),
      timestamp: Value(timestamp),
      contextJson: contextJson == null && nullToAbsent
          ? const Value.absent()
          : Value(contextJson),
    );
  }

  factory ChatHistoryMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatHistoryMessage(
      id: serializer.fromJson<String>(json['id']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      contextJson: serializer.fromJson<String?>(json['contextJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'contextJson': serializer.toJson<String?>(contextJson),
    };
  }

  ChatHistoryMessage copyWith({
    String? id,
    String? role,
    String? content,
    DateTime? timestamp,
    Value<String?> contextJson = const Value.absent(),
  }) => ChatHistoryMessage(
    id: id ?? this.id,
    role: role ?? this.role,
    content: content ?? this.content,
    timestamp: timestamp ?? this.timestamp,
    contextJson: contextJson.present ? contextJson.value : this.contextJson,
  );
  ChatHistoryMessage copyWithCompanion(ChatHistoryMessagesCompanion data) {
    return ChatHistoryMessage(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      contextJson: data.contextJson.present
          ? data.contextJson.value
          : this.contextJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatHistoryMessage(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('contextJson: $contextJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, role, content, timestamp, contextJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatHistoryMessage &&
          other.id == this.id &&
          other.role == this.role &&
          other.content == this.content &&
          other.timestamp == this.timestamp &&
          other.contextJson == this.contextJson);
}

class ChatHistoryMessagesCompanion extends UpdateCompanion<ChatHistoryMessage> {
  final Value<String> id;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> timestamp;
  final Value<String?> contextJson;
  final Value<int> rowid;
  const ChatHistoryMessagesCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.contextJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatHistoryMessagesCompanion.insert({
    required String id,
    required String role,
    required String content,
    required DateTime timestamp,
    this.contextJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       role = Value(role),
       content = Value(content),
       timestamp = Value(timestamp);
  static Insertable<ChatHistoryMessage> custom({
    Expression<String>? id,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? timestamp,
    Expression<String>? contextJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp,
      if (contextJson != null) 'context_json': contextJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatHistoryMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? role,
    Value<String>? content,
    Value<DateTime>? timestamp,
    Value<String?>? contextJson,
    Value<int>? rowid,
  }) {
    return ChatHistoryMessagesCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      contextJson: contextJson ?? this.contextJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (contextJson.present) {
      map['context_json'] = Variable<String>(contextJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatHistoryMessagesCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('contextJson: $contextJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TourismPlacesTable extends TourismPlaces
    with TableInfo<$TourismPlacesTable, TourismPlace> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TourismPlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _osmIdMeta = const VerificationMeta('osmId');
  @override
  late final GeneratedColumn<int> osmId = GeneratedColumn<int>(
    'osm_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameZhMeta = const VerificationMeta('nameZh');
  @override
  late final GeneratedColumn<String> nameZh = GeneratedColumn<String>(
    'name_zh',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wikiSummaryMeta = const VerificationMeta(
    'wikiSummary',
  );
  @override
  late final GeneratedColumn<String> wikiSummary = GeneratedColumn<String>(
    'wiki_summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _openingHoursMeta = const VerificationMeta(
    'openingHours',
  );
  @override
  late final GeneratedColumn<String> openingHours = GeneratedColumn<String>(
    'opening_hours',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wikidataMeta = const VerificationMeta(
    'wikidata',
  );
  @override
  late final GeneratedColumn<String> wikidata = GeneratedColumn<String>(
    'wikidata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wikipediaMeta = const VerificationMeta(
    'wikipedia',
  );
  @override
  late final GeneratedColumn<String> wikipedia = GeneratedColumn<String>(
    'wikipedia',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _provinceMaMeta = const VerificationMeta(
    'provinceMa',
  );
  @override
  late final GeneratedColumn<String> provinceMa = GeneratedColumn<String>(
    'province_ma',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wikiLastFetchedMeta = const VerificationMeta(
    'wikiLastFetched',
  );
  @override
  late final GeneratedColumn<DateTime> wikiLastFetched =
      GeneratedColumn<DateTime>(
        'wiki_last_fetched',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    osmId,
    name,
    nameEn,
    nameZh,
    category,
    lat,
    lon,
    description,
    wikiSummary,
    thumbnailUrl,
    website,
    openingHours,
    phone,
    wikidata,
    wikipedia,
    provinceMa,
    wikiLastFetched,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tourism_places';
  @override
  VerificationContext validateIntegrity(
    Insertable<TourismPlace> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('osm_id')) {
      context.handle(
        _osmIdMeta,
        osmId.isAcceptableOrUnknown(data['osm_id']!, _osmIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('name_zh')) {
      context.handle(
        _nameZhMeta,
        nameZh.isAcceptableOrUnknown(data['name_zh']!, _nameZhMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('wiki_summary')) {
      context.handle(
        _wikiSummaryMeta,
        wikiSummary.isAcceptableOrUnknown(
          data['wiki_summary']!,
          _wikiSummaryMeta,
        ),
      );
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('opening_hours')) {
      context.handle(
        _openingHoursMeta,
        openingHours.isAcceptableOrUnknown(
          data['opening_hours']!,
          _openingHoursMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('wikidata')) {
      context.handle(
        _wikidataMeta,
        wikidata.isAcceptableOrUnknown(data['wikidata']!, _wikidataMeta),
      );
    }
    if (data.containsKey('wikipedia')) {
      context.handle(
        _wikipediaMeta,
        wikipedia.isAcceptableOrUnknown(data['wikipedia']!, _wikipediaMeta),
      );
    }
    if (data.containsKey('province_ma')) {
      context.handle(
        _provinceMaMeta,
        provinceMa.isAcceptableOrUnknown(data['province_ma']!, _provinceMaMeta),
      );
    }
    if (data.containsKey('wiki_last_fetched')) {
      context.handle(
        _wikiLastFetchedMeta,
        wikiLastFetched.isAcceptableOrUnknown(
          data['wiki_last_fetched']!,
          _wikiLastFetchedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {osmId};
  @override
  TourismPlace map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TourismPlace(
      osmId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}osm_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      nameZh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_zh'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      wikiSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wiki_summary'],
      ),
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      openingHours: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opening_hours'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      wikidata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wikidata'],
      ),
      wikipedia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wikipedia'],
      ),
      provinceMa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}province_ma'],
      ),
      wikiLastFetched: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}wiki_last_fetched'],
      ),
    );
  }

  @override
  $TourismPlacesTable createAlias(String alias) {
    return $TourismPlacesTable(attachedDatabase, alias);
  }
}

class TourismPlace extends DataClass implements Insertable<TourismPlace> {
  /// OSM element ID — primary key
  final int osmId;

  /// Tên tiếng Việt (name tag trong OSM)
  final String name;

  /// Tên tiếng Anh (name:en)
  final String? nameEn;

  /// Tên tiếng Trung (name:zh) — hữu ích cho khách Trung
  final String? nameZh;

  /// Category: 'attraction' | 'museum' | 'ruins' | 'temple' |
  ///           'viewpoint' | 'worldHeritage'
  final String category;

  /// Latitude
  final double lat;

  /// Longitude
  final double lon;

  /// Mô tả từ OSM (description tag)
  final String? description;

  /// Mô tả tiếng Anh từ Wikipedia (cache sau khi fetch)
  final String? wikiSummary;

  /// URL ảnh thumbnail từ Wikipedia
  final String? thumbnailUrl;

  /// Website chính thức
  final String? website;

  /// Giờ mở cửa (opening_hours tag)
  final String? openingHours;

  /// Số điện thoại
  final String? phone;

  /// Wikidata QID (VD: "Q106400" cho Vịnh Hạ Long)
  final String? wikidata;

  /// Wikipedia page title tiếng Anh
  final String? wikipedia;

  /// Mã tỉnh liên kết (ma từ administrative_units)
  final String? provinceMa;

  /// Timestamp lần cuối fetch Wikipedia summary
  final DateTime? wikiLastFetched;
  const TourismPlace({
    required this.osmId,
    required this.name,
    this.nameEn,
    this.nameZh,
    required this.category,
    required this.lat,
    required this.lon,
    this.description,
    this.wikiSummary,
    this.thumbnailUrl,
    this.website,
    this.openingHours,
    this.phone,
    this.wikidata,
    this.wikipedia,
    this.provinceMa,
    this.wikiLastFetched,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['osm_id'] = Variable<int>(osmId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || nameZh != null) {
      map['name_zh'] = Variable<String>(nameZh);
    }
    map['category'] = Variable<String>(category);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || wikiSummary != null) {
      map['wiki_summary'] = Variable<String>(wikiSummary);
    }
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    if (!nullToAbsent || openingHours != null) {
      map['opening_hours'] = Variable<String>(openingHours);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || wikidata != null) {
      map['wikidata'] = Variable<String>(wikidata);
    }
    if (!nullToAbsent || wikipedia != null) {
      map['wikipedia'] = Variable<String>(wikipedia);
    }
    if (!nullToAbsent || provinceMa != null) {
      map['province_ma'] = Variable<String>(provinceMa);
    }
    if (!nullToAbsent || wikiLastFetched != null) {
      map['wiki_last_fetched'] = Variable<DateTime>(wikiLastFetched);
    }
    return map;
  }

  TourismPlacesCompanion toCompanion(bool nullToAbsent) {
    return TourismPlacesCompanion(
      osmId: Value(osmId),
      name: Value(name),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      nameZh: nameZh == null && nullToAbsent
          ? const Value.absent()
          : Value(nameZh),
      category: Value(category),
      lat: Value(lat),
      lon: Value(lon),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      wikiSummary: wikiSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(wikiSummary),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      openingHours: openingHours == null && nullToAbsent
          ? const Value.absent()
          : Value(openingHours),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      wikidata: wikidata == null && nullToAbsent
          ? const Value.absent()
          : Value(wikidata),
      wikipedia: wikipedia == null && nullToAbsent
          ? const Value.absent()
          : Value(wikipedia),
      provinceMa: provinceMa == null && nullToAbsent
          ? const Value.absent()
          : Value(provinceMa),
      wikiLastFetched: wikiLastFetched == null && nullToAbsent
          ? const Value.absent()
          : Value(wikiLastFetched),
    );
  }

  factory TourismPlace.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TourismPlace(
      osmId: serializer.fromJson<int>(json['osmId']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      nameZh: serializer.fromJson<String?>(json['nameZh']),
      category: serializer.fromJson<String>(json['category']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      description: serializer.fromJson<String?>(json['description']),
      wikiSummary: serializer.fromJson<String?>(json['wikiSummary']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      website: serializer.fromJson<String?>(json['website']),
      openingHours: serializer.fromJson<String?>(json['openingHours']),
      phone: serializer.fromJson<String?>(json['phone']),
      wikidata: serializer.fromJson<String?>(json['wikidata']),
      wikipedia: serializer.fromJson<String?>(json['wikipedia']),
      provinceMa: serializer.fromJson<String?>(json['provinceMa']),
      wikiLastFetched: serializer.fromJson<DateTime?>(json['wikiLastFetched']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'osmId': serializer.toJson<int>(osmId),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String?>(nameEn),
      'nameZh': serializer.toJson<String?>(nameZh),
      'category': serializer.toJson<String>(category),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'description': serializer.toJson<String?>(description),
      'wikiSummary': serializer.toJson<String?>(wikiSummary),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'website': serializer.toJson<String?>(website),
      'openingHours': serializer.toJson<String?>(openingHours),
      'phone': serializer.toJson<String?>(phone),
      'wikidata': serializer.toJson<String?>(wikidata),
      'wikipedia': serializer.toJson<String?>(wikipedia),
      'provinceMa': serializer.toJson<String?>(provinceMa),
      'wikiLastFetched': serializer.toJson<DateTime?>(wikiLastFetched),
    };
  }

  TourismPlace copyWith({
    int? osmId,
    String? name,
    Value<String?> nameEn = const Value.absent(),
    Value<String?> nameZh = const Value.absent(),
    String? category,
    double? lat,
    double? lon,
    Value<String?> description = const Value.absent(),
    Value<String?> wikiSummary = const Value.absent(),
    Value<String?> thumbnailUrl = const Value.absent(),
    Value<String?> website = const Value.absent(),
    Value<String?> openingHours = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> wikidata = const Value.absent(),
    Value<String?> wikipedia = const Value.absent(),
    Value<String?> provinceMa = const Value.absent(),
    Value<DateTime?> wikiLastFetched = const Value.absent(),
  }) => TourismPlace(
    osmId: osmId ?? this.osmId,
    name: name ?? this.name,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    nameZh: nameZh.present ? nameZh.value : this.nameZh,
    category: category ?? this.category,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    description: description.present ? description.value : this.description,
    wikiSummary: wikiSummary.present ? wikiSummary.value : this.wikiSummary,
    thumbnailUrl: thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
    website: website.present ? website.value : this.website,
    openingHours: openingHours.present ? openingHours.value : this.openingHours,
    phone: phone.present ? phone.value : this.phone,
    wikidata: wikidata.present ? wikidata.value : this.wikidata,
    wikipedia: wikipedia.present ? wikipedia.value : this.wikipedia,
    provinceMa: provinceMa.present ? provinceMa.value : this.provinceMa,
    wikiLastFetched: wikiLastFetched.present
        ? wikiLastFetched.value
        : this.wikiLastFetched,
  );
  TourismPlace copyWithCompanion(TourismPlacesCompanion data) {
    return TourismPlace(
      osmId: data.osmId.present ? data.osmId.value : this.osmId,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameZh: data.nameZh.present ? data.nameZh.value : this.nameZh,
      category: data.category.present ? data.category.value : this.category,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      description: data.description.present
          ? data.description.value
          : this.description,
      wikiSummary: data.wikiSummary.present
          ? data.wikiSummary.value
          : this.wikiSummary,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      website: data.website.present ? data.website.value : this.website,
      openingHours: data.openingHours.present
          ? data.openingHours.value
          : this.openingHours,
      phone: data.phone.present ? data.phone.value : this.phone,
      wikidata: data.wikidata.present ? data.wikidata.value : this.wikidata,
      wikipedia: data.wikipedia.present ? data.wikipedia.value : this.wikipedia,
      provinceMa: data.provinceMa.present
          ? data.provinceMa.value
          : this.provinceMa,
      wikiLastFetched: data.wikiLastFetched.present
          ? data.wikiLastFetched.value
          : this.wikiLastFetched,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TourismPlace(')
          ..write('osmId: $osmId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameZh: $nameZh, ')
          ..write('category: $category, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('description: $description, ')
          ..write('wikiSummary: $wikiSummary, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('website: $website, ')
          ..write('openingHours: $openingHours, ')
          ..write('phone: $phone, ')
          ..write('wikidata: $wikidata, ')
          ..write('wikipedia: $wikipedia, ')
          ..write('provinceMa: $provinceMa, ')
          ..write('wikiLastFetched: $wikiLastFetched')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    osmId,
    name,
    nameEn,
    nameZh,
    category,
    lat,
    lon,
    description,
    wikiSummary,
    thumbnailUrl,
    website,
    openingHours,
    phone,
    wikidata,
    wikipedia,
    provinceMa,
    wikiLastFetched,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TourismPlace &&
          other.osmId == this.osmId &&
          other.name == this.name &&
          other.nameEn == this.nameEn &&
          other.nameZh == this.nameZh &&
          other.category == this.category &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.description == this.description &&
          other.wikiSummary == this.wikiSummary &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.website == this.website &&
          other.openingHours == this.openingHours &&
          other.phone == this.phone &&
          other.wikidata == this.wikidata &&
          other.wikipedia == this.wikipedia &&
          other.provinceMa == this.provinceMa &&
          other.wikiLastFetched == this.wikiLastFetched);
}

class TourismPlacesCompanion extends UpdateCompanion<TourismPlace> {
  final Value<int> osmId;
  final Value<String> name;
  final Value<String?> nameEn;
  final Value<String?> nameZh;
  final Value<String> category;
  final Value<double> lat;
  final Value<double> lon;
  final Value<String?> description;
  final Value<String?> wikiSummary;
  final Value<String?> thumbnailUrl;
  final Value<String?> website;
  final Value<String?> openingHours;
  final Value<String?> phone;
  final Value<String?> wikidata;
  final Value<String?> wikipedia;
  final Value<String?> provinceMa;
  final Value<DateTime?> wikiLastFetched;
  const TourismPlacesCompanion({
    this.osmId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameZh = const Value.absent(),
    this.category = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.description = const Value.absent(),
    this.wikiSummary = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.website = const Value.absent(),
    this.openingHours = const Value.absent(),
    this.phone = const Value.absent(),
    this.wikidata = const Value.absent(),
    this.wikipedia = const Value.absent(),
    this.provinceMa = const Value.absent(),
    this.wikiLastFetched = const Value.absent(),
  });
  TourismPlacesCompanion.insert({
    this.osmId = const Value.absent(),
    required String name,
    this.nameEn = const Value.absent(),
    this.nameZh = const Value.absent(),
    required String category,
    required double lat,
    required double lon,
    this.description = const Value.absent(),
    this.wikiSummary = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.website = const Value.absent(),
    this.openingHours = const Value.absent(),
    this.phone = const Value.absent(),
    this.wikidata = const Value.absent(),
    this.wikipedia = const Value.absent(),
    this.provinceMa = const Value.absent(),
    this.wikiLastFetched = const Value.absent(),
  }) : name = Value(name),
       category = Value(category),
       lat = Value(lat),
       lon = Value(lon);
  static Insertable<TourismPlace> custom({
    Expression<int>? osmId,
    Expression<String>? name,
    Expression<String>? nameEn,
    Expression<String>? nameZh,
    Expression<String>? category,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<String>? description,
    Expression<String>? wikiSummary,
    Expression<String>? thumbnailUrl,
    Expression<String>? website,
    Expression<String>? openingHours,
    Expression<String>? phone,
    Expression<String>? wikidata,
    Expression<String>? wikipedia,
    Expression<String>? provinceMa,
    Expression<DateTime>? wikiLastFetched,
  }) {
    return RawValuesInsertable({
      if (osmId != null) 'osm_id': osmId,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
      if (nameZh != null) 'name_zh': nameZh,
      if (category != null) 'category': category,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (description != null) 'description': description,
      if (wikiSummary != null) 'wiki_summary': wikiSummary,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (website != null) 'website': website,
      if (openingHours != null) 'opening_hours': openingHours,
      if (phone != null) 'phone': phone,
      if (wikidata != null) 'wikidata': wikidata,
      if (wikipedia != null) 'wikipedia': wikipedia,
      if (provinceMa != null) 'province_ma': provinceMa,
      if (wikiLastFetched != null) 'wiki_last_fetched': wikiLastFetched,
    });
  }

  TourismPlacesCompanion copyWith({
    Value<int>? osmId,
    Value<String>? name,
    Value<String?>? nameEn,
    Value<String?>? nameZh,
    Value<String>? category,
    Value<double>? lat,
    Value<double>? lon,
    Value<String?>? description,
    Value<String?>? wikiSummary,
    Value<String?>? thumbnailUrl,
    Value<String?>? website,
    Value<String?>? openingHours,
    Value<String?>? phone,
    Value<String?>? wikidata,
    Value<String?>? wikipedia,
    Value<String?>? provinceMa,
    Value<DateTime?>? wikiLastFetched,
  }) {
    return TourismPlacesCompanion(
      osmId: osmId ?? this.osmId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      nameZh: nameZh ?? this.nameZh,
      category: category ?? this.category,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      description: description ?? this.description,
      wikiSummary: wikiSummary ?? this.wikiSummary,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      website: website ?? this.website,
      openingHours: openingHours ?? this.openingHours,
      phone: phone ?? this.phone,
      wikidata: wikidata ?? this.wikidata,
      wikipedia: wikipedia ?? this.wikipedia,
      provinceMa: provinceMa ?? this.provinceMa,
      wikiLastFetched: wikiLastFetched ?? this.wikiLastFetched,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (osmId.present) {
      map['osm_id'] = Variable<int>(osmId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameZh.present) {
      map['name_zh'] = Variable<String>(nameZh.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (wikiSummary.present) {
      map['wiki_summary'] = Variable<String>(wikiSummary.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (openingHours.present) {
      map['opening_hours'] = Variable<String>(openingHours.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (wikidata.present) {
      map['wikidata'] = Variable<String>(wikidata.value);
    }
    if (wikipedia.present) {
      map['wikipedia'] = Variable<String>(wikipedia.value);
    }
    if (provinceMa.present) {
      map['province_ma'] = Variable<String>(provinceMa.value);
    }
    if (wikiLastFetched.present) {
      map['wiki_last_fetched'] = Variable<DateTime>(wikiLastFetched.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TourismPlacesCompanion(')
          ..write('osmId: $osmId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameZh: $nameZh, ')
          ..write('category: $category, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('description: $description, ')
          ..write('wikiSummary: $wikiSummary, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('website: $website, ')
          ..write('openingHours: $openingHours, ')
          ..write('phone: $phone, ')
          ..write('wikidata: $wikidata, ')
          ..write('wikipedia: $wikipedia, ')
          ..write('provinceMa: $provinceMa, ')
          ..write('wikiLastFetched: $wikiLastFetched')
          ..write(')'))
        .toString();
  }
}

class $SchoolsTable extends Schools with TableInfo<$SchoolsTable, School> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchoolsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _osmIdMeta = const VerificationMeta('osmId');
  @override
  late final GeneratedColumn<int> osmId = GeneratedColumn<int>(
    'osm_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schoolTypeMeta = const VerificationMeta(
    'schoolType',
  );
  @override
  late final GeneratedColumn<String> schoolType = GeneratedColumn<String>(
    'school_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _provinceMaMeta = const VerificationMeta(
    'provinceMa',
  );
  @override
  late final GeneratedColumn<String> provinceMa = GeneratedColumn<String>(
    'province_ma',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _provinceNameMeta = const VerificationMeta(
    'provinceName',
  );
  @override
  late final GeneratedColumn<String> provinceName = GeneratedColumn<String>(
    'province_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _operatorMeta = const VerificationMeta(
    'operator',
  );
  @override
  late final GeneratedColumn<String> operator = GeneratedColumn<String>(
    'operator',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nemotronRegionMeta = const VerificationMeta(
    'nemotronRegion',
  );
  @override
  late final GeneratedColumn<String> nemotronRegion = GeneratedColumn<String>(
    'nemotron_region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    osmId,
    name,
    schoolType,
    lat,
    lon,
    address,
    phone,
    website,
    provinceMa,
    provinceName,
    operator,
    nemotronRegion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schools';
  @override
  VerificationContext validateIntegrity(
    Insertable<School> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('osm_id')) {
      context.handle(
        _osmIdMeta,
        osmId.isAcceptableOrUnknown(data['osm_id']!, _osmIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('school_type')) {
      context.handle(
        _schoolTypeMeta,
        schoolType.isAcceptableOrUnknown(data['school_type']!, _schoolTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_schoolTypeMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('province_ma')) {
      context.handle(
        _provinceMaMeta,
        provinceMa.isAcceptableOrUnknown(data['province_ma']!, _provinceMaMeta),
      );
    }
    if (data.containsKey('province_name')) {
      context.handle(
        _provinceNameMeta,
        provinceName.isAcceptableOrUnknown(
          data['province_name']!,
          _provinceNameMeta,
        ),
      );
    }
    if (data.containsKey('operator')) {
      context.handle(
        _operatorMeta,
        operator.isAcceptableOrUnknown(data['operator']!, _operatorMeta),
      );
    }
    if (data.containsKey('nemotron_region')) {
      context.handle(
        _nemotronRegionMeta,
        nemotronRegion.isAcceptableOrUnknown(
          data['nemotron_region']!,
          _nemotronRegionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {osmId};
  @override
  School map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return School(
      osmId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}osm_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      schoolType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_type'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      provinceMa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}province_ma'],
      ),
      provinceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}province_name'],
      ),
      operator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operator'],
      ),
      nemotronRegion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nemotron_region'],
      ),
    );
  }

  @override
  $SchoolsTable createAlias(String alias) {
    return $SchoolsTable(attachedDatabase, alias);
  }
}

class School extends DataClass implements Insertable<School> {
  final int osmId;
  final String name;
  final String schoolType;
  final double lat;
  final double lon;
  final String? address;
  final String? phone;
  final String? website;
  final String? provinceMa;
  final String? provinceName;
  final String? operator;
  final String? nemotronRegion;
  const School({
    required this.osmId,
    required this.name,
    required this.schoolType,
    required this.lat,
    required this.lon,
    this.address,
    this.phone,
    this.website,
    this.provinceMa,
    this.provinceName,
    this.operator,
    this.nemotronRegion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['osm_id'] = Variable<int>(osmId);
    map['name'] = Variable<String>(name);
    map['school_type'] = Variable<String>(schoolType);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    if (!nullToAbsent || provinceMa != null) {
      map['province_ma'] = Variable<String>(provinceMa);
    }
    if (!nullToAbsent || provinceName != null) {
      map['province_name'] = Variable<String>(provinceName);
    }
    if (!nullToAbsent || operator != null) {
      map['operator'] = Variable<String>(operator);
    }
    if (!nullToAbsent || nemotronRegion != null) {
      map['nemotron_region'] = Variable<String>(nemotronRegion);
    }
    return map;
  }

  SchoolsCompanion toCompanion(bool nullToAbsent) {
    return SchoolsCompanion(
      osmId: Value(osmId),
      name: Value(name),
      schoolType: Value(schoolType),
      lat: Value(lat),
      lon: Value(lon),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      provinceMa: provinceMa == null && nullToAbsent
          ? const Value.absent()
          : Value(provinceMa),
      provinceName: provinceName == null && nullToAbsent
          ? const Value.absent()
          : Value(provinceName),
      operator: operator == null && nullToAbsent
          ? const Value.absent()
          : Value(operator),
      nemotronRegion: nemotronRegion == null && nullToAbsent
          ? const Value.absent()
          : Value(nemotronRegion),
    );
  }

  factory School.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return School(
      osmId: serializer.fromJson<int>(json['osmId']),
      name: serializer.fromJson<String>(json['name']),
      schoolType: serializer.fromJson<String>(json['schoolType']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      website: serializer.fromJson<String?>(json['website']),
      provinceMa: serializer.fromJson<String?>(json['provinceMa']),
      provinceName: serializer.fromJson<String?>(json['provinceName']),
      operator: serializer.fromJson<String?>(json['operator']),
      nemotronRegion: serializer.fromJson<String?>(json['nemotronRegion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'osmId': serializer.toJson<int>(osmId),
      'name': serializer.toJson<String>(name),
      'schoolType': serializer.toJson<String>(schoolType),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'website': serializer.toJson<String?>(website),
      'provinceMa': serializer.toJson<String?>(provinceMa),
      'provinceName': serializer.toJson<String?>(provinceName),
      'operator': serializer.toJson<String?>(operator),
      'nemotronRegion': serializer.toJson<String?>(nemotronRegion),
    };
  }

  School copyWith({
    int? osmId,
    String? name,
    String? schoolType,
    double? lat,
    double? lon,
    Value<String?> address = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> website = const Value.absent(),
    Value<String?> provinceMa = const Value.absent(),
    Value<String?> provinceName = const Value.absent(),
    Value<String?> operator = const Value.absent(),
    Value<String?> nemotronRegion = const Value.absent(),
  }) => School(
    osmId: osmId ?? this.osmId,
    name: name ?? this.name,
    schoolType: schoolType ?? this.schoolType,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    address: address.present ? address.value : this.address,
    phone: phone.present ? phone.value : this.phone,
    website: website.present ? website.value : this.website,
    provinceMa: provinceMa.present ? provinceMa.value : this.provinceMa,
    provinceName: provinceName.present ? provinceName.value : this.provinceName,
    operator: operator.present ? operator.value : this.operator,
    nemotronRegion: nemotronRegion.present
        ? nemotronRegion.value
        : this.nemotronRegion,
  );
  School copyWithCompanion(SchoolsCompanion data) {
    return School(
      osmId: data.osmId.present ? data.osmId.value : this.osmId,
      name: data.name.present ? data.name.value : this.name,
      schoolType: data.schoolType.present
          ? data.schoolType.value
          : this.schoolType,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      website: data.website.present ? data.website.value : this.website,
      provinceMa: data.provinceMa.present
          ? data.provinceMa.value
          : this.provinceMa,
      provinceName: data.provinceName.present
          ? data.provinceName.value
          : this.provinceName,
      operator: data.operator.present ? data.operator.value : this.operator,
      nemotronRegion: data.nemotronRegion.present
          ? data.nemotronRegion.value
          : this.nemotronRegion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('School(')
          ..write('osmId: $osmId, ')
          ..write('name: $name, ')
          ..write('schoolType: $schoolType, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('provinceMa: $provinceMa, ')
          ..write('provinceName: $provinceName, ')
          ..write('operator: $operator, ')
          ..write('nemotronRegion: $nemotronRegion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    osmId,
    name,
    schoolType,
    lat,
    lon,
    address,
    phone,
    website,
    provinceMa,
    provinceName,
    operator,
    nemotronRegion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is School &&
          other.osmId == this.osmId &&
          other.name == this.name &&
          other.schoolType == this.schoolType &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.website == this.website &&
          other.provinceMa == this.provinceMa &&
          other.provinceName == this.provinceName &&
          other.operator == this.operator &&
          other.nemotronRegion == this.nemotronRegion);
}

class SchoolsCompanion extends UpdateCompanion<School> {
  final Value<int> osmId;
  final Value<String> name;
  final Value<String> schoolType;
  final Value<double> lat;
  final Value<double> lon;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String?> website;
  final Value<String?> provinceMa;
  final Value<String?> provinceName;
  final Value<String?> operator;
  final Value<String?> nemotronRegion;
  const SchoolsCompanion({
    this.osmId = const Value.absent(),
    this.name = const Value.absent(),
    this.schoolType = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.provinceMa = const Value.absent(),
    this.provinceName = const Value.absent(),
    this.operator = const Value.absent(),
    this.nemotronRegion = const Value.absent(),
  });
  SchoolsCompanion.insert({
    this.osmId = const Value.absent(),
    required String name,
    required String schoolType,
    required double lat,
    required double lon,
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.provinceMa = const Value.absent(),
    this.provinceName = const Value.absent(),
    this.operator = const Value.absent(),
    this.nemotronRegion = const Value.absent(),
  }) : name = Value(name),
       schoolType = Value(schoolType),
       lat = Value(lat),
       lon = Value(lon);
  static Insertable<School> custom({
    Expression<int>? osmId,
    Expression<String>? name,
    Expression<String>? schoolType,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? website,
    Expression<String>? provinceMa,
    Expression<String>? provinceName,
    Expression<String>? operator,
    Expression<String>? nemotronRegion,
  }) {
    return RawValuesInsertable({
      if (osmId != null) 'osm_id': osmId,
      if (name != null) 'name': name,
      if (schoolType != null) 'school_type': schoolType,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
      if (provinceMa != null) 'province_ma': provinceMa,
      if (provinceName != null) 'province_name': provinceName,
      if (operator != null) 'operator': operator,
      if (nemotronRegion != null) 'nemotron_region': nemotronRegion,
    });
  }

  SchoolsCompanion copyWith({
    Value<int>? osmId,
    Value<String>? name,
    Value<String>? schoolType,
    Value<double>? lat,
    Value<double>? lon,
    Value<String?>? address,
    Value<String?>? phone,
    Value<String?>? website,
    Value<String?>? provinceMa,
    Value<String?>? provinceName,
    Value<String?>? operator,
    Value<String?>? nemotronRegion,
  }) {
    return SchoolsCompanion(
      osmId: osmId ?? this.osmId,
      name: name ?? this.name,
      schoolType: schoolType ?? this.schoolType,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      provinceMa: provinceMa ?? this.provinceMa,
      provinceName: provinceName ?? this.provinceName,
      operator: operator ?? this.operator,
      nemotronRegion: nemotronRegion ?? this.nemotronRegion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (osmId.present) {
      map['osm_id'] = Variable<int>(osmId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (schoolType.present) {
      map['school_type'] = Variable<String>(schoolType.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (provinceMa.present) {
      map['province_ma'] = Variable<String>(provinceMa.value);
    }
    if (provinceName.present) {
      map['province_name'] = Variable<String>(provinceName.value);
    }
    if (operator.present) {
      map['operator'] = Variable<String>(operator.value);
    }
    if (nemotronRegion.present) {
      map['nemotron_region'] = Variable<String>(nemotronRegion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchoolsCompanion(')
          ..write('osmId: $osmId, ')
          ..write('name: $name, ')
          ..write('schoolType: $schoolType, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('provinceMa: $provinceMa, ')
          ..write('provinceName: $provinceName, ')
          ..write('operator: $operator, ')
          ..write('nemotronRegion: $nemotronRegion')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AdministrativeUnitsTable administrativeUnits =
      $AdministrativeUnitsTable(this);
  late final $HistoricalEventsTable historicalEvents = $HistoricalEventsTable(
    this,
  );
  late final $GeoJsonCachesTable geoJsonCaches = $GeoJsonCachesTable(this);
  late final $ChatHistoryMessagesTable chatHistoryMessages =
      $ChatHistoryMessagesTable(this);
  late final $TourismPlacesTable tourismPlaces = $TourismPlacesTable(this);
  late final $SchoolsTable schools = $SchoolsTable(this);
  late final AdministrativeUnitDao administrativeUnitDao =
      AdministrativeUnitDao(this as AppDatabase);
  late final GeoJsonDao geoJsonDao = GeoJsonDao(this as AppDatabase);
  late final ChatDao chatDao = ChatDao(this as AppDatabase);
  late final TourismDao tourismDao = TourismDao(this as AppDatabase);
  late final SchoolDao schoolDao = SchoolDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    administrativeUnits,
    historicalEvents,
    geoJsonCaches,
    chatHistoryMessages,
    tourismPlaces,
    schools,
  ];
}

typedef $$AdministrativeUnitsTableCreateCompanionBuilder =
    AdministrativeUnitsCompanion Function({
      required String id,
      required String kind,
      required String ma,
      required String ten,
      required String type,
      required String tenShort,
      Value<double?> areaKm2,
      Value<double?> population,
      Value<double?> density,
      Value<String?> capital,
      Value<String?> address,
      Value<String?> phone,
      required String decree,
      required String decreeUrl,
      Value<String?> predecessors,
      Value<String?> parentMa,
      Value<String?> parentTen,
      Value<double?> centroidLon,
      Value<double?> centroidLat,
      Value<List<double>?> bbox,
      Value<String?> geomType,
      Value<int?> nVertices,
      required String macroRegion,
      required List<String> predecessorsList,
      required int nPredecessors,
      required String embedText,
      required List<String> keywords,
      Value<String?> parentTenXa,
      Value<int> rowid,
    });
typedef $$AdministrativeUnitsTableUpdateCompanionBuilder =
    AdministrativeUnitsCompanion Function({
      Value<String> id,
      Value<String> kind,
      Value<String> ma,
      Value<String> ten,
      Value<String> type,
      Value<String> tenShort,
      Value<double?> areaKm2,
      Value<double?> population,
      Value<double?> density,
      Value<String?> capital,
      Value<String?> address,
      Value<String?> phone,
      Value<String> decree,
      Value<String> decreeUrl,
      Value<String?> predecessors,
      Value<String?> parentMa,
      Value<String?> parentTen,
      Value<double?> centroidLon,
      Value<double?> centroidLat,
      Value<List<double>?> bbox,
      Value<String?> geomType,
      Value<int?> nVertices,
      Value<String> macroRegion,
      Value<List<String>> predecessorsList,
      Value<int> nPredecessors,
      Value<String> embedText,
      Value<List<String>> keywords,
      Value<String?> parentTenXa,
      Value<int> rowid,
    });

class $$AdministrativeUnitsTableFilterComposer
    extends Composer<_$AppDatabase, $AdministrativeUnitsTable> {
  $$AdministrativeUnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ma => $composableBuilder(
    column: $table.ma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ten => $composableBuilder(
    column: $table.ten,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenShort => $composableBuilder(
    column: $table.tenShort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get areaKm2 => $composableBuilder(
    column: $table.areaKm2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get population => $composableBuilder(
    column: $table.population,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get density => $composableBuilder(
    column: $table.density,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get capital => $composableBuilder(
    column: $table.capital,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get decree => $composableBuilder(
    column: $table.decree,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get decreeUrl => $composableBuilder(
    column: $table.decreeUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get predecessors => $composableBuilder(
    column: $table.predecessors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentMa => $composableBuilder(
    column: $table.parentMa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentTen => $composableBuilder(
    column: $table.parentTen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get centroidLon => $composableBuilder(
    column: $table.centroidLon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get centroidLat => $composableBuilder(
    column: $table.centroidLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<double>?, List<double>, String>
  get bbox => $composableBuilder(
    column: $table.bbox,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get geomType => $composableBuilder(
    column: $table.geomType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nVertices => $composableBuilder(
    column: $table.nVertices,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get macroRegion => $composableBuilder(
    column: $table.macroRegion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get predecessorsList => $composableBuilder(
    column: $table.predecessorsList,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get nPredecessors => $composableBuilder(
    column: $table.nPredecessors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get embedText => $composableBuilder(
    column: $table.embedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get keywords => $composableBuilder(
    column: $table.keywords,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get parentTenXa => $composableBuilder(
    column: $table.parentTenXa,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AdministrativeUnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $AdministrativeUnitsTable> {
  $$AdministrativeUnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ma => $composableBuilder(
    column: $table.ma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ten => $composableBuilder(
    column: $table.ten,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenShort => $composableBuilder(
    column: $table.tenShort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaKm2 => $composableBuilder(
    column: $table.areaKm2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get population => $composableBuilder(
    column: $table.population,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get density => $composableBuilder(
    column: $table.density,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get capital => $composableBuilder(
    column: $table.capital,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get decree => $composableBuilder(
    column: $table.decree,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get decreeUrl => $composableBuilder(
    column: $table.decreeUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get predecessors => $composableBuilder(
    column: $table.predecessors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentMa => $composableBuilder(
    column: $table.parentMa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentTen => $composableBuilder(
    column: $table.parentTen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get centroidLon => $composableBuilder(
    column: $table.centroidLon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get centroidLat => $composableBuilder(
    column: $table.centroidLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bbox => $composableBuilder(
    column: $table.bbox,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geomType => $composableBuilder(
    column: $table.geomType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nVertices => $composableBuilder(
    column: $table.nVertices,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get macroRegion => $composableBuilder(
    column: $table.macroRegion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get predecessorsList => $composableBuilder(
    column: $table.predecessorsList,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nPredecessors => $composableBuilder(
    column: $table.nPredecessors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get embedText => $composableBuilder(
    column: $table.embedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keywords => $composableBuilder(
    column: $table.keywords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentTenXa => $composableBuilder(
    column: $table.parentTenXa,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AdministrativeUnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AdministrativeUnitsTable> {
  $$AdministrativeUnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get ma =>
      $composableBuilder(column: $table.ma, builder: (column) => column);

  GeneratedColumn<String> get ten =>
      $composableBuilder(column: $table.ten, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get tenShort =>
      $composableBuilder(column: $table.tenShort, builder: (column) => column);

  GeneratedColumn<double> get areaKm2 =>
      $composableBuilder(column: $table.areaKm2, builder: (column) => column);

  GeneratedColumn<double> get population => $composableBuilder(
    column: $table.population,
    builder: (column) => column,
  );

  GeneratedColumn<double> get density =>
      $composableBuilder(column: $table.density, builder: (column) => column);

  GeneratedColumn<String> get capital =>
      $composableBuilder(column: $table.capital, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get decree =>
      $composableBuilder(column: $table.decree, builder: (column) => column);

  GeneratedColumn<String> get decreeUrl =>
      $composableBuilder(column: $table.decreeUrl, builder: (column) => column);

  GeneratedColumn<String> get predecessors => $composableBuilder(
    column: $table.predecessors,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parentMa =>
      $composableBuilder(column: $table.parentMa, builder: (column) => column);

  GeneratedColumn<String> get parentTen =>
      $composableBuilder(column: $table.parentTen, builder: (column) => column);

  GeneratedColumn<double> get centroidLon => $composableBuilder(
    column: $table.centroidLon,
    builder: (column) => column,
  );

  GeneratedColumn<double> get centroidLat => $composableBuilder(
    column: $table.centroidLat,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<double>?, String> get bbox =>
      $composableBuilder(column: $table.bbox, builder: (column) => column);

  GeneratedColumn<String> get geomType =>
      $composableBuilder(column: $table.geomType, builder: (column) => column);

  GeneratedColumn<int> get nVertices =>
      $composableBuilder(column: $table.nVertices, builder: (column) => column);

  GeneratedColumn<String> get macroRegion => $composableBuilder(
    column: $table.macroRegion,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get predecessorsList =>
      $composableBuilder(
        column: $table.predecessorsList,
        builder: (column) => column,
      );

  GeneratedColumn<int> get nPredecessors => $composableBuilder(
    column: $table.nPredecessors,
    builder: (column) => column,
  );

  GeneratedColumn<String> get embedText =>
      $composableBuilder(column: $table.embedText, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get keywords =>
      $composableBuilder(column: $table.keywords, builder: (column) => column);

  GeneratedColumn<String> get parentTenXa => $composableBuilder(
    column: $table.parentTenXa,
    builder: (column) => column,
  );
}

class $$AdministrativeUnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AdministrativeUnitsTable,
          AdministrativeUnit,
          $$AdministrativeUnitsTableFilterComposer,
          $$AdministrativeUnitsTableOrderingComposer,
          $$AdministrativeUnitsTableAnnotationComposer,
          $$AdministrativeUnitsTableCreateCompanionBuilder,
          $$AdministrativeUnitsTableUpdateCompanionBuilder,
          (
            AdministrativeUnit,
            BaseReferences<
              _$AppDatabase,
              $AdministrativeUnitsTable,
              AdministrativeUnit
            >,
          ),
          AdministrativeUnit,
          PrefetchHooks Function()
        > {
  $$AdministrativeUnitsTableTableManager(
    _$AppDatabase db,
    $AdministrativeUnitsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdministrativeUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AdministrativeUnitsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AdministrativeUnitsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> ma = const Value.absent(),
                Value<String> ten = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> tenShort = const Value.absent(),
                Value<double?> areaKm2 = const Value.absent(),
                Value<double?> population = const Value.absent(),
                Value<double?> density = const Value.absent(),
                Value<String?> capital = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String> decree = const Value.absent(),
                Value<String> decreeUrl = const Value.absent(),
                Value<String?> predecessors = const Value.absent(),
                Value<String?> parentMa = const Value.absent(),
                Value<String?> parentTen = const Value.absent(),
                Value<double?> centroidLon = const Value.absent(),
                Value<double?> centroidLat = const Value.absent(),
                Value<List<double>?> bbox = const Value.absent(),
                Value<String?> geomType = const Value.absent(),
                Value<int?> nVertices = const Value.absent(),
                Value<String> macroRegion = const Value.absent(),
                Value<List<String>> predecessorsList = const Value.absent(),
                Value<int> nPredecessors = const Value.absent(),
                Value<String> embedText = const Value.absent(),
                Value<List<String>> keywords = const Value.absent(),
                Value<String?> parentTenXa = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AdministrativeUnitsCompanion(
                id: id,
                kind: kind,
                ma: ma,
                ten: ten,
                type: type,
                tenShort: tenShort,
                areaKm2: areaKm2,
                population: population,
                density: density,
                capital: capital,
                address: address,
                phone: phone,
                decree: decree,
                decreeUrl: decreeUrl,
                predecessors: predecessors,
                parentMa: parentMa,
                parentTen: parentTen,
                centroidLon: centroidLon,
                centroidLat: centroidLat,
                bbox: bbox,
                geomType: geomType,
                nVertices: nVertices,
                macroRegion: macroRegion,
                predecessorsList: predecessorsList,
                nPredecessors: nPredecessors,
                embedText: embedText,
                keywords: keywords,
                parentTenXa: parentTenXa,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                required String ma,
                required String ten,
                required String type,
                required String tenShort,
                Value<double?> areaKm2 = const Value.absent(),
                Value<double?> population = const Value.absent(),
                Value<double?> density = const Value.absent(),
                Value<String?> capital = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                required String decree,
                required String decreeUrl,
                Value<String?> predecessors = const Value.absent(),
                Value<String?> parentMa = const Value.absent(),
                Value<String?> parentTen = const Value.absent(),
                Value<double?> centroidLon = const Value.absent(),
                Value<double?> centroidLat = const Value.absent(),
                Value<List<double>?> bbox = const Value.absent(),
                Value<String?> geomType = const Value.absent(),
                Value<int?> nVertices = const Value.absent(),
                required String macroRegion,
                required List<String> predecessorsList,
                required int nPredecessors,
                required String embedText,
                required List<String> keywords,
                Value<String?> parentTenXa = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AdministrativeUnitsCompanion.insert(
                id: id,
                kind: kind,
                ma: ma,
                ten: ten,
                type: type,
                tenShort: tenShort,
                areaKm2: areaKm2,
                population: population,
                density: density,
                capital: capital,
                address: address,
                phone: phone,
                decree: decree,
                decreeUrl: decreeUrl,
                predecessors: predecessors,
                parentMa: parentMa,
                parentTen: parentTen,
                centroidLon: centroidLon,
                centroidLat: centroidLat,
                bbox: bbox,
                geomType: geomType,
                nVertices: nVertices,
                macroRegion: macroRegion,
                predecessorsList: predecessorsList,
                nPredecessors: nPredecessors,
                embedText: embedText,
                keywords: keywords,
                parentTenXa: parentTenXa,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AdministrativeUnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AdministrativeUnitsTable,
      AdministrativeUnit,
      $$AdministrativeUnitsTableFilterComposer,
      $$AdministrativeUnitsTableOrderingComposer,
      $$AdministrativeUnitsTableAnnotationComposer,
      $$AdministrativeUnitsTableCreateCompanionBuilder,
      $$AdministrativeUnitsTableUpdateCompanionBuilder,
      (
        AdministrativeUnit,
        BaseReferences<
          _$AppDatabase,
          $AdministrativeUnitsTable,
          AdministrativeUnit
        >,
      ),
      AdministrativeUnit,
      PrefetchHooks Function()
    >;
typedef $$HistoricalEventsTableCreateCompanionBuilder =
    HistoricalEventsCompanion Function({
      Value<int> id,
      required String title,
      required String description,
      required int startYear,
      Value<int?> endYear,
      required String eventType,
      required String relatedProvinceMas,
    });
typedef $$HistoricalEventsTableUpdateCompanionBuilder =
    HistoricalEventsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> description,
      Value<int> startYear,
      Value<int?> endYear,
      Value<String> eventType,
      Value<String> relatedProvinceMas,
    });

class $$HistoricalEventsTableFilterComposer
    extends Composer<_$AppDatabase, $HistoricalEventsTable> {
  $$HistoricalEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startYear => $composableBuilder(
    column: $table.startYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endYear => $composableBuilder(
    column: $table.endYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedProvinceMas => $composableBuilder(
    column: $table.relatedProvinceMas,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HistoricalEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoricalEventsTable> {
  $$HistoricalEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startYear => $composableBuilder(
    column: $table.startYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endYear => $composableBuilder(
    column: $table.endYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedProvinceMas => $composableBuilder(
    column: $table.relatedProvinceMas,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HistoricalEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoricalEventsTable> {
  $$HistoricalEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startYear =>
      $composableBuilder(column: $table.startYear, builder: (column) => column);

  GeneratedColumn<int> get endYear =>
      $composableBuilder(column: $table.endYear, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get relatedProvinceMas => $composableBuilder(
    column: $table.relatedProvinceMas,
    builder: (column) => column,
  );
}

class $$HistoricalEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistoricalEventsTable,
          HistoricalEvent,
          $$HistoricalEventsTableFilterComposer,
          $$HistoricalEventsTableOrderingComposer,
          $$HistoricalEventsTableAnnotationComposer,
          $$HistoricalEventsTableCreateCompanionBuilder,
          $$HistoricalEventsTableUpdateCompanionBuilder,
          (
            HistoricalEvent,
            BaseReferences<
              _$AppDatabase,
              $HistoricalEventsTable,
              HistoricalEvent
            >,
          ),
          HistoricalEvent,
          PrefetchHooks Function()
        > {
  $$HistoricalEventsTableTableManager(
    _$AppDatabase db,
    $HistoricalEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoricalEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoricalEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoricalEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> startYear = const Value.absent(),
                Value<int?> endYear = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> relatedProvinceMas = const Value.absent(),
              }) => HistoricalEventsCompanion(
                id: id,
                title: title,
                description: description,
                startYear: startYear,
                endYear: endYear,
                eventType: eventType,
                relatedProvinceMas: relatedProvinceMas,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String description,
                required int startYear,
                Value<int?> endYear = const Value.absent(),
                required String eventType,
                required String relatedProvinceMas,
              }) => HistoricalEventsCompanion.insert(
                id: id,
                title: title,
                description: description,
                startYear: startYear,
                endYear: endYear,
                eventType: eventType,
                relatedProvinceMas: relatedProvinceMas,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HistoricalEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistoricalEventsTable,
      HistoricalEvent,
      $$HistoricalEventsTableFilterComposer,
      $$HistoricalEventsTableOrderingComposer,
      $$HistoricalEventsTableAnnotationComposer,
      $$HistoricalEventsTableCreateCompanionBuilder,
      $$HistoricalEventsTableUpdateCompanionBuilder,
      (
        HistoricalEvent,
        BaseReferences<_$AppDatabase, $HistoricalEventsTable, HistoricalEvent>,
      ),
      HistoricalEvent,
      PrefetchHooks Function()
    >;
typedef $$GeoJsonCachesTableCreateCompanionBuilder =
    GeoJsonCachesCompanion Function({
      required String ma,
      required String geoJsonData,
      Value<int> rowid,
    });
typedef $$GeoJsonCachesTableUpdateCompanionBuilder =
    GeoJsonCachesCompanion Function({
      Value<String> ma,
      Value<String> geoJsonData,
      Value<int> rowid,
    });

class $$GeoJsonCachesTableFilterComposer
    extends Composer<_$AppDatabase, $GeoJsonCachesTable> {
  $$GeoJsonCachesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ma => $composableBuilder(
    column: $table.ma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geoJsonData => $composableBuilder(
    column: $table.geoJsonData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GeoJsonCachesTableOrderingComposer
    extends Composer<_$AppDatabase, $GeoJsonCachesTable> {
  $$GeoJsonCachesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ma => $composableBuilder(
    column: $table.ma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geoJsonData => $composableBuilder(
    column: $table.geoJsonData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GeoJsonCachesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GeoJsonCachesTable> {
  $$GeoJsonCachesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ma =>
      $composableBuilder(column: $table.ma, builder: (column) => column);

  GeneratedColumn<String> get geoJsonData => $composableBuilder(
    column: $table.geoJsonData,
    builder: (column) => column,
  );
}

class $$GeoJsonCachesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GeoJsonCachesTable,
          GeoJsonCache,
          $$GeoJsonCachesTableFilterComposer,
          $$GeoJsonCachesTableOrderingComposer,
          $$GeoJsonCachesTableAnnotationComposer,
          $$GeoJsonCachesTableCreateCompanionBuilder,
          $$GeoJsonCachesTableUpdateCompanionBuilder,
          (
            GeoJsonCache,
            BaseReferences<_$AppDatabase, $GeoJsonCachesTable, GeoJsonCache>,
          ),
          GeoJsonCache,
          PrefetchHooks Function()
        > {
  $$GeoJsonCachesTableTableManager(_$AppDatabase db, $GeoJsonCachesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeoJsonCachesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeoJsonCachesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GeoJsonCachesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> ma = const Value.absent(),
                Value<String> geoJsonData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GeoJsonCachesCompanion(
                ma: ma,
                geoJsonData: geoJsonData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ma,
                required String geoJsonData,
                Value<int> rowid = const Value.absent(),
              }) => GeoJsonCachesCompanion.insert(
                ma: ma,
                geoJsonData: geoJsonData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GeoJsonCachesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GeoJsonCachesTable,
      GeoJsonCache,
      $$GeoJsonCachesTableFilterComposer,
      $$GeoJsonCachesTableOrderingComposer,
      $$GeoJsonCachesTableAnnotationComposer,
      $$GeoJsonCachesTableCreateCompanionBuilder,
      $$GeoJsonCachesTableUpdateCompanionBuilder,
      (
        GeoJsonCache,
        BaseReferences<_$AppDatabase, $GeoJsonCachesTable, GeoJsonCache>,
      ),
      GeoJsonCache,
      PrefetchHooks Function()
    >;
typedef $$ChatHistoryMessagesTableCreateCompanionBuilder =
    ChatHistoryMessagesCompanion Function({
      required String id,
      required String role,
      required String content,
      required DateTime timestamp,
      Value<String?> contextJson,
      Value<int> rowid,
    });
typedef $$ChatHistoryMessagesTableUpdateCompanionBuilder =
    ChatHistoryMessagesCompanion Function({
      Value<String> id,
      Value<String> role,
      Value<String> content,
      Value<DateTime> timestamp,
      Value<String?> contextJson,
      Value<int> rowid,
    });

class $$ChatHistoryMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatHistoryMessagesTable> {
  $$ChatHistoryMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextJson => $composableBuilder(
    column: $table.contextJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatHistoryMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatHistoryMessagesTable> {
  $$ChatHistoryMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextJson => $composableBuilder(
    column: $table.contextJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatHistoryMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatHistoryMessagesTable> {
  $$ChatHistoryMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get contextJson => $composableBuilder(
    column: $table.contextJson,
    builder: (column) => column,
  );
}

class $$ChatHistoryMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatHistoryMessagesTable,
          ChatHistoryMessage,
          $$ChatHistoryMessagesTableFilterComposer,
          $$ChatHistoryMessagesTableOrderingComposer,
          $$ChatHistoryMessagesTableAnnotationComposer,
          $$ChatHistoryMessagesTableCreateCompanionBuilder,
          $$ChatHistoryMessagesTableUpdateCompanionBuilder,
          (
            ChatHistoryMessage,
            BaseReferences<
              _$AppDatabase,
              $ChatHistoryMessagesTable,
              ChatHistoryMessage
            >,
          ),
          ChatHistoryMessage,
          PrefetchHooks Function()
        > {
  $$ChatHistoryMessagesTableTableManager(
    _$AppDatabase db,
    $ChatHistoryMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatHistoryMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatHistoryMessagesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ChatHistoryMessagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> contextJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatHistoryMessagesCompanion(
                id: id,
                role: role,
                content: content,
                timestamp: timestamp,
                contextJson: contextJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String role,
                required String content,
                required DateTime timestamp,
                Value<String?> contextJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatHistoryMessagesCompanion.insert(
                id: id,
                role: role,
                content: content,
                timestamp: timestamp,
                contextJson: contextJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatHistoryMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatHistoryMessagesTable,
      ChatHistoryMessage,
      $$ChatHistoryMessagesTableFilterComposer,
      $$ChatHistoryMessagesTableOrderingComposer,
      $$ChatHistoryMessagesTableAnnotationComposer,
      $$ChatHistoryMessagesTableCreateCompanionBuilder,
      $$ChatHistoryMessagesTableUpdateCompanionBuilder,
      (
        ChatHistoryMessage,
        BaseReferences<
          _$AppDatabase,
          $ChatHistoryMessagesTable,
          ChatHistoryMessage
        >,
      ),
      ChatHistoryMessage,
      PrefetchHooks Function()
    >;
typedef $$TourismPlacesTableCreateCompanionBuilder =
    TourismPlacesCompanion Function({
      Value<int> osmId,
      required String name,
      Value<String?> nameEn,
      Value<String?> nameZh,
      required String category,
      required double lat,
      required double lon,
      Value<String?> description,
      Value<String?> wikiSummary,
      Value<String?> thumbnailUrl,
      Value<String?> website,
      Value<String?> openingHours,
      Value<String?> phone,
      Value<String?> wikidata,
      Value<String?> wikipedia,
      Value<String?> provinceMa,
      Value<DateTime?> wikiLastFetched,
    });
typedef $$TourismPlacesTableUpdateCompanionBuilder =
    TourismPlacesCompanion Function({
      Value<int> osmId,
      Value<String> name,
      Value<String?> nameEn,
      Value<String?> nameZh,
      Value<String> category,
      Value<double> lat,
      Value<double> lon,
      Value<String?> description,
      Value<String?> wikiSummary,
      Value<String?> thumbnailUrl,
      Value<String?> website,
      Value<String?> openingHours,
      Value<String?> phone,
      Value<String?> wikidata,
      Value<String?> wikipedia,
      Value<String?> provinceMa,
      Value<DateTime?> wikiLastFetched,
    });

class $$TourismPlacesTableFilterComposer
    extends Composer<_$AppDatabase, $TourismPlacesTable> {
  $$TourismPlacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get osmId => $composableBuilder(
    column: $table.osmId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameZh => $composableBuilder(
    column: $table.nameZh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wikiSummary => $composableBuilder(
    column: $table.wikiSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get openingHours => $composableBuilder(
    column: $table.openingHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wikidata => $composableBuilder(
    column: $table.wikidata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wikipedia => $composableBuilder(
    column: $table.wikipedia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provinceMa => $composableBuilder(
    column: $table.provinceMa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get wikiLastFetched => $composableBuilder(
    column: $table.wikiLastFetched,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TourismPlacesTableOrderingComposer
    extends Composer<_$AppDatabase, $TourismPlacesTable> {
  $$TourismPlacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get osmId => $composableBuilder(
    column: $table.osmId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameZh => $composableBuilder(
    column: $table.nameZh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wikiSummary => $composableBuilder(
    column: $table.wikiSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get openingHours => $composableBuilder(
    column: $table.openingHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wikidata => $composableBuilder(
    column: $table.wikidata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wikipedia => $composableBuilder(
    column: $table.wikipedia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provinceMa => $composableBuilder(
    column: $table.provinceMa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get wikiLastFetched => $composableBuilder(
    column: $table.wikiLastFetched,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TourismPlacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TourismPlacesTable> {
  $$TourismPlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get osmId =>
      $composableBuilder(column: $table.osmId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameZh =>
      $composableBuilder(column: $table.nameZh, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get wikiSummary => $composableBuilder(
    column: $table.wikiSummary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get openingHours => $composableBuilder(
    column: $table.openingHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get wikidata =>
      $composableBuilder(column: $table.wikidata, builder: (column) => column);

  GeneratedColumn<String> get wikipedia =>
      $composableBuilder(column: $table.wikipedia, builder: (column) => column);

  GeneratedColumn<String> get provinceMa => $composableBuilder(
    column: $table.provinceMa,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get wikiLastFetched => $composableBuilder(
    column: $table.wikiLastFetched,
    builder: (column) => column,
  );
}

class $$TourismPlacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TourismPlacesTable,
          TourismPlace,
          $$TourismPlacesTableFilterComposer,
          $$TourismPlacesTableOrderingComposer,
          $$TourismPlacesTableAnnotationComposer,
          $$TourismPlacesTableCreateCompanionBuilder,
          $$TourismPlacesTableUpdateCompanionBuilder,
          (
            TourismPlace,
            BaseReferences<_$AppDatabase, $TourismPlacesTable, TourismPlace>,
          ),
          TourismPlace,
          PrefetchHooks Function()
        > {
  $$TourismPlacesTableTableManager(_$AppDatabase db, $TourismPlacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TourismPlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TourismPlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TourismPlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> osmId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String?> nameZh = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> wikiSummary = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> openingHours = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> wikidata = const Value.absent(),
                Value<String?> wikipedia = const Value.absent(),
                Value<String?> provinceMa = const Value.absent(),
                Value<DateTime?> wikiLastFetched = const Value.absent(),
              }) => TourismPlacesCompanion(
                osmId: osmId,
                name: name,
                nameEn: nameEn,
                nameZh: nameZh,
                category: category,
                lat: lat,
                lon: lon,
                description: description,
                wikiSummary: wikiSummary,
                thumbnailUrl: thumbnailUrl,
                website: website,
                openingHours: openingHours,
                phone: phone,
                wikidata: wikidata,
                wikipedia: wikipedia,
                provinceMa: provinceMa,
                wikiLastFetched: wikiLastFetched,
              ),
          createCompanionCallback:
              ({
                Value<int> osmId = const Value.absent(),
                required String name,
                Value<String?> nameEn = const Value.absent(),
                Value<String?> nameZh = const Value.absent(),
                required String category,
                required double lat,
                required double lon,
                Value<String?> description = const Value.absent(),
                Value<String?> wikiSummary = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> openingHours = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> wikidata = const Value.absent(),
                Value<String?> wikipedia = const Value.absent(),
                Value<String?> provinceMa = const Value.absent(),
                Value<DateTime?> wikiLastFetched = const Value.absent(),
              }) => TourismPlacesCompanion.insert(
                osmId: osmId,
                name: name,
                nameEn: nameEn,
                nameZh: nameZh,
                category: category,
                lat: lat,
                lon: lon,
                description: description,
                wikiSummary: wikiSummary,
                thumbnailUrl: thumbnailUrl,
                website: website,
                openingHours: openingHours,
                phone: phone,
                wikidata: wikidata,
                wikipedia: wikipedia,
                provinceMa: provinceMa,
                wikiLastFetched: wikiLastFetched,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TourismPlacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TourismPlacesTable,
      TourismPlace,
      $$TourismPlacesTableFilterComposer,
      $$TourismPlacesTableOrderingComposer,
      $$TourismPlacesTableAnnotationComposer,
      $$TourismPlacesTableCreateCompanionBuilder,
      $$TourismPlacesTableUpdateCompanionBuilder,
      (
        TourismPlace,
        BaseReferences<_$AppDatabase, $TourismPlacesTable, TourismPlace>,
      ),
      TourismPlace,
      PrefetchHooks Function()
    >;
typedef $$SchoolsTableCreateCompanionBuilder =
    SchoolsCompanion Function({
      Value<int> osmId,
      required String name,
      required String schoolType,
      required double lat,
      required double lon,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> website,
      Value<String?> provinceMa,
      Value<String?> provinceName,
      Value<String?> operator,
      Value<String?> nemotronRegion,
    });
typedef $$SchoolsTableUpdateCompanionBuilder =
    SchoolsCompanion Function({
      Value<int> osmId,
      Value<String> name,
      Value<String> schoolType,
      Value<double> lat,
      Value<double> lon,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> website,
      Value<String?> provinceMa,
      Value<String?> provinceName,
      Value<String?> operator,
      Value<String?> nemotronRegion,
    });

class $$SchoolsTableFilterComposer
    extends Composer<_$AppDatabase, $SchoolsTable> {
  $$SchoolsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get osmId => $composableBuilder(
    column: $table.osmId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolType => $composableBuilder(
    column: $table.schoolType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provinceMa => $composableBuilder(
    column: $table.provinceMa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provinceName => $composableBuilder(
    column: $table.provinceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operator => $composableBuilder(
    column: $table.operator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nemotronRegion => $composableBuilder(
    column: $table.nemotronRegion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SchoolsTableOrderingComposer
    extends Composer<_$AppDatabase, $SchoolsTable> {
  $$SchoolsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get osmId => $composableBuilder(
    column: $table.osmId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolType => $composableBuilder(
    column: $table.schoolType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provinceMa => $composableBuilder(
    column: $table.provinceMa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provinceName => $composableBuilder(
    column: $table.provinceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operator => $composableBuilder(
    column: $table.operator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nemotronRegion => $composableBuilder(
    column: $table.nemotronRegion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchoolsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchoolsTable> {
  $$SchoolsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get osmId =>
      $composableBuilder(column: $table.osmId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get schoolType => $composableBuilder(
    column: $table.schoolType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get provinceMa => $composableBuilder(
    column: $table.provinceMa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provinceName => $composableBuilder(
    column: $table.provinceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operator =>
      $composableBuilder(column: $table.operator, builder: (column) => column);

  GeneratedColumn<String> get nemotronRegion => $composableBuilder(
    column: $table.nemotronRegion,
    builder: (column) => column,
  );
}

class $$SchoolsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchoolsTable,
          School,
          $$SchoolsTableFilterComposer,
          $$SchoolsTableOrderingComposer,
          $$SchoolsTableAnnotationComposer,
          $$SchoolsTableCreateCompanionBuilder,
          $$SchoolsTableUpdateCompanionBuilder,
          (School, BaseReferences<_$AppDatabase, $SchoolsTable, School>),
          School,
          PrefetchHooks Function()
        > {
  $$SchoolsTableTableManager(_$AppDatabase db, $SchoolsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchoolsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchoolsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchoolsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> osmId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> schoolType = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> provinceMa = const Value.absent(),
                Value<String?> provinceName = const Value.absent(),
                Value<String?> operator = const Value.absent(),
                Value<String?> nemotronRegion = const Value.absent(),
              }) => SchoolsCompanion(
                osmId: osmId,
                name: name,
                schoolType: schoolType,
                lat: lat,
                lon: lon,
                address: address,
                phone: phone,
                website: website,
                provinceMa: provinceMa,
                provinceName: provinceName,
                operator: operator,
                nemotronRegion: nemotronRegion,
              ),
          createCompanionCallback:
              ({
                Value<int> osmId = const Value.absent(),
                required String name,
                required String schoolType,
                required double lat,
                required double lon,
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> provinceMa = const Value.absent(),
                Value<String?> provinceName = const Value.absent(),
                Value<String?> operator = const Value.absent(),
                Value<String?> nemotronRegion = const Value.absent(),
              }) => SchoolsCompanion.insert(
                osmId: osmId,
                name: name,
                schoolType: schoolType,
                lat: lat,
                lon: lon,
                address: address,
                phone: phone,
                website: website,
                provinceMa: provinceMa,
                provinceName: provinceName,
                operator: operator,
                nemotronRegion: nemotronRegion,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SchoolsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchoolsTable,
      School,
      $$SchoolsTableFilterComposer,
      $$SchoolsTableOrderingComposer,
      $$SchoolsTableAnnotationComposer,
      $$SchoolsTableCreateCompanionBuilder,
      $$SchoolsTableUpdateCompanionBuilder,
      (School, BaseReferences<_$AppDatabase, $SchoolsTable, School>),
      School,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AdministrativeUnitsTableTableManager get administrativeUnits =>
      $$AdministrativeUnitsTableTableManager(_db, _db.administrativeUnits);
  $$HistoricalEventsTableTableManager get historicalEvents =>
      $$HistoricalEventsTableTableManager(_db, _db.historicalEvents);
  $$GeoJsonCachesTableTableManager get geoJsonCaches =>
      $$GeoJsonCachesTableTableManager(_db, _db.geoJsonCaches);
  $$ChatHistoryMessagesTableTableManager get chatHistoryMessages =>
      $$ChatHistoryMessagesTableTableManager(_db, _db.chatHistoryMessages);
  $$TourismPlacesTableTableManager get tourismPlaces =>
      $$TourismPlacesTableTableManager(_db, _db.tourismPlaces);
  $$SchoolsTableTableManager get schools =>
      $$SchoolsTableTableManager(_db, _db.schools);
}

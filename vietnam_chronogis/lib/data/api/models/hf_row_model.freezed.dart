// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hf_row_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HfRowModel {

 String get id; String get kind; String get ma; String get ten; String get type;@JsonKey(name: 'ten_short') String get tenShort;@JsonKey(name: 'area_km2') double? get areaKm2; double? get population; double? get density; String? get capital; String? get address; String? get phone; String get decree;@JsonKey(name: 'decree_url') String get decreeUrl; String? get predecessors;@JsonKey(name: 'parent_ma') String? get parentMa;@JsonKey(name: 'parent_ten') String? get parentTen;@JsonKey(name: 'centroid_lon') double? get centroidLon;@JsonKey(name: 'centroid_lat') double? get centroidLat; List<double> get bbox;@JsonKey(name: 'geom_type') String? get geomType;@JsonKey(name: 'n_vertices') int? get nVertices;@JsonKey(name: 'macro_region') String get macroRegion;@JsonKey(name: 'predecessors_list') List<String> get predecessorsList;@JsonKey(name: 'n_predecessors') int get nPredecessors;@JsonKey(name: 'embed_text') String get embedText; List<String> get keywords;@JsonKey(name: 'parent_ten_xa') String? get parentTenXa;
/// Create a copy of HfRowModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HfRowModelCopyWith<HfRowModel> get copyWith => _$HfRowModelCopyWithImpl<HfRowModel>(this as HfRowModel, _$identity);

  /// Serializes this HfRowModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HfRowModel&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.ma, ma) || other.ma == ma)&&(identical(other.ten, ten) || other.ten == ten)&&(identical(other.type, type) || other.type == type)&&(identical(other.tenShort, tenShort) || other.tenShort == tenShort)&&(identical(other.areaKm2, areaKm2) || other.areaKm2 == areaKm2)&&(identical(other.population, population) || other.population == population)&&(identical(other.density, density) || other.density == density)&&(identical(other.capital, capital) || other.capital == capital)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.decree, decree) || other.decree == decree)&&(identical(other.decreeUrl, decreeUrl) || other.decreeUrl == decreeUrl)&&(identical(other.predecessors, predecessors) || other.predecessors == predecessors)&&(identical(other.parentMa, parentMa) || other.parentMa == parentMa)&&(identical(other.parentTen, parentTen) || other.parentTen == parentTen)&&(identical(other.centroidLon, centroidLon) || other.centroidLon == centroidLon)&&(identical(other.centroidLat, centroidLat) || other.centroidLat == centroidLat)&&const DeepCollectionEquality().equals(other.bbox, bbox)&&(identical(other.geomType, geomType) || other.geomType == geomType)&&(identical(other.nVertices, nVertices) || other.nVertices == nVertices)&&(identical(other.macroRegion, macroRegion) || other.macroRegion == macroRegion)&&const DeepCollectionEquality().equals(other.predecessorsList, predecessorsList)&&(identical(other.nPredecessors, nPredecessors) || other.nPredecessors == nPredecessors)&&(identical(other.embedText, embedText) || other.embedText == embedText)&&const DeepCollectionEquality().equals(other.keywords, keywords)&&(identical(other.parentTenXa, parentTenXa) || other.parentTenXa == parentTenXa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,kind,ma,ten,type,tenShort,areaKm2,population,density,capital,address,phone,decree,decreeUrl,predecessors,parentMa,parentTen,centroidLon,centroidLat,const DeepCollectionEquality().hash(bbox),geomType,nVertices,macroRegion,const DeepCollectionEquality().hash(predecessorsList),nPredecessors,embedText,const DeepCollectionEquality().hash(keywords),parentTenXa]);

@override
String toString() {
  return 'HfRowModel(id: $id, kind: $kind, ma: $ma, ten: $ten, type: $type, tenShort: $tenShort, areaKm2: $areaKm2, population: $population, density: $density, capital: $capital, address: $address, phone: $phone, decree: $decree, decreeUrl: $decreeUrl, predecessors: $predecessors, parentMa: $parentMa, parentTen: $parentTen, centroidLon: $centroidLon, centroidLat: $centroidLat, bbox: $bbox, geomType: $geomType, nVertices: $nVertices, macroRegion: $macroRegion, predecessorsList: $predecessorsList, nPredecessors: $nPredecessors, embedText: $embedText, keywords: $keywords, parentTenXa: $parentTenXa)';
}


}

/// @nodoc
abstract mixin class $HfRowModelCopyWith<$Res>  {
  factory $HfRowModelCopyWith(HfRowModel value, $Res Function(HfRowModel) _then) = _$HfRowModelCopyWithImpl;
@useResult
$Res call({
 String id, String kind, String ma, String ten, String type,@JsonKey(name: 'ten_short') String tenShort,@JsonKey(name: 'area_km2') double? areaKm2, double? population, double? density, String? capital, String? address, String? phone, String decree,@JsonKey(name: 'decree_url') String decreeUrl, String? predecessors,@JsonKey(name: 'parent_ma') String? parentMa,@JsonKey(name: 'parent_ten') String? parentTen,@JsonKey(name: 'centroid_lon') double? centroidLon,@JsonKey(name: 'centroid_lat') double? centroidLat, List<double> bbox,@JsonKey(name: 'geom_type') String? geomType,@JsonKey(name: 'n_vertices') int? nVertices,@JsonKey(name: 'macro_region') String macroRegion,@JsonKey(name: 'predecessors_list') List<String> predecessorsList,@JsonKey(name: 'n_predecessors') int nPredecessors,@JsonKey(name: 'embed_text') String embedText, List<String> keywords,@JsonKey(name: 'parent_ten_xa') String? parentTenXa
});




}
/// @nodoc
class _$HfRowModelCopyWithImpl<$Res>
    implements $HfRowModelCopyWith<$Res> {
  _$HfRowModelCopyWithImpl(this._self, this._then);

  final HfRowModel _self;
  final $Res Function(HfRowModel) _then;

/// Create a copy of HfRowModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? ma = null,Object? ten = null,Object? type = null,Object? tenShort = null,Object? areaKm2 = freezed,Object? population = freezed,Object? density = freezed,Object? capital = freezed,Object? address = freezed,Object? phone = freezed,Object? decree = null,Object? decreeUrl = null,Object? predecessors = freezed,Object? parentMa = freezed,Object? parentTen = freezed,Object? centroidLon = freezed,Object? centroidLat = freezed,Object? bbox = null,Object? geomType = freezed,Object? nVertices = freezed,Object? macroRegion = null,Object? predecessorsList = null,Object? nPredecessors = null,Object? embedText = null,Object? keywords = null,Object? parentTenXa = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,ma: null == ma ? _self.ma : ma // ignore: cast_nullable_to_non_nullable
as String,ten: null == ten ? _self.ten : ten // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,tenShort: null == tenShort ? _self.tenShort : tenShort // ignore: cast_nullable_to_non_nullable
as String,areaKm2: freezed == areaKm2 ? _self.areaKm2 : areaKm2 // ignore: cast_nullable_to_non_nullable
as double?,population: freezed == population ? _self.population : population // ignore: cast_nullable_to_non_nullable
as double?,density: freezed == density ? _self.density : density // ignore: cast_nullable_to_non_nullable
as double?,capital: freezed == capital ? _self.capital : capital // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,decree: null == decree ? _self.decree : decree // ignore: cast_nullable_to_non_nullable
as String,decreeUrl: null == decreeUrl ? _self.decreeUrl : decreeUrl // ignore: cast_nullable_to_non_nullable
as String,predecessors: freezed == predecessors ? _self.predecessors : predecessors // ignore: cast_nullable_to_non_nullable
as String?,parentMa: freezed == parentMa ? _self.parentMa : parentMa // ignore: cast_nullable_to_non_nullable
as String?,parentTen: freezed == parentTen ? _self.parentTen : parentTen // ignore: cast_nullable_to_non_nullable
as String?,centroidLon: freezed == centroidLon ? _self.centroidLon : centroidLon // ignore: cast_nullable_to_non_nullable
as double?,centroidLat: freezed == centroidLat ? _self.centroidLat : centroidLat // ignore: cast_nullable_to_non_nullable
as double?,bbox: null == bbox ? _self.bbox : bbox // ignore: cast_nullable_to_non_nullable
as List<double>,geomType: freezed == geomType ? _self.geomType : geomType // ignore: cast_nullable_to_non_nullable
as String?,nVertices: freezed == nVertices ? _self.nVertices : nVertices // ignore: cast_nullable_to_non_nullable
as int?,macroRegion: null == macroRegion ? _self.macroRegion : macroRegion // ignore: cast_nullable_to_non_nullable
as String,predecessorsList: null == predecessorsList ? _self.predecessorsList : predecessorsList // ignore: cast_nullable_to_non_nullable
as List<String>,nPredecessors: null == nPredecessors ? _self.nPredecessors : nPredecessors // ignore: cast_nullable_to_non_nullable
as int,embedText: null == embedText ? _self.embedText : embedText // ignore: cast_nullable_to_non_nullable
as String,keywords: null == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<String>,parentTenXa: freezed == parentTenXa ? _self.parentTenXa : parentTenXa // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HfRowModel].
extension HfRowModelPatterns on HfRowModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HfRowModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HfRowModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HfRowModel value)  $default,){
final _that = this;
switch (_that) {
case _HfRowModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HfRowModel value)?  $default,){
final _that = this;
switch (_that) {
case _HfRowModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String kind,  String ma,  String ten,  String type, @JsonKey(name: 'ten_short')  String tenShort, @JsonKey(name: 'area_km2')  double? areaKm2,  double? population,  double? density,  String? capital,  String? address,  String? phone,  String decree, @JsonKey(name: 'decree_url')  String decreeUrl,  String? predecessors, @JsonKey(name: 'parent_ma')  String? parentMa, @JsonKey(name: 'parent_ten')  String? parentTen, @JsonKey(name: 'centroid_lon')  double? centroidLon, @JsonKey(name: 'centroid_lat')  double? centroidLat,  List<double> bbox, @JsonKey(name: 'geom_type')  String? geomType, @JsonKey(name: 'n_vertices')  int? nVertices, @JsonKey(name: 'macro_region')  String macroRegion, @JsonKey(name: 'predecessors_list')  List<String> predecessorsList, @JsonKey(name: 'n_predecessors')  int nPredecessors, @JsonKey(name: 'embed_text')  String embedText,  List<String> keywords, @JsonKey(name: 'parent_ten_xa')  String? parentTenXa)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HfRowModel() when $default != null:
return $default(_that.id,_that.kind,_that.ma,_that.ten,_that.type,_that.tenShort,_that.areaKm2,_that.population,_that.density,_that.capital,_that.address,_that.phone,_that.decree,_that.decreeUrl,_that.predecessors,_that.parentMa,_that.parentTen,_that.centroidLon,_that.centroidLat,_that.bbox,_that.geomType,_that.nVertices,_that.macroRegion,_that.predecessorsList,_that.nPredecessors,_that.embedText,_that.keywords,_that.parentTenXa);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String kind,  String ma,  String ten,  String type, @JsonKey(name: 'ten_short')  String tenShort, @JsonKey(name: 'area_km2')  double? areaKm2,  double? population,  double? density,  String? capital,  String? address,  String? phone,  String decree, @JsonKey(name: 'decree_url')  String decreeUrl,  String? predecessors, @JsonKey(name: 'parent_ma')  String? parentMa, @JsonKey(name: 'parent_ten')  String? parentTen, @JsonKey(name: 'centroid_lon')  double? centroidLon, @JsonKey(name: 'centroid_lat')  double? centroidLat,  List<double> bbox, @JsonKey(name: 'geom_type')  String? geomType, @JsonKey(name: 'n_vertices')  int? nVertices, @JsonKey(name: 'macro_region')  String macroRegion, @JsonKey(name: 'predecessors_list')  List<String> predecessorsList, @JsonKey(name: 'n_predecessors')  int nPredecessors, @JsonKey(name: 'embed_text')  String embedText,  List<String> keywords, @JsonKey(name: 'parent_ten_xa')  String? parentTenXa)  $default,) {final _that = this;
switch (_that) {
case _HfRowModel():
return $default(_that.id,_that.kind,_that.ma,_that.ten,_that.type,_that.tenShort,_that.areaKm2,_that.population,_that.density,_that.capital,_that.address,_that.phone,_that.decree,_that.decreeUrl,_that.predecessors,_that.parentMa,_that.parentTen,_that.centroidLon,_that.centroidLat,_that.bbox,_that.geomType,_that.nVertices,_that.macroRegion,_that.predecessorsList,_that.nPredecessors,_that.embedText,_that.keywords,_that.parentTenXa);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String kind,  String ma,  String ten,  String type, @JsonKey(name: 'ten_short')  String tenShort, @JsonKey(name: 'area_km2')  double? areaKm2,  double? population,  double? density,  String? capital,  String? address,  String? phone,  String decree, @JsonKey(name: 'decree_url')  String decreeUrl,  String? predecessors, @JsonKey(name: 'parent_ma')  String? parentMa, @JsonKey(name: 'parent_ten')  String? parentTen, @JsonKey(name: 'centroid_lon')  double? centroidLon, @JsonKey(name: 'centroid_lat')  double? centroidLat,  List<double> bbox, @JsonKey(name: 'geom_type')  String? geomType, @JsonKey(name: 'n_vertices')  int? nVertices, @JsonKey(name: 'macro_region')  String macroRegion, @JsonKey(name: 'predecessors_list')  List<String> predecessorsList, @JsonKey(name: 'n_predecessors')  int nPredecessors, @JsonKey(name: 'embed_text')  String embedText,  List<String> keywords, @JsonKey(name: 'parent_ten_xa')  String? parentTenXa)?  $default,) {final _that = this;
switch (_that) {
case _HfRowModel() when $default != null:
return $default(_that.id,_that.kind,_that.ma,_that.ten,_that.type,_that.tenShort,_that.areaKm2,_that.population,_that.density,_that.capital,_that.address,_that.phone,_that.decree,_that.decreeUrl,_that.predecessors,_that.parentMa,_that.parentTen,_that.centroidLon,_that.centroidLat,_that.bbox,_that.geomType,_that.nVertices,_that.macroRegion,_that.predecessorsList,_that.nPredecessors,_that.embedText,_that.keywords,_that.parentTenXa);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HfRowModel implements HfRowModel {
  const _HfRowModel({required this.id, required this.kind, required this.ma, required this.ten, required this.type, @JsonKey(name: 'ten_short') required this.tenShort, @JsonKey(name: 'area_km2') this.areaKm2, this.population, this.density, this.capital, this.address, this.phone, required this.decree, @JsonKey(name: 'decree_url') required this.decreeUrl, this.predecessors, @JsonKey(name: 'parent_ma') this.parentMa, @JsonKey(name: 'parent_ten') this.parentTen, @JsonKey(name: 'centroid_lon') this.centroidLon, @JsonKey(name: 'centroid_lat') this.centroidLat, final  List<double> bbox = const [], @JsonKey(name: 'geom_type') this.geomType, @JsonKey(name: 'n_vertices') this.nVertices, @JsonKey(name: 'macro_region') required this.macroRegion, @JsonKey(name: 'predecessors_list') final  List<String> predecessorsList = const [], @JsonKey(name: 'n_predecessors') required this.nPredecessors, @JsonKey(name: 'embed_text') required this.embedText, final  List<String> keywords = const [], @JsonKey(name: 'parent_ten_xa') this.parentTenXa}): _bbox = bbox,_predecessorsList = predecessorsList,_keywords = keywords;
  factory _HfRowModel.fromJson(Map<String, dynamic> json) => _$HfRowModelFromJson(json);

@override final  String id;
@override final  String kind;
@override final  String ma;
@override final  String ten;
@override final  String type;
@override@JsonKey(name: 'ten_short') final  String tenShort;
@override@JsonKey(name: 'area_km2') final  double? areaKm2;
@override final  double? population;
@override final  double? density;
@override final  String? capital;
@override final  String? address;
@override final  String? phone;
@override final  String decree;
@override@JsonKey(name: 'decree_url') final  String decreeUrl;
@override final  String? predecessors;
@override@JsonKey(name: 'parent_ma') final  String? parentMa;
@override@JsonKey(name: 'parent_ten') final  String? parentTen;
@override@JsonKey(name: 'centroid_lon') final  double? centroidLon;
@override@JsonKey(name: 'centroid_lat') final  double? centroidLat;
 final  List<double> _bbox;
@override@JsonKey() List<double> get bbox {
  if (_bbox is EqualUnmodifiableListView) return _bbox;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bbox);
}

@override@JsonKey(name: 'geom_type') final  String? geomType;
@override@JsonKey(name: 'n_vertices') final  int? nVertices;
@override@JsonKey(name: 'macro_region') final  String macroRegion;
 final  List<String> _predecessorsList;
@override@JsonKey(name: 'predecessors_list') List<String> get predecessorsList {
  if (_predecessorsList is EqualUnmodifiableListView) return _predecessorsList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_predecessorsList);
}

@override@JsonKey(name: 'n_predecessors') final  int nPredecessors;
@override@JsonKey(name: 'embed_text') final  String embedText;
 final  List<String> _keywords;
@override@JsonKey() List<String> get keywords {
  if (_keywords is EqualUnmodifiableListView) return _keywords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keywords);
}

@override@JsonKey(name: 'parent_ten_xa') final  String? parentTenXa;

/// Create a copy of HfRowModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HfRowModelCopyWith<_HfRowModel> get copyWith => __$HfRowModelCopyWithImpl<_HfRowModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HfRowModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HfRowModel&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.ma, ma) || other.ma == ma)&&(identical(other.ten, ten) || other.ten == ten)&&(identical(other.type, type) || other.type == type)&&(identical(other.tenShort, tenShort) || other.tenShort == tenShort)&&(identical(other.areaKm2, areaKm2) || other.areaKm2 == areaKm2)&&(identical(other.population, population) || other.population == population)&&(identical(other.density, density) || other.density == density)&&(identical(other.capital, capital) || other.capital == capital)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.decree, decree) || other.decree == decree)&&(identical(other.decreeUrl, decreeUrl) || other.decreeUrl == decreeUrl)&&(identical(other.predecessors, predecessors) || other.predecessors == predecessors)&&(identical(other.parentMa, parentMa) || other.parentMa == parentMa)&&(identical(other.parentTen, parentTen) || other.parentTen == parentTen)&&(identical(other.centroidLon, centroidLon) || other.centroidLon == centroidLon)&&(identical(other.centroidLat, centroidLat) || other.centroidLat == centroidLat)&&const DeepCollectionEquality().equals(other._bbox, _bbox)&&(identical(other.geomType, geomType) || other.geomType == geomType)&&(identical(other.nVertices, nVertices) || other.nVertices == nVertices)&&(identical(other.macroRegion, macroRegion) || other.macroRegion == macroRegion)&&const DeepCollectionEquality().equals(other._predecessorsList, _predecessorsList)&&(identical(other.nPredecessors, nPredecessors) || other.nPredecessors == nPredecessors)&&(identical(other.embedText, embedText) || other.embedText == embedText)&&const DeepCollectionEquality().equals(other._keywords, _keywords)&&(identical(other.parentTenXa, parentTenXa) || other.parentTenXa == parentTenXa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,kind,ma,ten,type,tenShort,areaKm2,population,density,capital,address,phone,decree,decreeUrl,predecessors,parentMa,parentTen,centroidLon,centroidLat,const DeepCollectionEquality().hash(_bbox),geomType,nVertices,macroRegion,const DeepCollectionEquality().hash(_predecessorsList),nPredecessors,embedText,const DeepCollectionEquality().hash(_keywords),parentTenXa]);

@override
String toString() {
  return 'HfRowModel(id: $id, kind: $kind, ma: $ma, ten: $ten, type: $type, tenShort: $tenShort, areaKm2: $areaKm2, population: $population, density: $density, capital: $capital, address: $address, phone: $phone, decree: $decree, decreeUrl: $decreeUrl, predecessors: $predecessors, parentMa: $parentMa, parentTen: $parentTen, centroidLon: $centroidLon, centroidLat: $centroidLat, bbox: $bbox, geomType: $geomType, nVertices: $nVertices, macroRegion: $macroRegion, predecessorsList: $predecessorsList, nPredecessors: $nPredecessors, embedText: $embedText, keywords: $keywords, parentTenXa: $parentTenXa)';
}


}

/// @nodoc
abstract mixin class _$HfRowModelCopyWith<$Res> implements $HfRowModelCopyWith<$Res> {
  factory _$HfRowModelCopyWith(_HfRowModel value, $Res Function(_HfRowModel) _then) = __$HfRowModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String kind, String ma, String ten, String type,@JsonKey(name: 'ten_short') String tenShort,@JsonKey(name: 'area_km2') double? areaKm2, double? population, double? density, String? capital, String? address, String? phone, String decree,@JsonKey(name: 'decree_url') String decreeUrl, String? predecessors,@JsonKey(name: 'parent_ma') String? parentMa,@JsonKey(name: 'parent_ten') String? parentTen,@JsonKey(name: 'centroid_lon') double? centroidLon,@JsonKey(name: 'centroid_lat') double? centroidLat, List<double> bbox,@JsonKey(name: 'geom_type') String? geomType,@JsonKey(name: 'n_vertices') int? nVertices,@JsonKey(name: 'macro_region') String macroRegion,@JsonKey(name: 'predecessors_list') List<String> predecessorsList,@JsonKey(name: 'n_predecessors') int nPredecessors,@JsonKey(name: 'embed_text') String embedText, List<String> keywords,@JsonKey(name: 'parent_ten_xa') String? parentTenXa
});




}
/// @nodoc
class __$HfRowModelCopyWithImpl<$Res>
    implements _$HfRowModelCopyWith<$Res> {
  __$HfRowModelCopyWithImpl(this._self, this._then);

  final _HfRowModel _self;
  final $Res Function(_HfRowModel) _then;

/// Create a copy of HfRowModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? ma = null,Object? ten = null,Object? type = null,Object? tenShort = null,Object? areaKm2 = freezed,Object? population = freezed,Object? density = freezed,Object? capital = freezed,Object? address = freezed,Object? phone = freezed,Object? decree = null,Object? decreeUrl = null,Object? predecessors = freezed,Object? parentMa = freezed,Object? parentTen = freezed,Object? centroidLon = freezed,Object? centroidLat = freezed,Object? bbox = null,Object? geomType = freezed,Object? nVertices = freezed,Object? macroRegion = null,Object? predecessorsList = null,Object? nPredecessors = null,Object? embedText = null,Object? keywords = null,Object? parentTenXa = freezed,}) {
  return _then(_HfRowModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,ma: null == ma ? _self.ma : ma // ignore: cast_nullable_to_non_nullable
as String,ten: null == ten ? _self.ten : ten // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,tenShort: null == tenShort ? _self.tenShort : tenShort // ignore: cast_nullable_to_non_nullable
as String,areaKm2: freezed == areaKm2 ? _self.areaKm2 : areaKm2 // ignore: cast_nullable_to_non_nullable
as double?,population: freezed == population ? _self.population : population // ignore: cast_nullable_to_non_nullable
as double?,density: freezed == density ? _self.density : density // ignore: cast_nullable_to_non_nullable
as double?,capital: freezed == capital ? _self.capital : capital // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,decree: null == decree ? _self.decree : decree // ignore: cast_nullable_to_non_nullable
as String,decreeUrl: null == decreeUrl ? _self.decreeUrl : decreeUrl // ignore: cast_nullable_to_non_nullable
as String,predecessors: freezed == predecessors ? _self.predecessors : predecessors // ignore: cast_nullable_to_non_nullable
as String?,parentMa: freezed == parentMa ? _self.parentMa : parentMa // ignore: cast_nullable_to_non_nullable
as String?,parentTen: freezed == parentTen ? _self.parentTen : parentTen // ignore: cast_nullable_to_non_nullable
as String?,centroidLon: freezed == centroidLon ? _self.centroidLon : centroidLon // ignore: cast_nullable_to_non_nullable
as double?,centroidLat: freezed == centroidLat ? _self.centroidLat : centroidLat // ignore: cast_nullable_to_non_nullable
as double?,bbox: null == bbox ? _self._bbox : bbox // ignore: cast_nullable_to_non_nullable
as List<double>,geomType: freezed == geomType ? _self.geomType : geomType // ignore: cast_nullable_to_non_nullable
as String?,nVertices: freezed == nVertices ? _self.nVertices : nVertices // ignore: cast_nullable_to_non_nullable
as int?,macroRegion: null == macroRegion ? _self.macroRegion : macroRegion // ignore: cast_nullable_to_non_nullable
as String,predecessorsList: null == predecessorsList ? _self._predecessorsList : predecessorsList // ignore: cast_nullable_to_non_nullable
as List<String>,nPredecessors: null == nPredecessors ? _self.nPredecessors : nPredecessors // ignore: cast_nullable_to_non_nullable
as int,embedText: null == embedText ? _self.embedText : embedText // ignore: cast_nullable_to_non_nullable
as String,keywords: null == keywords ? _self._keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<String>,parentTenXa: freezed == parentTenXa ? _self.parentTenXa : parentTenXa // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HuggingFaceResponse {

 List<HuggingFaceRowWrapper> get rows;@JsonKey(name: 'num_rows_total') int get numRowsTotal;@JsonKey(name: 'num_rows_per_page') int get numRowsPerPage;
/// Create a copy of HuggingFaceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HuggingFaceResponseCopyWith<HuggingFaceResponse> get copyWith => _$HuggingFaceResponseCopyWithImpl<HuggingFaceResponse>(this as HuggingFaceResponse, _$identity);

  /// Serializes this HuggingFaceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HuggingFaceResponse&&const DeepCollectionEquality().equals(other.rows, rows)&&(identical(other.numRowsTotal, numRowsTotal) || other.numRowsTotal == numRowsTotal)&&(identical(other.numRowsPerPage, numRowsPerPage) || other.numRowsPerPage == numRowsPerPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(rows),numRowsTotal,numRowsPerPage);

@override
String toString() {
  return 'HuggingFaceResponse(rows: $rows, numRowsTotal: $numRowsTotal, numRowsPerPage: $numRowsPerPage)';
}


}

/// @nodoc
abstract mixin class $HuggingFaceResponseCopyWith<$Res>  {
  factory $HuggingFaceResponseCopyWith(HuggingFaceResponse value, $Res Function(HuggingFaceResponse) _then) = _$HuggingFaceResponseCopyWithImpl;
@useResult
$Res call({
 List<HuggingFaceRowWrapper> rows,@JsonKey(name: 'num_rows_total') int numRowsTotal,@JsonKey(name: 'num_rows_per_page') int numRowsPerPage
});




}
/// @nodoc
class _$HuggingFaceResponseCopyWithImpl<$Res>
    implements $HuggingFaceResponseCopyWith<$Res> {
  _$HuggingFaceResponseCopyWithImpl(this._self, this._then);

  final HuggingFaceResponse _self;
  final $Res Function(HuggingFaceResponse) _then;

/// Create a copy of HuggingFaceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rows = null,Object? numRowsTotal = null,Object? numRowsPerPage = null,}) {
  return _then(_self.copyWith(
rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<HuggingFaceRowWrapper>,numRowsTotal: null == numRowsTotal ? _self.numRowsTotal : numRowsTotal // ignore: cast_nullable_to_non_nullable
as int,numRowsPerPage: null == numRowsPerPage ? _self.numRowsPerPage : numRowsPerPage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HuggingFaceResponse].
extension HuggingFaceResponsePatterns on HuggingFaceResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HuggingFaceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HuggingFaceResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HuggingFaceResponse value)  $default,){
final _that = this;
switch (_that) {
case _HuggingFaceResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HuggingFaceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HuggingFaceResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HuggingFaceRowWrapper> rows, @JsonKey(name: 'num_rows_total')  int numRowsTotal, @JsonKey(name: 'num_rows_per_page')  int numRowsPerPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HuggingFaceResponse() when $default != null:
return $default(_that.rows,_that.numRowsTotal,_that.numRowsPerPage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HuggingFaceRowWrapper> rows, @JsonKey(name: 'num_rows_total')  int numRowsTotal, @JsonKey(name: 'num_rows_per_page')  int numRowsPerPage)  $default,) {final _that = this;
switch (_that) {
case _HuggingFaceResponse():
return $default(_that.rows,_that.numRowsTotal,_that.numRowsPerPage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HuggingFaceRowWrapper> rows, @JsonKey(name: 'num_rows_total')  int numRowsTotal, @JsonKey(name: 'num_rows_per_page')  int numRowsPerPage)?  $default,) {final _that = this;
switch (_that) {
case _HuggingFaceResponse() when $default != null:
return $default(_that.rows,_that.numRowsTotal,_that.numRowsPerPage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HuggingFaceResponse implements HuggingFaceResponse {
  const _HuggingFaceResponse({required final  List<HuggingFaceRowWrapper> rows, @JsonKey(name: 'num_rows_total') required this.numRowsTotal, @JsonKey(name: 'num_rows_per_page') required this.numRowsPerPage}): _rows = rows;
  factory _HuggingFaceResponse.fromJson(Map<String, dynamic> json) => _$HuggingFaceResponseFromJson(json);

 final  List<HuggingFaceRowWrapper> _rows;
@override List<HuggingFaceRowWrapper> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

@override@JsonKey(name: 'num_rows_total') final  int numRowsTotal;
@override@JsonKey(name: 'num_rows_per_page') final  int numRowsPerPage;

/// Create a copy of HuggingFaceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HuggingFaceResponseCopyWith<_HuggingFaceResponse> get copyWith => __$HuggingFaceResponseCopyWithImpl<_HuggingFaceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HuggingFaceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HuggingFaceResponse&&const DeepCollectionEquality().equals(other._rows, _rows)&&(identical(other.numRowsTotal, numRowsTotal) || other.numRowsTotal == numRowsTotal)&&(identical(other.numRowsPerPage, numRowsPerPage) || other.numRowsPerPage == numRowsPerPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_rows),numRowsTotal,numRowsPerPage);

@override
String toString() {
  return 'HuggingFaceResponse(rows: $rows, numRowsTotal: $numRowsTotal, numRowsPerPage: $numRowsPerPage)';
}


}

/// @nodoc
abstract mixin class _$HuggingFaceResponseCopyWith<$Res> implements $HuggingFaceResponseCopyWith<$Res> {
  factory _$HuggingFaceResponseCopyWith(_HuggingFaceResponse value, $Res Function(_HuggingFaceResponse) _then) = __$HuggingFaceResponseCopyWithImpl;
@override @useResult
$Res call({
 List<HuggingFaceRowWrapper> rows,@JsonKey(name: 'num_rows_total') int numRowsTotal,@JsonKey(name: 'num_rows_per_page') int numRowsPerPage
});




}
/// @nodoc
class __$HuggingFaceResponseCopyWithImpl<$Res>
    implements _$HuggingFaceResponseCopyWith<$Res> {
  __$HuggingFaceResponseCopyWithImpl(this._self, this._then);

  final _HuggingFaceResponse _self;
  final $Res Function(_HuggingFaceResponse) _then;

/// Create a copy of HuggingFaceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rows = null,Object? numRowsTotal = null,Object? numRowsPerPage = null,}) {
  return _then(_HuggingFaceResponse(
rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<HuggingFaceRowWrapper>,numRowsTotal: null == numRowsTotal ? _self.numRowsTotal : numRowsTotal // ignore: cast_nullable_to_non_nullable
as int,numRowsPerPage: null == numRowsPerPage ? _self.numRowsPerPage : numRowsPerPage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$HuggingFaceRowWrapper {

@JsonKey(name: 'row_idx') int get rowIdx; HfRowModel get row;
/// Create a copy of HuggingFaceRowWrapper
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HuggingFaceRowWrapperCopyWith<HuggingFaceRowWrapper> get copyWith => _$HuggingFaceRowWrapperCopyWithImpl<HuggingFaceRowWrapper>(this as HuggingFaceRowWrapper, _$identity);

  /// Serializes this HuggingFaceRowWrapper to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HuggingFaceRowWrapper&&(identical(other.rowIdx, rowIdx) || other.rowIdx == rowIdx)&&(identical(other.row, row) || other.row == row));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rowIdx,row);

@override
String toString() {
  return 'HuggingFaceRowWrapper(rowIdx: $rowIdx, row: $row)';
}


}

/// @nodoc
abstract mixin class $HuggingFaceRowWrapperCopyWith<$Res>  {
  factory $HuggingFaceRowWrapperCopyWith(HuggingFaceRowWrapper value, $Res Function(HuggingFaceRowWrapper) _then) = _$HuggingFaceRowWrapperCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'row_idx') int rowIdx, HfRowModel row
});


$HfRowModelCopyWith<$Res> get row;

}
/// @nodoc
class _$HuggingFaceRowWrapperCopyWithImpl<$Res>
    implements $HuggingFaceRowWrapperCopyWith<$Res> {
  _$HuggingFaceRowWrapperCopyWithImpl(this._self, this._then);

  final HuggingFaceRowWrapper _self;
  final $Res Function(HuggingFaceRowWrapper) _then;

/// Create a copy of HuggingFaceRowWrapper
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rowIdx = null,Object? row = null,}) {
  return _then(_self.copyWith(
rowIdx: null == rowIdx ? _self.rowIdx : rowIdx // ignore: cast_nullable_to_non_nullable
as int,row: null == row ? _self.row : row // ignore: cast_nullable_to_non_nullable
as HfRowModel,
  ));
}
/// Create a copy of HuggingFaceRowWrapper
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HfRowModelCopyWith<$Res> get row {
  
  return $HfRowModelCopyWith<$Res>(_self.row, (value) {
    return _then(_self.copyWith(row: value));
  });
}
}


/// Adds pattern-matching-related methods to [HuggingFaceRowWrapper].
extension HuggingFaceRowWrapperPatterns on HuggingFaceRowWrapper {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HuggingFaceRowWrapper value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HuggingFaceRowWrapper() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HuggingFaceRowWrapper value)  $default,){
final _that = this;
switch (_that) {
case _HuggingFaceRowWrapper():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HuggingFaceRowWrapper value)?  $default,){
final _that = this;
switch (_that) {
case _HuggingFaceRowWrapper() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'row_idx')  int rowIdx,  HfRowModel row)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HuggingFaceRowWrapper() when $default != null:
return $default(_that.rowIdx,_that.row);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'row_idx')  int rowIdx,  HfRowModel row)  $default,) {final _that = this;
switch (_that) {
case _HuggingFaceRowWrapper():
return $default(_that.rowIdx,_that.row);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'row_idx')  int rowIdx,  HfRowModel row)?  $default,) {final _that = this;
switch (_that) {
case _HuggingFaceRowWrapper() when $default != null:
return $default(_that.rowIdx,_that.row);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HuggingFaceRowWrapper implements HuggingFaceRowWrapper {
  const _HuggingFaceRowWrapper({@JsonKey(name: 'row_idx') required this.rowIdx, required this.row});
  factory _HuggingFaceRowWrapper.fromJson(Map<String, dynamic> json) => _$HuggingFaceRowWrapperFromJson(json);

@override@JsonKey(name: 'row_idx') final  int rowIdx;
@override final  HfRowModel row;

/// Create a copy of HuggingFaceRowWrapper
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HuggingFaceRowWrapperCopyWith<_HuggingFaceRowWrapper> get copyWith => __$HuggingFaceRowWrapperCopyWithImpl<_HuggingFaceRowWrapper>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HuggingFaceRowWrapperToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HuggingFaceRowWrapper&&(identical(other.rowIdx, rowIdx) || other.rowIdx == rowIdx)&&(identical(other.row, row) || other.row == row));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rowIdx,row);

@override
String toString() {
  return 'HuggingFaceRowWrapper(rowIdx: $rowIdx, row: $row)';
}


}

/// @nodoc
abstract mixin class _$HuggingFaceRowWrapperCopyWith<$Res> implements $HuggingFaceRowWrapperCopyWith<$Res> {
  factory _$HuggingFaceRowWrapperCopyWith(_HuggingFaceRowWrapper value, $Res Function(_HuggingFaceRowWrapper) _then) = __$HuggingFaceRowWrapperCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'row_idx') int rowIdx, HfRowModel row
});


@override $HfRowModelCopyWith<$Res> get row;

}
/// @nodoc
class __$HuggingFaceRowWrapperCopyWithImpl<$Res>
    implements _$HuggingFaceRowWrapperCopyWith<$Res> {
  __$HuggingFaceRowWrapperCopyWithImpl(this._self, this._then);

  final _HuggingFaceRowWrapper _self;
  final $Res Function(_HuggingFaceRowWrapper) _then;

/// Create a copy of HuggingFaceRowWrapper
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rowIdx = null,Object? row = null,}) {
  return _then(_HuggingFaceRowWrapper(
rowIdx: null == rowIdx ? _self.rowIdx : rowIdx // ignore: cast_nullable_to_non_nullable
as int,row: null == row ? _self.row : row // ignore: cast_nullable_to_non_nullable
as HfRowModel,
  ));
}

/// Create a copy of HuggingFaceRowWrapper
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HfRowModelCopyWith<$Res> get row {
  
  return $HfRowModelCopyWith<$Res>(_self.row, (value) {
    return _then(_self.copyWith(row: value));
  });
}
}

// dart format on

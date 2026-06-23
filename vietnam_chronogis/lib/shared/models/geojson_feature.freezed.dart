// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geojson_feature.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeoJsonFeature {

 String get type; Map<String, dynamic> get properties; Geometry get geometry;
/// Create a copy of GeoJsonFeature
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoJsonFeatureCopyWith<GeoJsonFeature> get copyWith => _$GeoJsonFeatureCopyWithImpl<GeoJsonFeature>(this as GeoJsonFeature, _$identity);

  /// Serializes this GeoJsonFeature to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoJsonFeature&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.properties, properties)&&(identical(other.geometry, geometry) || other.geometry == geometry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(properties),geometry);

@override
String toString() {
  return 'GeoJsonFeature(type: $type, properties: $properties, geometry: $geometry)';
}


}

/// @nodoc
abstract mixin class $GeoJsonFeatureCopyWith<$Res>  {
  factory $GeoJsonFeatureCopyWith(GeoJsonFeature value, $Res Function(GeoJsonFeature) _then) = _$GeoJsonFeatureCopyWithImpl;
@useResult
$Res call({
 String type, Map<String, dynamic> properties, Geometry geometry
});


$GeometryCopyWith<$Res> get geometry;

}
/// @nodoc
class _$GeoJsonFeatureCopyWithImpl<$Res>
    implements $GeoJsonFeatureCopyWith<$Res> {
  _$GeoJsonFeatureCopyWithImpl(this._self, this._then);

  final GeoJsonFeature _self;
  final $Res Function(GeoJsonFeature) _then;

/// Create a copy of GeoJsonFeature
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? properties = null,Object? geometry = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,geometry: null == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as Geometry,
  ));
}
/// Create a copy of GeoJsonFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeometryCopyWith<$Res> get geometry {
  
  return $GeometryCopyWith<$Res>(_self.geometry, (value) {
    return _then(_self.copyWith(geometry: value));
  });
}
}


/// Adds pattern-matching-related methods to [GeoJsonFeature].
extension GeoJsonFeaturePatterns on GeoJsonFeature {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoJsonFeature value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoJsonFeature() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoJsonFeature value)  $default,){
final _that = this;
switch (_that) {
case _GeoJsonFeature():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoJsonFeature value)?  $default,){
final _that = this;
switch (_that) {
case _GeoJsonFeature() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  Map<String, dynamic> properties,  Geometry geometry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoJsonFeature() when $default != null:
return $default(_that.type,_that.properties,_that.geometry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  Map<String, dynamic> properties,  Geometry geometry)  $default,) {final _that = this;
switch (_that) {
case _GeoJsonFeature():
return $default(_that.type,_that.properties,_that.geometry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  Map<String, dynamic> properties,  Geometry geometry)?  $default,) {final _that = this;
switch (_that) {
case _GeoJsonFeature() when $default != null:
return $default(_that.type,_that.properties,_that.geometry);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoJsonFeature implements GeoJsonFeature {
  const _GeoJsonFeature({required this.type, required final  Map<String, dynamic> properties, required this.geometry}): _properties = properties;
  factory _GeoJsonFeature.fromJson(Map<String, dynamic> json) => _$GeoJsonFeatureFromJson(json);

@override final  String type;
 final  Map<String, dynamic> _properties;
@override Map<String, dynamic> get properties {
  if (_properties is EqualUnmodifiableMapView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_properties);
}

@override final  Geometry geometry;

/// Create a copy of GeoJsonFeature
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoJsonFeatureCopyWith<_GeoJsonFeature> get copyWith => __$GeoJsonFeatureCopyWithImpl<_GeoJsonFeature>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoJsonFeatureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoJsonFeature&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._properties, _properties)&&(identical(other.geometry, geometry) || other.geometry == geometry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_properties),geometry);

@override
String toString() {
  return 'GeoJsonFeature(type: $type, properties: $properties, geometry: $geometry)';
}


}

/// @nodoc
abstract mixin class _$GeoJsonFeatureCopyWith<$Res> implements $GeoJsonFeatureCopyWith<$Res> {
  factory _$GeoJsonFeatureCopyWith(_GeoJsonFeature value, $Res Function(_GeoJsonFeature) _then) = __$GeoJsonFeatureCopyWithImpl;
@override @useResult
$Res call({
 String type, Map<String, dynamic> properties, Geometry geometry
});


@override $GeometryCopyWith<$Res> get geometry;

}
/// @nodoc
class __$GeoJsonFeatureCopyWithImpl<$Res>
    implements _$GeoJsonFeatureCopyWith<$Res> {
  __$GeoJsonFeatureCopyWithImpl(this._self, this._then);

  final _GeoJsonFeature _self;
  final $Res Function(_GeoJsonFeature) _then;

/// Create a copy of GeoJsonFeature
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? properties = null,Object? geometry = null,}) {
  return _then(_GeoJsonFeature(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,geometry: null == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as Geometry,
  ));
}

/// Create a copy of GeoJsonFeature
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeometryCopyWith<$Res> get geometry {
  
  return $GeometryCopyWith<$Res>(_self.geometry, (value) {
    return _then(_self.copyWith(geometry: value));
  });
}
}


/// @nodoc
mixin _$Geometry {

 String get type; List<dynamic> get coordinates;
/// Create a copy of Geometry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeometryCopyWith<Geometry> get copyWith => _$GeometryCopyWithImpl<Geometry>(this as Geometry, _$identity);

  /// Serializes this Geometry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Geometry&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.coordinates, coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(coordinates));

@override
String toString() {
  return 'Geometry(type: $type, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class $GeometryCopyWith<$Res>  {
  factory $GeometryCopyWith(Geometry value, $Res Function(Geometry) _then) = _$GeometryCopyWithImpl;
@useResult
$Res call({
 String type, List<dynamic> coordinates
});




}
/// @nodoc
class _$GeometryCopyWithImpl<$Res>
    implements $GeometryCopyWith<$Res> {
  _$GeometryCopyWithImpl(this._self, this._then);

  final Geometry _self;
  final $Res Function(Geometry) _then;

/// Create a copy of Geometry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? coordinates = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,coordinates: null == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [Geometry].
extension GeometryPatterns on Geometry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Geometry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Geometry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Geometry value)  $default,){
final _that = this;
switch (_that) {
case _Geometry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Geometry value)?  $default,){
final _that = this;
switch (_that) {
case _Geometry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  List<dynamic> coordinates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Geometry() when $default != null:
return $default(_that.type,_that.coordinates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  List<dynamic> coordinates)  $default,) {final _that = this;
switch (_that) {
case _Geometry():
return $default(_that.type,_that.coordinates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  List<dynamic> coordinates)?  $default,) {final _that = this;
switch (_that) {
case _Geometry() when $default != null:
return $default(_that.type,_that.coordinates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Geometry implements Geometry {
  const _Geometry({required this.type, required final  List<dynamic> coordinates}): _coordinates = coordinates;
  factory _Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);

@override final  String type;
 final  List<dynamic> _coordinates;
@override List<dynamic> get coordinates {
  if (_coordinates is EqualUnmodifiableListView) return _coordinates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coordinates);
}


/// Create a copy of Geometry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeometryCopyWith<_Geometry> get copyWith => __$GeometryCopyWithImpl<_Geometry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeometryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Geometry&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._coordinates, _coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_coordinates));

@override
String toString() {
  return 'Geometry(type: $type, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class _$GeometryCopyWith<$Res> implements $GeometryCopyWith<$Res> {
  factory _$GeometryCopyWith(_Geometry value, $Res Function(_Geometry) _then) = __$GeometryCopyWithImpl;
@override @useResult
$Res call({
 String type, List<dynamic> coordinates
});




}
/// @nodoc
class __$GeometryCopyWithImpl<$Res>
    implements _$GeometryCopyWith<$Res> {
  __$GeometryCopyWithImpl(this._self, this._then);

  final _Geometry _self;
  final $Res Function(_Geometry) _then;

/// Create a copy of Geometry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? coordinates = null,}) {
  return _then(_Geometry(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,coordinates: null == coordinates ? _self._coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}


}


/// @nodoc
mixin _$FeatureCollection {

 String get type; List<GeoJsonFeature> get features;
/// Create a copy of FeatureCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatureCollectionCopyWith<FeatureCollection> get copyWith => _$FeatureCollectionCopyWithImpl<FeatureCollection>(this as FeatureCollection, _$identity);

  /// Serializes this FeatureCollection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatureCollection&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.features, features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(features));

@override
String toString() {
  return 'FeatureCollection(type: $type, features: $features)';
}


}

/// @nodoc
abstract mixin class $FeatureCollectionCopyWith<$Res>  {
  factory $FeatureCollectionCopyWith(FeatureCollection value, $Res Function(FeatureCollection) _then) = _$FeatureCollectionCopyWithImpl;
@useResult
$Res call({
 String type, List<GeoJsonFeature> features
});




}
/// @nodoc
class _$FeatureCollectionCopyWithImpl<$Res>
    implements $FeatureCollectionCopyWith<$Res> {
  _$FeatureCollectionCopyWithImpl(this._self, this._then);

  final FeatureCollection _self;
  final $Res Function(FeatureCollection) _then;

/// Create a copy of FeatureCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? features = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<GeoJsonFeature>,
  ));
}

}


/// Adds pattern-matching-related methods to [FeatureCollection].
extension FeatureCollectionPatterns on FeatureCollection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeatureCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeatureCollection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeatureCollection value)  $default,){
final _that = this;
switch (_that) {
case _FeatureCollection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeatureCollection value)?  $default,){
final _that = this;
switch (_that) {
case _FeatureCollection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  List<GeoJsonFeature> features)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeatureCollection() when $default != null:
return $default(_that.type,_that.features);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  List<GeoJsonFeature> features)  $default,) {final _that = this;
switch (_that) {
case _FeatureCollection():
return $default(_that.type,_that.features);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  List<GeoJsonFeature> features)?  $default,) {final _that = this;
switch (_that) {
case _FeatureCollection() when $default != null:
return $default(_that.type,_that.features);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeatureCollection implements FeatureCollection {
  const _FeatureCollection({required this.type, required final  List<GeoJsonFeature> features}): _features = features;
  factory _FeatureCollection.fromJson(Map<String, dynamic> json) => _$FeatureCollectionFromJson(json);

@override final  String type;
 final  List<GeoJsonFeature> _features;
@override List<GeoJsonFeature> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}


/// Create a copy of FeatureCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatureCollectionCopyWith<_FeatureCollection> get copyWith => __$FeatureCollectionCopyWithImpl<_FeatureCollection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeatureCollectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeatureCollection&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._features, _features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_features));

@override
String toString() {
  return 'FeatureCollection(type: $type, features: $features)';
}


}

/// @nodoc
abstract mixin class _$FeatureCollectionCopyWith<$Res> implements $FeatureCollectionCopyWith<$Res> {
  factory _$FeatureCollectionCopyWith(_FeatureCollection value, $Res Function(_FeatureCollection) _then) = __$FeatureCollectionCopyWithImpl;
@override @useResult
$Res call({
 String type, List<GeoJsonFeature> features
});




}
/// @nodoc
class __$FeatureCollectionCopyWithImpl<$Res>
    implements _$FeatureCollectionCopyWith<$Res> {
  __$FeatureCollectionCopyWithImpl(this._self, this._then);

  final _FeatureCollection _self;
  final $Res Function(_FeatureCollection) _then;

/// Create a copy of FeatureCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? features = null,}) {
  return _then(_FeatureCollection(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<GeoJsonFeature>,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatContext {

 int get currentYear; String? get selectedProvinceMa; String? get selectedProvinceEmbedText; int get provinceCount; String get currentEra;
/// Create a copy of ChatContext
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatContextCopyWith<ChatContext> get copyWith => _$ChatContextCopyWithImpl<ChatContext>(this as ChatContext, _$identity);

  /// Serializes this ChatContext to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatContext&&(identical(other.currentYear, currentYear) || other.currentYear == currentYear)&&(identical(other.selectedProvinceMa, selectedProvinceMa) || other.selectedProvinceMa == selectedProvinceMa)&&(identical(other.selectedProvinceEmbedText, selectedProvinceEmbedText) || other.selectedProvinceEmbedText == selectedProvinceEmbedText)&&(identical(other.provinceCount, provinceCount) || other.provinceCount == provinceCount)&&(identical(other.currentEra, currentEra) || other.currentEra == currentEra));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentYear,selectedProvinceMa,selectedProvinceEmbedText,provinceCount,currentEra);

@override
String toString() {
  return 'ChatContext(currentYear: $currentYear, selectedProvinceMa: $selectedProvinceMa, selectedProvinceEmbedText: $selectedProvinceEmbedText, provinceCount: $provinceCount, currentEra: $currentEra)';
}


}

/// @nodoc
abstract mixin class $ChatContextCopyWith<$Res>  {
  factory $ChatContextCopyWith(ChatContext value, $Res Function(ChatContext) _then) = _$ChatContextCopyWithImpl;
@useResult
$Res call({
 int currentYear, String? selectedProvinceMa, String? selectedProvinceEmbedText, int provinceCount, String currentEra
});




}
/// @nodoc
class _$ChatContextCopyWithImpl<$Res>
    implements $ChatContextCopyWith<$Res> {
  _$ChatContextCopyWithImpl(this._self, this._then);

  final ChatContext _self;
  final $Res Function(ChatContext) _then;

/// Create a copy of ChatContext
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentYear = null,Object? selectedProvinceMa = freezed,Object? selectedProvinceEmbedText = freezed,Object? provinceCount = null,Object? currentEra = null,}) {
  return _then(_self.copyWith(
currentYear: null == currentYear ? _self.currentYear : currentYear // ignore: cast_nullable_to_non_nullable
as int,selectedProvinceMa: freezed == selectedProvinceMa ? _self.selectedProvinceMa : selectedProvinceMa // ignore: cast_nullable_to_non_nullable
as String?,selectedProvinceEmbedText: freezed == selectedProvinceEmbedText ? _self.selectedProvinceEmbedText : selectedProvinceEmbedText // ignore: cast_nullable_to_non_nullable
as String?,provinceCount: null == provinceCount ? _self.provinceCount : provinceCount // ignore: cast_nullable_to_non_nullable
as int,currentEra: null == currentEra ? _self.currentEra : currentEra // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatContext].
extension ChatContextPatterns on ChatContext {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatContext value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatContext() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatContext value)  $default,){
final _that = this;
switch (_that) {
case _ChatContext():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatContext value)?  $default,){
final _that = this;
switch (_that) {
case _ChatContext() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentYear,  String? selectedProvinceMa,  String? selectedProvinceEmbedText,  int provinceCount,  String currentEra)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatContext() when $default != null:
return $default(_that.currentYear,_that.selectedProvinceMa,_that.selectedProvinceEmbedText,_that.provinceCount,_that.currentEra);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentYear,  String? selectedProvinceMa,  String? selectedProvinceEmbedText,  int provinceCount,  String currentEra)  $default,) {final _that = this;
switch (_that) {
case _ChatContext():
return $default(_that.currentYear,_that.selectedProvinceMa,_that.selectedProvinceEmbedText,_that.provinceCount,_that.currentEra);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentYear,  String? selectedProvinceMa,  String? selectedProvinceEmbedText,  int provinceCount,  String currentEra)?  $default,) {final _that = this;
switch (_that) {
case _ChatContext() when $default != null:
return $default(_that.currentYear,_that.selectedProvinceMa,_that.selectedProvinceEmbedText,_that.provinceCount,_that.currentEra);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatContext implements ChatContext {
  const _ChatContext({required this.currentYear, this.selectedProvinceMa, this.selectedProvinceEmbedText, required this.provinceCount, required this.currentEra});
  factory _ChatContext.fromJson(Map<String, dynamic> json) => _$ChatContextFromJson(json);

@override final  int currentYear;
@override final  String? selectedProvinceMa;
@override final  String? selectedProvinceEmbedText;
@override final  int provinceCount;
@override final  String currentEra;

/// Create a copy of ChatContext
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatContextCopyWith<_ChatContext> get copyWith => __$ChatContextCopyWithImpl<_ChatContext>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatContextToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatContext&&(identical(other.currentYear, currentYear) || other.currentYear == currentYear)&&(identical(other.selectedProvinceMa, selectedProvinceMa) || other.selectedProvinceMa == selectedProvinceMa)&&(identical(other.selectedProvinceEmbedText, selectedProvinceEmbedText) || other.selectedProvinceEmbedText == selectedProvinceEmbedText)&&(identical(other.provinceCount, provinceCount) || other.provinceCount == provinceCount)&&(identical(other.currentEra, currentEra) || other.currentEra == currentEra));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentYear,selectedProvinceMa,selectedProvinceEmbedText,provinceCount,currentEra);

@override
String toString() {
  return 'ChatContext(currentYear: $currentYear, selectedProvinceMa: $selectedProvinceMa, selectedProvinceEmbedText: $selectedProvinceEmbedText, provinceCount: $provinceCount, currentEra: $currentEra)';
}


}

/// @nodoc
abstract mixin class _$ChatContextCopyWith<$Res> implements $ChatContextCopyWith<$Res> {
  factory _$ChatContextCopyWith(_ChatContext value, $Res Function(_ChatContext) _then) = __$ChatContextCopyWithImpl;
@override @useResult
$Res call({
 int currentYear, String? selectedProvinceMa, String? selectedProvinceEmbedText, int provinceCount, String currentEra
});




}
/// @nodoc
class __$ChatContextCopyWithImpl<$Res>
    implements _$ChatContextCopyWith<$Res> {
  __$ChatContextCopyWithImpl(this._self, this._then);

  final _ChatContext _self;
  final $Res Function(_ChatContext) _then;

/// Create a copy of ChatContext
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentYear = null,Object? selectedProvinceMa = freezed,Object? selectedProvinceEmbedText = freezed,Object? provinceCount = null,Object? currentEra = null,}) {
  return _then(_ChatContext(
currentYear: null == currentYear ? _self.currentYear : currentYear // ignore: cast_nullable_to_non_nullable
as int,selectedProvinceMa: freezed == selectedProvinceMa ? _self.selectedProvinceMa : selectedProvinceMa // ignore: cast_nullable_to_non_nullable
as String?,selectedProvinceEmbedText: freezed == selectedProvinceEmbedText ? _self.selectedProvinceEmbedText : selectedProvinceEmbedText // ignore: cast_nullable_to_non_nullable
as String?,provinceCount: null == provinceCount ? _self.provinceCount : provinceCount // ignore: cast_nullable_to_non_nullable
as int,currentEra: null == currentEra ? _self.currentEra : currentEra // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

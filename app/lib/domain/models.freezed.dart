// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Streak {

 int get current; int get longest; int get total;@JsonKey(name: 'last_date') DateTime? get lastDate;
/// Create a copy of Streak
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakCopyWith<Streak> get copyWith => _$StreakCopyWithImpl<Streak>(this as Streak, _$identity);

  /// Serializes this Streak to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Streak;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Streak&&(identical(other.current, _this.current) || other.current == _this.current)&&(identical(other.longest, _this.longest) || other.longest == _this.longest)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.lastDate, _this.lastDate) || other.lastDate == _this.lastDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Streak;
  return Object.hash(runtimeType,_this.current,_this.longest,_this.total,_this.lastDate);
}

@override
String toString() {
  final _this = this as Streak;
  return 'Streak(current: ${_this.current}, longest: ${_this.longest}, total: ${_this.total}, lastDate: ${_this.lastDate})';
}


}

/// @nodoc
abstract mixin class $StreakCopyWith<$Res>  {
  factory $StreakCopyWith(Streak value, $Res Function(Streak) _then) = _$StreakCopyWithImpl;
@useResult
$Res call({
 int current, int longest, int total,@JsonKey(name: 'last_date') DateTime? lastDate
});




}
/// @nodoc
class _$StreakCopyWithImpl<$Res>
    implements $StreakCopyWith<$Res> {
  _$StreakCopyWithImpl(this._self, this._then);

  final Streak _self;
  final $Res Function(Streak) _then;

/// Create a copy of Streak
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = null,Object? longest = null,Object? total = null,Object? lastDate = freezed,}) {
  return _then(Streak(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,longest: null == longest ? _self.longest : longest // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,lastDate: freezed == lastDate ? _self.lastDate : lastDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Streak].
extension StreakPatterns on Streak {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Streak value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Streak() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Streak value)  $default,){
final _that = this;
switch (_that) {
case _Streak():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Streak value)?  $default,){
final _that = this;
switch (_that) {
case _Streak() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int current,  int longest,  int total, @JsonKey(name: 'last_date')  DateTime? lastDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Streak() when $default != null:
return $default(_that.current,_that.longest,_that.total,_that.lastDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int current,  int longest,  int total, @JsonKey(name: 'last_date')  DateTime? lastDate)  $default,) {final _that = this;
switch (_that) {
case _Streak():
return $default(_that.current,_that.longest,_that.total,_that.lastDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int current,  int longest,  int total, @JsonKey(name: 'last_date')  DateTime? lastDate)?  $default,) {final _that = this;
switch (_that) {
case _Streak() when $default != null:
return $default(_that.current,_that.longest,_that.total,_that.lastDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Streak implements Streak {
  const _Streak({this.current = 0, this.longest = 0, this.total = 0, @JsonKey(name: 'last_date') this.lastDate});
  factory _Streak.fromJson(Map<String, dynamic> json) => _$StreakFromJson(json);

@override@JsonKey() final  int current;
@override@JsonKey() final  int longest;
@override@JsonKey() final  int total;
@override@JsonKey(name: 'last_date') final  DateTime? lastDate;

/// Create a copy of Streak
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakCopyWith<_Streak> get copyWith => __$StreakCopyWithImpl<_Streak>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreakToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Streak&&(identical(other.current, current) || other.current == current)&&(identical(other.longest, longest) || other.longest == longest)&&(identical(other.total, total) || other.total == total)&&(identical(other.lastDate, lastDate) || other.lastDate == lastDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,current,longest,total,lastDate);
}

@override
String toString() {
    return 'Streak(current: $current, longest: $longest, total: $total, lastDate: $lastDate)';
}


}

/// @nodoc
abstract mixin class _$StreakCopyWith<$Res> implements $StreakCopyWith<$Res> {
  factory _$StreakCopyWith(_Streak value, $Res Function(_Streak) _then) = __$StreakCopyWithImpl;
@override @useResult
$Res call({
 int current, int longest, int total,@JsonKey(name: 'last_date') DateTime? lastDate
});




}
/// @nodoc
class __$StreakCopyWithImpl<$Res>
    implements _$StreakCopyWith<$Res> {
  __$StreakCopyWithImpl(this._self, this._then);

  final _Streak _self;
  final $Res Function(_Streak) _then;

/// Create a copy of Streak
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = null,Object? longest = null,Object? total = null,Object? lastDate = freezed,}) {
  return _then(_Streak(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,longest: null == longest ? _self.longest : longest // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,lastDate: freezed == lastDate ? _self.lastDate : lastDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DabbleUser {

 String get id; String get username;@JsonKey(name: 'display_name') String get displayName; String get bio;@JsonKey(name: 'avatar_url') String? get avatarUrl; String? get email; String get timezone;@JsonKey(name: 'reminder_hour') int? get reminderHour;@JsonKey(name: 'preferred_categories') List<String> get preferredCategories; Streak get streak;
/// Create a copy of DabbleUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DabbleUserCopyWith<DabbleUser> get copyWith => _$DabbleUserCopyWithImpl<DabbleUser>(this as DabbleUser, _$identity);

  /// Serializes this DabbleUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DabbleUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DabbleUser&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.reminderHour, _this.reminderHour) || other.reminderHour == _this.reminderHour)&&const DeepCollectionEquality().equals(other.preferredCategories, _this.preferredCategories)&&(identical(other.streak, _this.streak) || other.streak == _this.streak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DabbleUser;
  return Object.hash(runtimeType,_this.id,_this.username,_this.displayName,_this.bio,_this.avatarUrl,_this.email,_this.timezone,_this.reminderHour,const DeepCollectionEquality().hash(_this.preferredCategories),_this.streak);
}

@override
String toString() {
  final _this = this as DabbleUser;
  return 'DabbleUser(id: ${_this.id}, username: ${_this.username}, displayName: ${_this.displayName}, bio: ${_this.bio}, avatarUrl: ${_this.avatarUrl}, email: ${_this.email}, timezone: ${_this.timezone}, reminderHour: ${_this.reminderHour}, preferredCategories: ${_this.preferredCategories}, streak: ${_this.streak})';
}


}

/// @nodoc
abstract mixin class $DabbleUserCopyWith<$Res>  {
  factory $DabbleUserCopyWith(DabbleUser value, $Res Function(DabbleUser) _then) = _$DabbleUserCopyWithImpl;
@useResult
$Res call({
 String id, String username,@JsonKey(name: 'display_name') String displayName, String bio,@JsonKey(name: 'avatar_url') String? avatarUrl, String? email, String timezone,@JsonKey(name: 'reminder_hour') int? reminderHour,@JsonKey(name: 'preferred_categories') List<String> preferredCategories, Streak streak
});


$StreakCopyWith<$Res> get streak;

}
/// @nodoc
class _$DabbleUserCopyWithImpl<$Res>
    implements $DabbleUserCopyWith<$Res> {
  _$DabbleUserCopyWithImpl(this._self, this._then);

  final DabbleUser _self;
  final $Res Function(DabbleUser) _then;

/// Create a copy of DabbleUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? bio = null,Object? avatarUrl = freezed,Object? email = freezed,Object? timezone = null,Object? reminderHour = freezed,Object? preferredCategories = null,Object? streak = null,}) {
  return _then(DabbleUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,reminderHour: freezed == reminderHour ? _self.reminderHour : reminderHour // ignore: cast_nullable_to_non_nullable
as int?,preferredCategories: null == preferredCategories ? _self.preferredCategories : preferredCategories // ignore: cast_nullable_to_non_nullable
as List<String>,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as Streak,
  ));
}
/// Create a copy of DabbleUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreakCopyWith<$Res> get streak {
  
  return $StreakCopyWith<$Res>(_self.streak, (value) {
    return _then(_self.copyWith(streak: value));
  });
}
}


/// Adds pattern-matching-related methods to [DabbleUser].
extension DabbleUserPatterns on DabbleUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DabbleUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DabbleUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DabbleUser value)  $default,){
final _that = this;
switch (_that) {
case _DabbleUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DabbleUser value)?  $default,){
final _that = this;
switch (_that) {
case _DabbleUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username, @JsonKey(name: 'display_name')  String displayName,  String bio, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String? email,  String timezone, @JsonKey(name: 'reminder_hour')  int? reminderHour, @JsonKey(name: 'preferred_categories')  List<String> preferredCategories,  Streak streak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DabbleUser() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.bio,_that.avatarUrl,_that.email,_that.timezone,_that.reminderHour,_that.preferredCategories,_that.streak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username, @JsonKey(name: 'display_name')  String displayName,  String bio, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String? email,  String timezone, @JsonKey(name: 'reminder_hour')  int? reminderHour, @JsonKey(name: 'preferred_categories')  List<String> preferredCategories,  Streak streak)  $default,) {final _that = this;
switch (_that) {
case _DabbleUser():
return $default(_that.id,_that.username,_that.displayName,_that.bio,_that.avatarUrl,_that.email,_that.timezone,_that.reminderHour,_that.preferredCategories,_that.streak);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username, @JsonKey(name: 'display_name')  String displayName,  String bio, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String? email,  String timezone, @JsonKey(name: 'reminder_hour')  int? reminderHour, @JsonKey(name: 'preferred_categories')  List<String> preferredCategories,  Streak streak)?  $default,) {final _that = this;
switch (_that) {
case _DabbleUser() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.bio,_that.avatarUrl,_that.email,_that.timezone,_that.reminderHour,_that.preferredCategories,_that.streak);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DabbleUser implements DabbleUser {
  const _DabbleUser({required this.id, required this.username, @JsonKey(name: 'display_name') this.displayName = '', this.bio = '', @JsonKey(name: 'avatar_url') this.avatarUrl, this.email, this.timezone = 'UTC', @JsonKey(name: 'reminder_hour') this.reminderHour, @JsonKey(name: 'preferred_categories')  List<String> preferredCategories = const <String>[], this.streak = const Streak()}): _preferredCategories = preferredCategories;
  factory _DabbleUser.fromJson(Map<String, dynamic> json) => _$DabbleUserFromJson(json);

@override final  String id;
@override final  String username;
@override@JsonKey(name: 'display_name') final  String displayName;
@override@JsonKey() final  String bio;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override final  String? email;
@override@JsonKey() final  String timezone;
@override@JsonKey(name: 'reminder_hour') final  int? reminderHour;
 final  List<String> _preferredCategories;
@override@JsonKey(name: 'preferred_categories') List<String> get preferredCategories {
  if (_preferredCategories is EqualUnmodifiableListView) return _preferredCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_preferredCategories);
}

@override@JsonKey() final  Streak streak;

/// Create a copy of DabbleUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DabbleUserCopyWith<_DabbleUser> get copyWith => __$DabbleUserCopyWithImpl<_DabbleUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DabbleUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DabbleUser&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.email, email) || other.email == email)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.reminderHour, reminderHour) || other.reminderHour == reminderHour)&&const DeepCollectionEquality().equals(other.preferredCategories, _preferredCategories)&&(identical(other.streak, streak) || other.streak == streak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,username,displayName,bio,avatarUrl,email,timezone,reminderHour,const DeepCollectionEquality().hash(_preferredCategories),streak);
}

@override
String toString() {
    return 'DabbleUser(id: $id, username: $username, displayName: $displayName, bio: $bio, avatarUrl: $avatarUrl, email: $email, timezone: $timezone, reminderHour: $reminderHour, preferredCategories: $preferredCategories, streak: $streak)';
}


}

/// @nodoc
abstract mixin class _$DabbleUserCopyWith<$Res> implements $DabbleUserCopyWith<$Res> {
  factory _$DabbleUserCopyWith(_DabbleUser value, $Res Function(_DabbleUser) _then) = __$DabbleUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String username,@JsonKey(name: 'display_name') String displayName, String bio,@JsonKey(name: 'avatar_url') String? avatarUrl, String? email, String timezone,@JsonKey(name: 'reminder_hour') int? reminderHour,@JsonKey(name: 'preferred_categories') List<String> preferredCategories, Streak streak
});


@override $StreakCopyWith<$Res> get streak;

}
/// @nodoc
class __$DabbleUserCopyWithImpl<$Res>
    implements _$DabbleUserCopyWith<$Res> {
  __$DabbleUserCopyWithImpl(this._self, this._then);

  final _DabbleUser _self;
  final $Res Function(_DabbleUser) _then;

/// Create a copy of DabbleUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? bio = null,Object? avatarUrl = freezed,Object? email = freezed,Object? timezone = null,Object? reminderHour = freezed,Object? preferredCategories = null,Object? streak = null,}) {
  return _then(_DabbleUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,reminderHour: freezed == reminderHour ? _self.reminderHour : reminderHour // ignore: cast_nullable_to_non_nullable
as int?,preferredCategories: null == preferredCategories ? _self._preferredCategories : preferredCategories // ignore: cast_nullable_to_non_nullable
as List<String>,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as Streak,
  ));
}

/// Create a copy of DabbleUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreakCopyWith<$Res> get streak {
  
  return $StreakCopyWith<$Res>(_self.streak, (value) {
    return _then(_self.copyWith(streak: value));
  });
}
}


/// @nodoc
mixin _$Topic {

 String get id; String get slug; String get name; String get blurb; String get craft;@JsonKey(name: 'parent_id') String? get parentId;@JsonKey(name: 'accepts_prompts') bool get acceptsPrompts;@JsonKey(name: 'subscriber_count') int get subscriberCount;@JsonKey(name: 'is_selected') bool get isSelected; List<Topic> get children;
/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicCopyWith<Topic> get copyWith => _$TopicCopyWithImpl<Topic>(this as Topic, _$identity);

  /// Serializes this Topic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Topic;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Topic&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.blurb, _this.blurb) || other.blurb == _this.blurb)&&(identical(other.craft, _this.craft) || other.craft == _this.craft)&&(identical(other.parentId, _this.parentId) || other.parentId == _this.parentId)&&(identical(other.acceptsPrompts, _this.acceptsPrompts) || other.acceptsPrompts == _this.acceptsPrompts)&&(identical(other.subscriberCount, _this.subscriberCount) || other.subscriberCount == _this.subscriberCount)&&(identical(other.isSelected, _this.isSelected) || other.isSelected == _this.isSelected)&&const DeepCollectionEquality().equals(other.children, _this.children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Topic;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.name,_this.blurb,_this.craft,_this.parentId,_this.acceptsPrompts,_this.subscriberCount,_this.isSelected,const DeepCollectionEquality().hash(_this.children));
}

@override
String toString() {
  final _this = this as Topic;
  return 'Topic(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, blurb: ${_this.blurb}, craft: ${_this.craft}, parentId: ${_this.parentId}, acceptsPrompts: ${_this.acceptsPrompts}, subscriberCount: ${_this.subscriberCount}, isSelected: ${_this.isSelected}, children: ${_this.children})';
}


}

/// @nodoc
abstract mixin class $TopicCopyWith<$Res>  {
  factory $TopicCopyWith(Topic value, $Res Function(Topic) _then) = _$TopicCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String name, String blurb, String craft,@JsonKey(name: 'parent_id') String? parentId,@JsonKey(name: 'accepts_prompts') bool acceptsPrompts,@JsonKey(name: 'subscriber_count') int subscriberCount,@JsonKey(name: 'is_selected') bool isSelected, List<Topic> children
});




}
/// @nodoc
class _$TopicCopyWithImpl<$Res>
    implements $TopicCopyWith<$Res> {
  _$TopicCopyWithImpl(this._self, this._then);

  final Topic _self;
  final $Res Function(Topic) _then;

/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? blurb = null,Object? craft = null,Object? parentId = freezed,Object? acceptsPrompts = null,Object? subscriberCount = null,Object? isSelected = null,Object? children = null,}) {
  return _then(Topic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,blurb: null == blurb ? _self.blurb : blurb // ignore: cast_nullable_to_non_nullable
as String,craft: null == craft ? _self.craft : craft // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,acceptsPrompts: null == acceptsPrompts ? _self.acceptsPrompts : acceptsPrompts // ignore: cast_nullable_to_non_nullable
as bool,subscriberCount: null == subscriberCount ? _self.subscriberCount : subscriberCount // ignore: cast_nullable_to_non_nullable
as int,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<Topic>,
  ));
}

}


/// Adds pattern-matching-related methods to [Topic].
extension TopicPatterns on Topic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Topic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Topic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Topic value)  $default,){
final _that = this;
switch (_that) {
case _Topic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Topic value)?  $default,){
final _that = this;
switch (_that) {
case _Topic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String blurb,  String craft, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'accepts_prompts')  bool acceptsPrompts, @JsonKey(name: 'subscriber_count')  int subscriberCount, @JsonKey(name: 'is_selected')  bool isSelected,  List<Topic> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Topic() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.blurb,_that.craft,_that.parentId,_that.acceptsPrompts,_that.subscriberCount,_that.isSelected,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String blurb,  String craft, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'accepts_prompts')  bool acceptsPrompts, @JsonKey(name: 'subscriber_count')  int subscriberCount, @JsonKey(name: 'is_selected')  bool isSelected,  List<Topic> children)  $default,) {final _that = this;
switch (_that) {
case _Topic():
return $default(_that.id,_that.slug,_that.name,_that.blurb,_that.craft,_that.parentId,_that.acceptsPrompts,_that.subscriberCount,_that.isSelected,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String name,  String blurb,  String craft, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'accepts_prompts')  bool acceptsPrompts, @JsonKey(name: 'subscriber_count')  int subscriberCount, @JsonKey(name: 'is_selected')  bool isSelected,  List<Topic> children)?  $default,) {final _that = this;
switch (_that) {
case _Topic() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.blurb,_that.craft,_that.parentId,_that.acceptsPrompts,_that.subscriberCount,_that.isSelected,_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Topic extends Topic {
  const _Topic({required this.id, required this.slug, required this.name, this.blurb = '', this.craft = 'writing', @JsonKey(name: 'parent_id') this.parentId, @JsonKey(name: 'accepts_prompts') this.acceptsPrompts = true, @JsonKey(name: 'subscriber_count') this.subscriberCount = 0, @JsonKey(name: 'is_selected') this.isSelected = false,  List<Topic> children = const <Topic>[]}): _children = children,super._();
  factory _Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String name;
@override@JsonKey() final  String blurb;
@override@JsonKey() final  String craft;
@override@JsonKey(name: 'parent_id') final  String? parentId;
@override@JsonKey(name: 'accepts_prompts') final  bool acceptsPrompts;
@override@JsonKey(name: 'subscriber_count') final  int subscriberCount;
@override@JsonKey(name: 'is_selected') final  bool isSelected;
 final  List<Topic> _children;
@override@JsonKey() List<Topic> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicCopyWith<_Topic> get copyWith => __$TopicCopyWithImpl<_Topic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopicToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Topic&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.blurb, blurb) || other.blurb == blurb)&&(identical(other.craft, craft) || other.craft == craft)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.acceptsPrompts, acceptsPrompts) || other.acceptsPrompts == acceptsPrompts)&&(identical(other.subscriberCount, subscriberCount) || other.subscriberCount == subscriberCount)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&const DeepCollectionEquality().equals(other.children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,name,blurb,craft,parentId,acceptsPrompts,subscriberCount,isSelected,const DeepCollectionEquality().hash(_children));
}

@override
String toString() {
    return 'Topic(id: $id, slug: $slug, name: $name, blurb: $blurb, craft: $craft, parentId: $parentId, acceptsPrompts: $acceptsPrompts, subscriberCount: $subscriberCount, isSelected: $isSelected, children: $children)';
}


}

/// @nodoc
abstract mixin class _$TopicCopyWith<$Res> implements $TopicCopyWith<$Res> {
  factory _$TopicCopyWith(_Topic value, $Res Function(_Topic) _then) = __$TopicCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String name, String blurb, String craft,@JsonKey(name: 'parent_id') String? parentId,@JsonKey(name: 'accepts_prompts') bool acceptsPrompts,@JsonKey(name: 'subscriber_count') int subscriberCount,@JsonKey(name: 'is_selected') bool isSelected, List<Topic> children
});




}
/// @nodoc
class __$TopicCopyWithImpl<$Res>
    implements _$TopicCopyWith<$Res> {
  __$TopicCopyWithImpl(this._self, this._then);

  final _Topic _self;
  final $Res Function(_Topic) _then;

/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? blurb = null,Object? craft = null,Object? parentId = freezed,Object? acceptsPrompts = null,Object? subscriberCount = null,Object? isSelected = null,Object? children = null,}) {
  return _then(_Topic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,blurb: null == blurb ? _self.blurb : blurb // ignore: cast_nullable_to_non_nullable
as String,craft: null == craft ? _self.craft : craft // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,acceptsPrompts: null == acceptsPrompts ? _self.acceptsPrompts : acceptsPrompts // ignore: cast_nullable_to_non_nullable
as bool,subscriberCount: null == subscriberCount ? _self.subscriberCount : subscriberCount // ignore: cast_nullable_to_non_nullable
as int,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<Topic>,
  ));
}


}


/// @nodoc
mixin _$Prompt {

 String get id; DateTime get date; String get category;@JsonKey(name: 'category_label') String get categoryLabel; String get kind; String get text; String get nudge;@JsonKey(name: 'topic_id') String? get topicId;@JsonKey(name: 'topic_name') String? get topicName;@JsonKey(name: 'topic_path') String? get topicPath;
/// Create a copy of Prompt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromptCopyWith<Prompt> get copyWith => _$PromptCopyWithImpl<Prompt>(this as Prompt, _$identity);

  /// Serializes this Prompt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Prompt;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Prompt&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.categoryLabel, _this.categoryLabel) || other.categoryLabel == _this.categoryLabel)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.nudge, _this.nudge) || other.nudge == _this.nudge)&&(identical(other.topicId, _this.topicId) || other.topicId == _this.topicId)&&(identical(other.topicName, _this.topicName) || other.topicName == _this.topicName)&&(identical(other.topicPath, _this.topicPath) || other.topicPath == _this.topicPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Prompt;
  return Object.hash(runtimeType,_this.id,_this.date,_this.category,_this.categoryLabel,_this.kind,_this.text,_this.nudge,_this.topicId,_this.topicName,_this.topicPath);
}

@override
String toString() {
  final _this = this as Prompt;
  return 'Prompt(id: ${_this.id}, date: ${_this.date}, category: ${_this.category}, categoryLabel: ${_this.categoryLabel}, kind: ${_this.kind}, text: ${_this.text}, nudge: ${_this.nudge}, topicId: ${_this.topicId}, topicName: ${_this.topicName}, topicPath: ${_this.topicPath})';
}


}

/// @nodoc
abstract mixin class $PromptCopyWith<$Res>  {
  factory $PromptCopyWith(Prompt value, $Res Function(Prompt) _then) = _$PromptCopyWithImpl;
@useResult
$Res call({
 String id, DateTime date, String category,@JsonKey(name: 'category_label') String categoryLabel, String kind, String text, String nudge,@JsonKey(name: 'topic_id') String? topicId,@JsonKey(name: 'topic_name') String? topicName,@JsonKey(name: 'topic_path') String? topicPath
});




}
/// @nodoc
class _$PromptCopyWithImpl<$Res>
    implements $PromptCopyWith<$Res> {
  _$PromptCopyWithImpl(this._self, this._then);

  final Prompt _self;
  final $Res Function(Prompt) _then;

/// Create a copy of Prompt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? category = null,Object? categoryLabel = null,Object? kind = null,Object? text = null,Object? nudge = null,Object? topicId = freezed,Object? topicName = freezed,Object? topicPath = freezed,}) {
  return _then(Prompt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,categoryLabel: null == categoryLabel ? _self.categoryLabel : categoryLabel // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,nudge: null == nudge ? _self.nudge : nudge // ignore: cast_nullable_to_non_nullable
as String,topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String?,topicName: freezed == topicName ? _self.topicName : topicName // ignore: cast_nullable_to_non_nullable
as String?,topicPath: freezed == topicPath ? _self.topicPath : topicPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Prompt].
extension PromptPatterns on Prompt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Prompt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Prompt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Prompt value)  $default,){
final _that = this;
switch (_that) {
case _Prompt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Prompt value)?  $default,){
final _that = this;
switch (_that) {
case _Prompt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime date,  String category, @JsonKey(name: 'category_label')  String categoryLabel,  String kind,  String text,  String nudge, @JsonKey(name: 'topic_id')  String? topicId, @JsonKey(name: 'topic_name')  String? topicName, @JsonKey(name: 'topic_path')  String? topicPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Prompt() when $default != null:
return $default(_that.id,_that.date,_that.category,_that.categoryLabel,_that.kind,_that.text,_that.nudge,_that.topicId,_that.topicName,_that.topicPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime date,  String category, @JsonKey(name: 'category_label')  String categoryLabel,  String kind,  String text,  String nudge, @JsonKey(name: 'topic_id')  String? topicId, @JsonKey(name: 'topic_name')  String? topicName, @JsonKey(name: 'topic_path')  String? topicPath)  $default,) {final _that = this;
switch (_that) {
case _Prompt():
return $default(_that.id,_that.date,_that.category,_that.categoryLabel,_that.kind,_that.text,_that.nudge,_that.topicId,_that.topicName,_that.topicPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime date,  String category, @JsonKey(name: 'category_label')  String categoryLabel,  String kind,  String text,  String nudge, @JsonKey(name: 'topic_id')  String? topicId, @JsonKey(name: 'topic_name')  String? topicName, @JsonKey(name: 'topic_path')  String? topicPath)?  $default,) {final _that = this;
switch (_that) {
case _Prompt() when $default != null:
return $default(_that.id,_that.date,_that.category,_that.categoryLabel,_that.kind,_that.text,_that.nudge,_that.topicId,_that.topicName,_that.topicPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Prompt implements Prompt {
  const _Prompt({required this.id, required this.date, required this.category, @JsonKey(name: 'category_label') required this.categoryLabel, this.kind = 'text', required this.text, this.nudge = 'Five minutes is enough.', @JsonKey(name: 'topic_id') this.topicId, @JsonKey(name: 'topic_name') this.topicName, @JsonKey(name: 'topic_path') this.topicPath});
  factory _Prompt.fromJson(Map<String, dynamic> json) => _$PromptFromJson(json);

@override final  String id;
@override final  DateTime date;
@override final  String category;
@override@JsonKey(name: 'category_label') final  String categoryLabel;
@override@JsonKey() final  String kind;
@override final  String text;
@override@JsonKey() final  String nudge;
@override@JsonKey(name: 'topic_id') final  String? topicId;
@override@JsonKey(name: 'topic_name') final  String? topicName;
@override@JsonKey(name: 'topic_path') final  String? topicPath;

/// Create a copy of Prompt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromptCopyWith<_Prompt> get copyWith => __$PromptCopyWithImpl<_Prompt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromptToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Prompt&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.category, category) || other.category == category)&&(identical(other.categoryLabel, categoryLabel) || other.categoryLabel == categoryLabel)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.text, text) || other.text == text)&&(identical(other.nudge, nudge) || other.nudge == nudge)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.topicName, topicName) || other.topicName == topicName)&&(identical(other.topicPath, topicPath) || other.topicPath == topicPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,date,category,categoryLabel,kind,text,nudge,topicId,topicName,topicPath);
}

@override
String toString() {
    return 'Prompt(id: $id, date: $date, category: $category, categoryLabel: $categoryLabel, kind: $kind, text: $text, nudge: $nudge, topicId: $topicId, topicName: $topicName, topicPath: $topicPath)';
}


}

/// @nodoc
abstract mixin class _$PromptCopyWith<$Res> implements $PromptCopyWith<$Res> {
  factory _$PromptCopyWith(_Prompt value, $Res Function(_Prompt) _then) = __$PromptCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime date, String category,@JsonKey(name: 'category_label') String categoryLabel, String kind, String text, String nudge,@JsonKey(name: 'topic_id') String? topicId,@JsonKey(name: 'topic_name') String? topicName,@JsonKey(name: 'topic_path') String? topicPath
});




}
/// @nodoc
class __$PromptCopyWithImpl<$Res>
    implements _$PromptCopyWith<$Res> {
  __$PromptCopyWithImpl(this._self, this._then);

  final _Prompt _self;
  final $Res Function(_Prompt) _then;

/// Create a copy of Prompt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? category = null,Object? categoryLabel = null,Object? kind = null,Object? text = null,Object? nudge = null,Object? topicId = freezed,Object? topicName = freezed,Object? topicPath = freezed,}) {
  return _then(_Prompt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,categoryLabel: null == categoryLabel ? _self.categoryLabel : categoryLabel // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,nudge: null == nudge ? _self.nudge : nudge // ignore: cast_nullable_to_non_nullable
as String,topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String?,topicName: freezed == topicName ? _self.topicName : topicName // ignore: cast_nullable_to_non_nullable
as String?,topicPath: freezed == topicPath ? _self.topicPath : topicPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Author {

 String get id; String get username;@JsonKey(name: 'display_name') String get displayName;@JsonKey(name: 'avatar_url') String? get avatarUrl; int get streak;
/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorCopyWith<Author> get copyWith => _$AuthorCopyWithImpl<Author>(this as Author, _$identity);

  /// Serializes this Author to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Author;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Author&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.streak, _this.streak) || other.streak == _this.streak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Author;
  return Object.hash(runtimeType,_this.id,_this.username,_this.displayName,_this.avatarUrl,_this.streak);
}

@override
String toString() {
  final _this = this as Author;
  return 'Author(id: ${_this.id}, username: ${_this.username}, displayName: ${_this.displayName}, avatarUrl: ${_this.avatarUrl}, streak: ${_this.streak})';
}


}

/// @nodoc
abstract mixin class $AuthorCopyWith<$Res>  {
  factory $AuthorCopyWith(Author value, $Res Function(Author) _then) = _$AuthorCopyWithImpl;
@useResult
$Res call({
 String id, String username,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'avatar_url') String? avatarUrl, int streak
});




}
/// @nodoc
class _$AuthorCopyWithImpl<$Res>
    implements $AuthorCopyWith<$Res> {
  _$AuthorCopyWithImpl(this._self, this._then);

  final Author _self;
  final $Res Function(Author) _then;

/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? avatarUrl = freezed,Object? streak = null,}) {
  return _then(Author(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Author].
extension AuthorPatterns on Author {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Author value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Author() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Author value)  $default,){
final _that = this;
switch (_that) {
case _Author():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Author value)?  $default,){
final _that = this;
switch (_that) {
case _Author() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  int streak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Author() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl,_that.streak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  int streak)  $default,) {final _that = this;
switch (_that) {
case _Author():
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl,_that.streak);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  int streak)?  $default,) {final _that = this;
switch (_that) {
case _Author() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl,_that.streak);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Author implements Author {
  const _Author({required this.id, required this.username, @JsonKey(name: 'display_name') this.displayName = '', @JsonKey(name: 'avatar_url') this.avatarUrl, this.streak = 0});
  factory _Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

@override final  String id;
@override final  String username;
@override@JsonKey(name: 'display_name') final  String displayName;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey() final  int streak;

/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthorCopyWith<_Author> get copyWith => __$AuthorCopyWithImpl<_Author>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthorToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Author&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.streak, streak) || other.streak == streak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,username,displayName,avatarUrl,streak);
}

@override
String toString() {
    return 'Author(id: $id, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, streak: $streak)';
}


}

/// @nodoc
abstract mixin class _$AuthorCopyWith<$Res> implements $AuthorCopyWith<$Res> {
  factory _$AuthorCopyWith(_Author value, $Res Function(_Author) _then) = __$AuthorCopyWithImpl;
@override @useResult
$Res call({
 String id, String username,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'avatar_url') String? avatarUrl, int streak
});




}
/// @nodoc
class __$AuthorCopyWithImpl<$Res>
    implements _$AuthorCopyWith<$Res> {
  __$AuthorCopyWithImpl(this._self, this._then);

  final _Author _self;
  final $Res Function(_Author) _then;

/// Create a copy of Author
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? avatarUrl = freezed,Object? streak = null,}) {
  return _then(_Author(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Submission {

 String get id; String get kind; String get body;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'image_width') int? get imageWidth;@JsonKey(name: 'image_height') int? get imageHeight; String get status;@JsonKey(name: 'published_at') DateTime? get publishedAt;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'reaction_count') int get reactionCount;@JsonKey(name: 'comment_count') int get commentCount;@JsonKey(name: 'is_mine') bool get isMine; Author get author;@JsonKey(name: 'prompt_id') String get promptId;@JsonKey(name: 'prompt_text') String get promptText;@JsonKey(name: 'prompt_category') String get promptCategory;@JsonKey(name: 'prompt_nudge') String get promptNudge;@JsonKey(name: 'prompt_date') DateTime? get promptDate;@JsonKey(name: 'topic_name') String? get topicName;@JsonKey(name: 'topic_path') String? get topicPath;@JsonKey(name: 'my_reactions') List<String> get myReactions;@JsonKey(name: 'reaction_counts') Map<String, int> get reactionCounts;
/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionCopyWith<Submission> get copyWith => _$SubmissionCopyWithImpl<Submission>(this as Submission, _$identity);

  /// Serializes this Submission to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Submission;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Submission&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.imageWidth, _this.imageWidth) || other.imageWidth == _this.imageWidth)&&(identical(other.imageHeight, _this.imageHeight) || other.imageHeight == _this.imageHeight)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.publishedAt, _this.publishedAt) || other.publishedAt == _this.publishedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.reactionCount, _this.reactionCount) || other.reactionCount == _this.reactionCount)&&(identical(other.commentCount, _this.commentCount) || other.commentCount == _this.commentCount)&&(identical(other.isMine, _this.isMine) || other.isMine == _this.isMine)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.promptId, _this.promptId) || other.promptId == _this.promptId)&&(identical(other.promptText, _this.promptText) || other.promptText == _this.promptText)&&(identical(other.promptCategory, _this.promptCategory) || other.promptCategory == _this.promptCategory)&&(identical(other.promptNudge, _this.promptNudge) || other.promptNudge == _this.promptNudge)&&(identical(other.promptDate, _this.promptDate) || other.promptDate == _this.promptDate)&&(identical(other.topicName, _this.topicName) || other.topicName == _this.topicName)&&(identical(other.topicPath, _this.topicPath) || other.topicPath == _this.topicPath)&&const DeepCollectionEquality().equals(other.myReactions, _this.myReactions)&&const DeepCollectionEquality().equals(other.reactionCounts, _this.reactionCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Submission;
  return Object.hashAll([runtimeType,_this.id,_this.kind,_this.body,_this.imageUrl,_this.imageWidth,_this.imageHeight,_this.status,_this.publishedAt,_this.createdAt,_this.reactionCount,_this.commentCount,_this.isMine,_this.author,_this.promptId,_this.promptText,_this.promptCategory,_this.promptNudge,_this.promptDate,_this.topicName,_this.topicPath,const DeepCollectionEquality().hash(_this.myReactions),const DeepCollectionEquality().hash(_this.reactionCounts)]);
}

@override
String toString() {
  final _this = this as Submission;
  return 'Submission(id: ${_this.id}, kind: ${_this.kind}, body: ${_this.body}, imageUrl: ${_this.imageUrl}, imageWidth: ${_this.imageWidth}, imageHeight: ${_this.imageHeight}, status: ${_this.status}, publishedAt: ${_this.publishedAt}, createdAt: ${_this.createdAt}, reactionCount: ${_this.reactionCount}, commentCount: ${_this.commentCount}, isMine: ${_this.isMine}, author: ${_this.author}, promptId: ${_this.promptId}, promptText: ${_this.promptText}, promptCategory: ${_this.promptCategory}, promptNudge: ${_this.promptNudge}, promptDate: ${_this.promptDate}, topicName: ${_this.topicName}, topicPath: ${_this.topicPath}, myReactions: ${_this.myReactions}, reactionCounts: ${_this.reactionCounts})';
}


}

/// @nodoc
abstract mixin class $SubmissionCopyWith<$Res>  {
  factory $SubmissionCopyWith(Submission value, $Res Function(Submission) _then) = _$SubmissionCopyWithImpl;
@useResult
$Res call({
 String id, String kind, String body,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'image_width') int? imageWidth,@JsonKey(name: 'image_height') int? imageHeight, String status,@JsonKey(name: 'published_at') DateTime? publishedAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'reaction_count') int reactionCount,@JsonKey(name: 'comment_count') int commentCount,@JsonKey(name: 'is_mine') bool isMine, Author author,@JsonKey(name: 'prompt_id') String promptId,@JsonKey(name: 'prompt_text') String promptText,@JsonKey(name: 'prompt_category') String promptCategory,@JsonKey(name: 'prompt_nudge') String promptNudge,@JsonKey(name: 'prompt_date') DateTime? promptDate,@JsonKey(name: 'topic_name') String? topicName,@JsonKey(name: 'topic_path') String? topicPath,@JsonKey(name: 'my_reactions') List<String> myReactions,@JsonKey(name: 'reaction_counts') Map<String, int> reactionCounts
});


$AuthorCopyWith<$Res> get author;

}
/// @nodoc
class _$SubmissionCopyWithImpl<$Res>
    implements $SubmissionCopyWith<$Res> {
  _$SubmissionCopyWithImpl(this._self, this._then);

  final Submission _self;
  final $Res Function(Submission) _then;

/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? body = null,Object? imageUrl = freezed,Object? imageWidth = freezed,Object? imageHeight = freezed,Object? status = null,Object? publishedAt = freezed,Object? createdAt = freezed,Object? reactionCount = null,Object? commentCount = null,Object? isMine = null,Object? author = null,Object? promptId = null,Object? promptText = null,Object? promptCategory = null,Object? promptNudge = null,Object? promptDate = freezed,Object? topicName = freezed,Object? topicPath = freezed,Object? myReactions = null,Object? reactionCounts = null,}) {
  return _then(Submission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageWidth: freezed == imageWidth ? _self.imageWidth : imageWidth // ignore: cast_nullable_to_non_nullable
as int?,imageHeight: freezed == imageHeight ? _self.imageHeight : imageHeight // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reactionCount: null == reactionCount ? _self.reactionCount : reactionCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author,promptId: null == promptId ? _self.promptId : promptId // ignore: cast_nullable_to_non_nullable
as String,promptText: null == promptText ? _self.promptText : promptText // ignore: cast_nullable_to_non_nullable
as String,promptCategory: null == promptCategory ? _self.promptCategory : promptCategory // ignore: cast_nullable_to_non_nullable
as String,promptNudge: null == promptNudge ? _self.promptNudge : promptNudge // ignore: cast_nullable_to_non_nullable
as String,promptDate: freezed == promptDate ? _self.promptDate : promptDate // ignore: cast_nullable_to_non_nullable
as DateTime?,topicName: freezed == topicName ? _self.topicName : topicName // ignore: cast_nullable_to_non_nullable
as String?,topicPath: freezed == topicPath ? _self.topicPath : topicPath // ignore: cast_nullable_to_non_nullable
as String?,myReactions: null == myReactions ? _self.myReactions : myReactions // ignore: cast_nullable_to_non_nullable
as List<String>,reactionCounts: null == reactionCounts ? _self.reactionCounts : reactionCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}
/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res> get author {
  
  return $AuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [Submission].
extension SubmissionPatterns on Submission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Submission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Submission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Submission value)  $default,){
final _that = this;
switch (_that) {
case _Submission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Submission value)?  $default,){
final _that = this;
switch (_that) {
case _Submission() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String kind,  String body, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'image_width')  int? imageWidth, @JsonKey(name: 'image_height')  int? imageHeight,  String status, @JsonKey(name: 'published_at')  DateTime? publishedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'reaction_count')  int reactionCount, @JsonKey(name: 'comment_count')  int commentCount, @JsonKey(name: 'is_mine')  bool isMine,  Author author, @JsonKey(name: 'prompt_id')  String promptId, @JsonKey(name: 'prompt_text')  String promptText, @JsonKey(name: 'prompt_category')  String promptCategory, @JsonKey(name: 'prompt_nudge')  String promptNudge, @JsonKey(name: 'prompt_date')  DateTime? promptDate, @JsonKey(name: 'topic_name')  String? topicName, @JsonKey(name: 'topic_path')  String? topicPath, @JsonKey(name: 'my_reactions')  List<String> myReactions, @JsonKey(name: 'reaction_counts')  Map<String, int> reactionCounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Submission() when $default != null:
return $default(_that.id,_that.kind,_that.body,_that.imageUrl,_that.imageWidth,_that.imageHeight,_that.status,_that.publishedAt,_that.createdAt,_that.reactionCount,_that.commentCount,_that.isMine,_that.author,_that.promptId,_that.promptText,_that.promptCategory,_that.promptNudge,_that.promptDate,_that.topicName,_that.topicPath,_that.myReactions,_that.reactionCounts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String kind,  String body, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'image_width')  int? imageWidth, @JsonKey(name: 'image_height')  int? imageHeight,  String status, @JsonKey(name: 'published_at')  DateTime? publishedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'reaction_count')  int reactionCount, @JsonKey(name: 'comment_count')  int commentCount, @JsonKey(name: 'is_mine')  bool isMine,  Author author, @JsonKey(name: 'prompt_id')  String promptId, @JsonKey(name: 'prompt_text')  String promptText, @JsonKey(name: 'prompt_category')  String promptCategory, @JsonKey(name: 'prompt_nudge')  String promptNudge, @JsonKey(name: 'prompt_date')  DateTime? promptDate, @JsonKey(name: 'topic_name')  String? topicName, @JsonKey(name: 'topic_path')  String? topicPath, @JsonKey(name: 'my_reactions')  List<String> myReactions, @JsonKey(name: 'reaction_counts')  Map<String, int> reactionCounts)  $default,) {final _that = this;
switch (_that) {
case _Submission():
return $default(_that.id,_that.kind,_that.body,_that.imageUrl,_that.imageWidth,_that.imageHeight,_that.status,_that.publishedAt,_that.createdAt,_that.reactionCount,_that.commentCount,_that.isMine,_that.author,_that.promptId,_that.promptText,_that.promptCategory,_that.promptNudge,_that.promptDate,_that.topicName,_that.topicPath,_that.myReactions,_that.reactionCounts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String kind,  String body, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'image_width')  int? imageWidth, @JsonKey(name: 'image_height')  int? imageHeight,  String status, @JsonKey(name: 'published_at')  DateTime? publishedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'reaction_count')  int reactionCount, @JsonKey(name: 'comment_count')  int commentCount, @JsonKey(name: 'is_mine')  bool isMine,  Author author, @JsonKey(name: 'prompt_id')  String promptId, @JsonKey(name: 'prompt_text')  String promptText, @JsonKey(name: 'prompt_category')  String promptCategory, @JsonKey(name: 'prompt_nudge')  String promptNudge, @JsonKey(name: 'prompt_date')  DateTime? promptDate, @JsonKey(name: 'topic_name')  String? topicName, @JsonKey(name: 'topic_path')  String? topicPath, @JsonKey(name: 'my_reactions')  List<String> myReactions, @JsonKey(name: 'reaction_counts')  Map<String, int> reactionCounts)?  $default,) {final _that = this;
switch (_that) {
case _Submission() when $default != null:
return $default(_that.id,_that.kind,_that.body,_that.imageUrl,_that.imageWidth,_that.imageHeight,_that.status,_that.publishedAt,_that.createdAt,_that.reactionCount,_that.commentCount,_that.isMine,_that.author,_that.promptId,_that.promptText,_that.promptCategory,_that.promptNudge,_that.promptDate,_that.topicName,_that.topicPath,_that.myReactions,_that.reactionCounts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Submission extends Submission {
  const _Submission({required this.id, this.kind = 'text', this.body = '', @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'image_width') this.imageWidth, @JsonKey(name: 'image_height') this.imageHeight, this.status = 'draft', @JsonKey(name: 'published_at') this.publishedAt, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'reaction_count') this.reactionCount = 0, @JsonKey(name: 'comment_count') this.commentCount = 0, @JsonKey(name: 'is_mine') this.isMine = false, required this.author, @JsonKey(name: 'prompt_id') this.promptId = '', @JsonKey(name: 'prompt_text') this.promptText = '', @JsonKey(name: 'prompt_category') this.promptCategory = 'writing', @JsonKey(name: 'prompt_nudge') this.promptNudge = '', @JsonKey(name: 'prompt_date') this.promptDate, @JsonKey(name: 'topic_name') this.topicName, @JsonKey(name: 'topic_path') this.topicPath, @JsonKey(name: 'my_reactions')  List<String> myReactions = const <String>[], @JsonKey(name: 'reaction_counts')  Map<String, int> reactionCounts = const <String, int>{}}): _myReactions = myReactions,_reactionCounts = reactionCounts,super._();
  factory _Submission.fromJson(Map<String, dynamic> json) => _$SubmissionFromJson(json);

@override final  String id;
@override@JsonKey() final  String kind;
@override@JsonKey() final  String body;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'image_width') final  int? imageWidth;
@override@JsonKey(name: 'image_height') final  int? imageHeight;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'published_at') final  DateTime? publishedAt;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'reaction_count') final  int reactionCount;
@override@JsonKey(name: 'comment_count') final  int commentCount;
@override@JsonKey(name: 'is_mine') final  bool isMine;
@override final  Author author;
@override@JsonKey(name: 'prompt_id') final  String promptId;
@override@JsonKey(name: 'prompt_text') final  String promptText;
@override@JsonKey(name: 'prompt_category') final  String promptCategory;
@override@JsonKey(name: 'prompt_nudge') final  String promptNudge;
@override@JsonKey(name: 'prompt_date') final  DateTime? promptDate;
@override@JsonKey(name: 'topic_name') final  String? topicName;
@override@JsonKey(name: 'topic_path') final  String? topicPath;
 final  List<String> _myReactions;
@override@JsonKey(name: 'my_reactions') List<String> get myReactions {
  if (_myReactions is EqualUnmodifiableListView) return _myReactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_myReactions);
}

 final  Map<String, int> _reactionCounts;
@override@JsonKey(name: 'reaction_counts') Map<String, int> get reactionCounts {
  if (_reactionCounts is EqualUnmodifiableMapView) return _reactionCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_reactionCounts);
}


/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmissionCopyWith<_Submission> get copyWith => __$SubmissionCopyWithImpl<_Submission>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmissionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submission&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.body, body) || other.body == body)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageWidth, imageWidth) || other.imageWidth == imageWidth)&&(identical(other.imageHeight, imageHeight) || other.imageHeight == imageHeight)&&(identical(other.status, status) || other.status == status)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.reactionCount, reactionCount) || other.reactionCount == reactionCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.author, author) || other.author == author)&&(identical(other.promptId, promptId) || other.promptId == promptId)&&(identical(other.promptText, promptText) || other.promptText == promptText)&&(identical(other.promptCategory, promptCategory) || other.promptCategory == promptCategory)&&(identical(other.promptNudge, promptNudge) || other.promptNudge == promptNudge)&&(identical(other.promptDate, promptDate) || other.promptDate == promptDate)&&(identical(other.topicName, topicName) || other.topicName == topicName)&&(identical(other.topicPath, topicPath) || other.topicPath == topicPath)&&const DeepCollectionEquality().equals(other.myReactions, _myReactions)&&const DeepCollectionEquality().equals(other.reactionCounts, _reactionCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,kind,body,imageUrl,imageWidth,imageHeight,status,publishedAt,createdAt,reactionCount,commentCount,isMine,author,promptId,promptText,promptCategory,promptNudge,promptDate,topicName,topicPath,const DeepCollectionEquality().hash(_myReactions),const DeepCollectionEquality().hash(_reactionCounts)]);
}

@override
String toString() {
    return 'Submission(id: $id, kind: $kind, body: $body, imageUrl: $imageUrl, imageWidth: $imageWidth, imageHeight: $imageHeight, status: $status, publishedAt: $publishedAt, createdAt: $createdAt, reactionCount: $reactionCount, commentCount: $commentCount, isMine: $isMine, author: $author, promptId: $promptId, promptText: $promptText, promptCategory: $promptCategory, promptNudge: $promptNudge, promptDate: $promptDate, topicName: $topicName, topicPath: $topicPath, myReactions: $myReactions, reactionCounts: $reactionCounts)';
}


}

/// @nodoc
abstract mixin class _$SubmissionCopyWith<$Res> implements $SubmissionCopyWith<$Res> {
  factory _$SubmissionCopyWith(_Submission value, $Res Function(_Submission) _then) = __$SubmissionCopyWithImpl;
@override @useResult
$Res call({
 String id, String kind, String body,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'image_width') int? imageWidth,@JsonKey(name: 'image_height') int? imageHeight, String status,@JsonKey(name: 'published_at') DateTime? publishedAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'reaction_count') int reactionCount,@JsonKey(name: 'comment_count') int commentCount,@JsonKey(name: 'is_mine') bool isMine, Author author,@JsonKey(name: 'prompt_id') String promptId,@JsonKey(name: 'prompt_text') String promptText,@JsonKey(name: 'prompt_category') String promptCategory,@JsonKey(name: 'prompt_nudge') String promptNudge,@JsonKey(name: 'prompt_date') DateTime? promptDate,@JsonKey(name: 'topic_name') String? topicName,@JsonKey(name: 'topic_path') String? topicPath,@JsonKey(name: 'my_reactions') List<String> myReactions,@JsonKey(name: 'reaction_counts') Map<String, int> reactionCounts
});


@override $AuthorCopyWith<$Res> get author;

}
/// @nodoc
class __$SubmissionCopyWithImpl<$Res>
    implements _$SubmissionCopyWith<$Res> {
  __$SubmissionCopyWithImpl(this._self, this._then);

  final _Submission _self;
  final $Res Function(_Submission) _then;

/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? body = null,Object? imageUrl = freezed,Object? imageWidth = freezed,Object? imageHeight = freezed,Object? status = null,Object? publishedAt = freezed,Object? createdAt = freezed,Object? reactionCount = null,Object? commentCount = null,Object? isMine = null,Object? author = null,Object? promptId = null,Object? promptText = null,Object? promptCategory = null,Object? promptNudge = null,Object? promptDate = freezed,Object? topicName = freezed,Object? topicPath = freezed,Object? myReactions = null,Object? reactionCounts = null,}) {
  return _then(_Submission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageWidth: freezed == imageWidth ? _self.imageWidth : imageWidth // ignore: cast_nullable_to_non_nullable
as int?,imageHeight: freezed == imageHeight ? _self.imageHeight : imageHeight // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reactionCount: null == reactionCount ? _self.reactionCount : reactionCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as Author,promptId: null == promptId ? _self.promptId : promptId // ignore: cast_nullable_to_non_nullable
as String,promptText: null == promptText ? _self.promptText : promptText // ignore: cast_nullable_to_non_nullable
as String,promptCategory: null == promptCategory ? _self.promptCategory : promptCategory // ignore: cast_nullable_to_non_nullable
as String,promptNudge: null == promptNudge ? _self.promptNudge : promptNudge // ignore: cast_nullable_to_non_nullable
as String,promptDate: freezed == promptDate ? _self.promptDate : promptDate // ignore: cast_nullable_to_non_nullable
as DateTime?,topicName: freezed == topicName ? _self.topicName : topicName // ignore: cast_nullable_to_non_nullable
as String?,topicPath: freezed == topicPath ? _self.topicPath : topicPath // ignore: cast_nullable_to_non_nullable
as String?,myReactions: null == myReactions ? _self._myReactions : myReactions // ignore: cast_nullable_to_non_nullable
as List<String>,reactionCounts: null == reactionCounts ? _self._reactionCounts : reactionCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

/// Create a copy of Submission
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorCopyWith<$Res> get author {
  
  return $AuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// @nodoc
mixin _$Comment {

 String get id; String get body;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'is_mine') bool get isMine;@JsonKey(name: 'author_username') String get authorUsername;@JsonKey(name: 'author_name') String get authorName;@JsonKey(name: 'author_avatar_url') String? get authorAvatarUrl;@JsonKey(name: 'parent_id') String? get parentId;@JsonKey(name: 'reply_count') int get replyCount; List<Comment> get replies;
/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentCopyWith<Comment> get copyWith => _$CommentCopyWithImpl<Comment>(this as Comment, _$identity);

  /// Serializes this Comment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Comment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Comment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.isMine, _this.isMine) || other.isMine == _this.isMine)&&(identical(other.authorUsername, _this.authorUsername) || other.authorUsername == _this.authorUsername)&&(identical(other.authorName, _this.authorName) || other.authorName == _this.authorName)&&(identical(other.authorAvatarUrl, _this.authorAvatarUrl) || other.authorAvatarUrl == _this.authorAvatarUrl)&&(identical(other.parentId, _this.parentId) || other.parentId == _this.parentId)&&(identical(other.replyCount, _this.replyCount) || other.replyCount == _this.replyCount)&&const DeepCollectionEquality().equals(other.replies, _this.replies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Comment;
  return Object.hash(runtimeType,_this.id,_this.body,_this.createdAt,_this.isMine,_this.authorUsername,_this.authorName,_this.authorAvatarUrl,_this.parentId,_this.replyCount,const DeepCollectionEquality().hash(_this.replies));
}

@override
String toString() {
  final _this = this as Comment;
  return 'Comment(id: ${_this.id}, body: ${_this.body}, createdAt: ${_this.createdAt}, isMine: ${_this.isMine}, authorUsername: ${_this.authorUsername}, authorName: ${_this.authorName}, authorAvatarUrl: ${_this.authorAvatarUrl}, parentId: ${_this.parentId}, replyCount: ${_this.replyCount}, replies: ${_this.replies})';
}


}

/// @nodoc
abstract mixin class $CommentCopyWith<$Res>  {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) _then) = _$CommentCopyWithImpl;
@useResult
$Res call({
 String id, String body,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'is_mine') bool isMine,@JsonKey(name: 'author_username') String authorUsername,@JsonKey(name: 'author_name') String authorName,@JsonKey(name: 'author_avatar_url') String? authorAvatarUrl,@JsonKey(name: 'parent_id') String? parentId,@JsonKey(name: 'reply_count') int replyCount, List<Comment> replies
});




}
/// @nodoc
class _$CommentCopyWithImpl<$Res>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._self, this._then);

  final Comment _self;
  final $Res Function(Comment) _then;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? body = null,Object? createdAt = null,Object? isMine = null,Object? authorUsername = null,Object? authorName = null,Object? authorAvatarUrl = freezed,Object? parentId = freezed,Object? replyCount = null,Object? replies = null,}) {
  return _then(Comment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,authorUsername: null == authorUsername ? _self.authorUsername : authorUsername // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorAvatarUrl: freezed == authorAvatarUrl ? _self.authorAvatarUrl : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as List<Comment>,
  ));
}

}


/// Adds pattern-matching-related methods to [Comment].
extension CommentPatterns on Comment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Comment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Comment value)  $default,){
final _that = this;
switch (_that) {
case _Comment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Comment value)?  $default,){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String body, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'is_mine')  bool isMine, @JsonKey(name: 'author_username')  String authorUsername, @JsonKey(name: 'author_name')  String authorName, @JsonKey(name: 'author_avatar_url')  String? authorAvatarUrl, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'reply_count')  int replyCount,  List<Comment> replies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.id,_that.body,_that.createdAt,_that.isMine,_that.authorUsername,_that.authorName,_that.authorAvatarUrl,_that.parentId,_that.replyCount,_that.replies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String body, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'is_mine')  bool isMine, @JsonKey(name: 'author_username')  String authorUsername, @JsonKey(name: 'author_name')  String authorName, @JsonKey(name: 'author_avatar_url')  String? authorAvatarUrl, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'reply_count')  int replyCount,  List<Comment> replies)  $default,) {final _that = this;
switch (_that) {
case _Comment():
return $default(_that.id,_that.body,_that.createdAt,_that.isMine,_that.authorUsername,_that.authorName,_that.authorAvatarUrl,_that.parentId,_that.replyCount,_that.replies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String body, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'is_mine')  bool isMine, @JsonKey(name: 'author_username')  String authorUsername, @JsonKey(name: 'author_name')  String authorName, @JsonKey(name: 'author_avatar_url')  String? authorAvatarUrl, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'reply_count')  int replyCount,  List<Comment> replies)?  $default,) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.id,_that.body,_that.createdAt,_that.isMine,_that.authorUsername,_that.authorName,_that.authorAvatarUrl,_that.parentId,_that.replyCount,_that.replies);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Comment implements Comment {
  const _Comment({required this.id, required this.body, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'is_mine') this.isMine = false, @JsonKey(name: 'author_username') this.authorUsername = '', @JsonKey(name: 'author_name') this.authorName = '', @JsonKey(name: 'author_avatar_url') this.authorAvatarUrl, @JsonKey(name: 'parent_id') this.parentId, @JsonKey(name: 'reply_count') this.replyCount = 0,  List<Comment> replies = const <Comment>[]}): _replies = replies;
  factory _Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

@override final  String id;
@override final  String body;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'is_mine') final  bool isMine;
@override@JsonKey(name: 'author_username') final  String authorUsername;
@override@JsonKey(name: 'author_name') final  String authorName;
@override@JsonKey(name: 'author_avatar_url') final  String? authorAvatarUrl;
@override@JsonKey(name: 'parent_id') final  String? parentId;
@override@JsonKey(name: 'reply_count') final  int replyCount;
 final  List<Comment> _replies;
@override@JsonKey() List<Comment> get replies {
  if (_replies is EqualUnmodifiableListView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_replies);
}


/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentCopyWith<_Comment> get copyWith => __$CommentCopyWithImpl<_Comment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Comment&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.authorUsername, authorUsername) || other.authorUsername == authorUsername)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorAvatarUrl, authorAvatarUrl) || other.authorAvatarUrl == authorAvatarUrl)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&const DeepCollectionEquality().equals(other.replies, _replies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,body,createdAt,isMine,authorUsername,authorName,authorAvatarUrl,parentId,replyCount,const DeepCollectionEquality().hash(_replies));
}

@override
String toString() {
    return 'Comment(id: $id, body: $body, createdAt: $createdAt, isMine: $isMine, authorUsername: $authorUsername, authorName: $authorName, authorAvatarUrl: $authorAvatarUrl, parentId: $parentId, replyCount: $replyCount, replies: $replies)';
}


}

/// @nodoc
abstract mixin class _$CommentCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$CommentCopyWith(_Comment value, $Res Function(_Comment) _then) = __$CommentCopyWithImpl;
@override @useResult
$Res call({
 String id, String body,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'is_mine') bool isMine,@JsonKey(name: 'author_username') String authorUsername,@JsonKey(name: 'author_name') String authorName,@JsonKey(name: 'author_avatar_url') String? authorAvatarUrl,@JsonKey(name: 'parent_id') String? parentId,@JsonKey(name: 'reply_count') int replyCount, List<Comment> replies
});




}
/// @nodoc
class __$CommentCopyWithImpl<$Res>
    implements _$CommentCopyWith<$Res> {
  __$CommentCopyWithImpl(this._self, this._then);

  final _Comment _self;
  final $Res Function(_Comment) _then;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? body = null,Object? createdAt = null,Object? isMine = null,Object? authorUsername = null,Object? authorName = null,Object? authorAvatarUrl = freezed,Object? parentId = freezed,Object? replyCount = null,Object? replies = null,}) {
  return _then(_Comment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,authorUsername: null == authorUsername ? _self.authorUsername : authorUsername // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorAvatarUrl: freezed == authorAvatarUrl ? _self.authorAvatarUrl : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,replies: null == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as List<Comment>,
  ));
}


}


/// @nodoc
mixin _$Today {

 Prompt get prompt;@JsonKey(name: 'seconds_remaining') int get secondsRemaining;@JsonKey(name: 'creator_count') int get creatorCount;@JsonKey(name: 'my_submission') Submission? get mySubmission; Streak get streak;@JsonKey(name: 'other_prompts') List<Prompt> get otherPrompts;
/// Create a copy of Today
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayCopyWith<Today> get copyWith => _$TodayCopyWithImpl<Today>(this as Today, _$identity);

  /// Serializes this Today to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Today;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Today&&(identical(other.prompt, _this.prompt) || other.prompt == _this.prompt)&&(identical(other.secondsRemaining, _this.secondsRemaining) || other.secondsRemaining == _this.secondsRemaining)&&(identical(other.creatorCount, _this.creatorCount) || other.creatorCount == _this.creatorCount)&&(identical(other.mySubmission, _this.mySubmission) || other.mySubmission == _this.mySubmission)&&(identical(other.streak, _this.streak) || other.streak == _this.streak)&&const DeepCollectionEquality().equals(other.otherPrompts, _this.otherPrompts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Today;
  return Object.hash(runtimeType,_this.prompt,_this.secondsRemaining,_this.creatorCount,_this.mySubmission,_this.streak,const DeepCollectionEquality().hash(_this.otherPrompts));
}

@override
String toString() {
  final _this = this as Today;
  return 'Today(prompt: ${_this.prompt}, secondsRemaining: ${_this.secondsRemaining}, creatorCount: ${_this.creatorCount}, mySubmission: ${_this.mySubmission}, streak: ${_this.streak}, otherPrompts: ${_this.otherPrompts})';
}


}

/// @nodoc
abstract mixin class $TodayCopyWith<$Res>  {
  factory $TodayCopyWith(Today value, $Res Function(Today) _then) = _$TodayCopyWithImpl;
@useResult
$Res call({
 Prompt prompt,@JsonKey(name: 'seconds_remaining') int secondsRemaining,@JsonKey(name: 'creator_count') int creatorCount,@JsonKey(name: 'my_submission') Submission? mySubmission, Streak streak,@JsonKey(name: 'other_prompts') List<Prompt> otherPrompts
});


$PromptCopyWith<$Res> get prompt;$SubmissionCopyWith<$Res>? get mySubmission;$StreakCopyWith<$Res> get streak;

}
/// @nodoc
class _$TodayCopyWithImpl<$Res>
    implements $TodayCopyWith<$Res> {
  _$TodayCopyWithImpl(this._self, this._then);

  final Today _self;
  final $Res Function(Today) _then;

/// Create a copy of Today
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? prompt = null,Object? secondsRemaining = null,Object? creatorCount = null,Object? mySubmission = freezed,Object? streak = null,Object? otherPrompts = null,}) {
  return _then(Today(
prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as Prompt,secondsRemaining: null == secondsRemaining ? _self.secondsRemaining : secondsRemaining // ignore: cast_nullable_to_non_nullable
as int,creatorCount: null == creatorCount ? _self.creatorCount : creatorCount // ignore: cast_nullable_to_non_nullable
as int,mySubmission: freezed == mySubmission ? _self.mySubmission : mySubmission // ignore: cast_nullable_to_non_nullable
as Submission?,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as Streak,otherPrompts: null == otherPrompts ? _self.otherPrompts : otherPrompts // ignore: cast_nullable_to_non_nullable
as List<Prompt>,
  ));
}
/// Create a copy of Today
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromptCopyWith<$Res> get prompt {
  
  return $PromptCopyWith<$Res>(_self.prompt, (value) {
    return _then(_self.copyWith(prompt: value));
  });
}/// Create a copy of Today
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubmissionCopyWith<$Res>? get mySubmission {
    if (_self.mySubmission == null) {
    return null;
  }

  return $SubmissionCopyWith<$Res>(_self.mySubmission!, (value) {
    return _then(_self.copyWith(mySubmission: value));
  });
}/// Create a copy of Today
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreakCopyWith<$Res> get streak {
  
  return $StreakCopyWith<$Res>(_self.streak, (value) {
    return _then(_self.copyWith(streak: value));
  });
}
}


/// Adds pattern-matching-related methods to [Today].
extension TodayPatterns on Today {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Today value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Today() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Today value)  $default,){
final _that = this;
switch (_that) {
case _Today():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Today value)?  $default,){
final _that = this;
switch (_that) {
case _Today() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Prompt prompt, @JsonKey(name: 'seconds_remaining')  int secondsRemaining, @JsonKey(name: 'creator_count')  int creatorCount, @JsonKey(name: 'my_submission')  Submission? mySubmission,  Streak streak, @JsonKey(name: 'other_prompts')  List<Prompt> otherPrompts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Today() when $default != null:
return $default(_that.prompt,_that.secondsRemaining,_that.creatorCount,_that.mySubmission,_that.streak,_that.otherPrompts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Prompt prompt, @JsonKey(name: 'seconds_remaining')  int secondsRemaining, @JsonKey(name: 'creator_count')  int creatorCount, @JsonKey(name: 'my_submission')  Submission? mySubmission,  Streak streak, @JsonKey(name: 'other_prompts')  List<Prompt> otherPrompts)  $default,) {final _that = this;
switch (_that) {
case _Today():
return $default(_that.prompt,_that.secondsRemaining,_that.creatorCount,_that.mySubmission,_that.streak,_that.otherPrompts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Prompt prompt, @JsonKey(name: 'seconds_remaining')  int secondsRemaining, @JsonKey(name: 'creator_count')  int creatorCount, @JsonKey(name: 'my_submission')  Submission? mySubmission,  Streak streak, @JsonKey(name: 'other_prompts')  List<Prompt> otherPrompts)?  $default,) {final _that = this;
switch (_that) {
case _Today() when $default != null:
return $default(_that.prompt,_that.secondsRemaining,_that.creatorCount,_that.mySubmission,_that.streak,_that.otherPrompts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Today implements Today {
  const _Today({required this.prompt, @JsonKey(name: 'seconds_remaining') this.secondsRemaining = 0, @JsonKey(name: 'creator_count') this.creatorCount = 0, @JsonKey(name: 'my_submission') this.mySubmission, this.streak = const Streak(), @JsonKey(name: 'other_prompts')  List<Prompt> otherPrompts = const <Prompt>[]}): _otherPrompts = otherPrompts;
  factory _Today.fromJson(Map<String, dynamic> json) => _$TodayFromJson(json);

@override final  Prompt prompt;
@override@JsonKey(name: 'seconds_remaining') final  int secondsRemaining;
@override@JsonKey(name: 'creator_count') final  int creatorCount;
@override@JsonKey(name: 'my_submission') final  Submission? mySubmission;
@override@JsonKey() final  Streak streak;
 final  List<Prompt> _otherPrompts;
@override@JsonKey(name: 'other_prompts') List<Prompt> get otherPrompts {
  if (_otherPrompts is EqualUnmodifiableListView) return _otherPrompts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_otherPrompts);
}


/// Create a copy of Today
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayCopyWith<_Today> get copyWith => __$TodayCopyWithImpl<_Today>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodayToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Today&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.secondsRemaining, secondsRemaining) || other.secondsRemaining == secondsRemaining)&&(identical(other.creatorCount, creatorCount) || other.creatorCount == creatorCount)&&(identical(other.mySubmission, mySubmission) || other.mySubmission == mySubmission)&&(identical(other.streak, streak) || other.streak == streak)&&const DeepCollectionEquality().equals(other.otherPrompts, _otherPrompts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,prompt,secondsRemaining,creatorCount,mySubmission,streak,const DeepCollectionEquality().hash(_otherPrompts));
}

@override
String toString() {
    return 'Today(prompt: $prompt, secondsRemaining: $secondsRemaining, creatorCount: $creatorCount, mySubmission: $mySubmission, streak: $streak, otherPrompts: $otherPrompts)';
}


}

/// @nodoc
abstract mixin class _$TodayCopyWith<$Res> implements $TodayCopyWith<$Res> {
  factory _$TodayCopyWith(_Today value, $Res Function(_Today) _then) = __$TodayCopyWithImpl;
@override @useResult
$Res call({
 Prompt prompt,@JsonKey(name: 'seconds_remaining') int secondsRemaining,@JsonKey(name: 'creator_count') int creatorCount,@JsonKey(name: 'my_submission') Submission? mySubmission, Streak streak,@JsonKey(name: 'other_prompts') List<Prompt> otherPrompts
});


@override $PromptCopyWith<$Res> get prompt;@override $SubmissionCopyWith<$Res>? get mySubmission;@override $StreakCopyWith<$Res> get streak;

}
/// @nodoc
class __$TodayCopyWithImpl<$Res>
    implements _$TodayCopyWith<$Res> {
  __$TodayCopyWithImpl(this._self, this._then);

  final _Today _self;
  final $Res Function(_Today) _then;

/// Create a copy of Today
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? prompt = null,Object? secondsRemaining = null,Object? creatorCount = null,Object? mySubmission = freezed,Object? streak = null,Object? otherPrompts = null,}) {
  return _then(_Today(
prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as Prompt,secondsRemaining: null == secondsRemaining ? _self.secondsRemaining : secondsRemaining // ignore: cast_nullable_to_non_nullable
as int,creatorCount: null == creatorCount ? _self.creatorCount : creatorCount // ignore: cast_nullable_to_non_nullable
as int,mySubmission: freezed == mySubmission ? _self.mySubmission : mySubmission // ignore: cast_nullable_to_non_nullable
as Submission?,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as Streak,otherPrompts: null == otherPrompts ? _self._otherPrompts : otherPrompts // ignore: cast_nullable_to_non_nullable
as List<Prompt>,
  ));
}

/// Create a copy of Today
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromptCopyWith<$Res> get prompt {
  
  return $PromptCopyWith<$Res>(_self.prompt, (value) {
    return _then(_self.copyWith(prompt: value));
  });
}/// Create a copy of Today
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubmissionCopyWith<$Res>? get mySubmission {
    if (_self.mySubmission == null) {
    return null;
  }

  return $SubmissionCopyWith<$Res>(_self.mySubmission!, (value) {
    return _then(_self.copyWith(mySubmission: value));
  });
}/// Create a copy of Today
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreakCopyWith<$Res> get streak {
  
  return $StreakCopyWith<$Res>(_self.streak, (value) {
    return _then(_self.copyWith(streak: value));
  });
}
}


/// @nodoc
mixin _$FeedPage {

 bool get locked;@JsonKey(name: 'creator_count') int get creatorCount; Prompt? get prompt; List<Submission> get items;@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of FeedPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedPageCopyWith<FeedPage> get copyWith => _$FeedPageCopyWithImpl<FeedPage>(this as FeedPage, _$identity);

  /// Serializes this FeedPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedPage&&(identical(other.locked, _this.locked) || other.locked == _this.locked)&&(identical(other.creatorCount, _this.creatorCount) || other.creatorCount == _this.creatorCount)&&(identical(other.prompt, _this.prompt) || other.prompt == _this.prompt)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedPage;
  return Object.hash(runtimeType,_this.locked,_this.creatorCount,_this.prompt,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as FeedPage;
  return 'FeedPage(locked: ${_this.locked}, creatorCount: ${_this.creatorCount}, prompt: ${_this.prompt}, items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $FeedPageCopyWith<$Res>  {
  factory $FeedPageCopyWith(FeedPage value, $Res Function(FeedPage) _then) = _$FeedPageCopyWithImpl;
@useResult
$Res call({
 bool locked,@JsonKey(name: 'creator_count') int creatorCount, Prompt? prompt, List<Submission> items,@JsonKey(name: 'next_cursor') String? nextCursor
});


$PromptCopyWith<$Res>? get prompt;

}
/// @nodoc
class _$FeedPageCopyWithImpl<$Res>
    implements $FeedPageCopyWith<$Res> {
  _$FeedPageCopyWithImpl(this._self, this._then);

  final FeedPage _self;
  final $Res Function(FeedPage) _then;

/// Create a copy of FeedPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locked = null,Object? creatorCount = null,Object? prompt = freezed,Object? items = null,Object? nextCursor = freezed,}) {
  return _then(FeedPage(
locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,creatorCount: null == creatorCount ? _self.creatorCount : creatorCount // ignore: cast_nullable_to_non_nullable
as int,prompt: freezed == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as Prompt?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Submission>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of FeedPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromptCopyWith<$Res>? get prompt {
    if (_self.prompt == null) {
    return null;
  }

  return $PromptCopyWith<$Res>(_self.prompt!, (value) {
    return _then(_self.copyWith(prompt: value));
  });
}
}


/// Adds pattern-matching-related methods to [FeedPage].
extension FeedPagePatterns on FeedPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedPage value)  $default,){
final _that = this;
switch (_that) {
case _FeedPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedPage value)?  $default,){
final _that = this;
switch (_that) {
case _FeedPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool locked, @JsonKey(name: 'creator_count')  int creatorCount,  Prompt? prompt,  List<Submission> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedPage() when $default != null:
return $default(_that.locked,_that.creatorCount,_that.prompt,_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool locked, @JsonKey(name: 'creator_count')  int creatorCount,  Prompt? prompt,  List<Submission> items, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _FeedPage():
return $default(_that.locked,_that.creatorCount,_that.prompt,_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool locked, @JsonKey(name: 'creator_count')  int creatorCount,  Prompt? prompt,  List<Submission> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _FeedPage() when $default != null:
return $default(_that.locked,_that.creatorCount,_that.prompt,_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedPage implements FeedPage {
  const _FeedPage({this.locked = true, @JsonKey(name: 'creator_count') this.creatorCount = 0, this.prompt,  List<Submission> items = const <Submission>[], @JsonKey(name: 'next_cursor') this.nextCursor}): _items = items;
  factory _FeedPage.fromJson(Map<String, dynamic> json) => _$FeedPageFromJson(json);

@override@JsonKey() final  bool locked;
@override@JsonKey(name: 'creator_count') final  int creatorCount;
@override final  Prompt? prompt;
 final  List<Submission> _items;
@override@JsonKey() List<Submission> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of FeedPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedPageCopyWith<_FeedPage> get copyWith => __$FeedPageCopyWithImpl<_FeedPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedPageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedPage&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.creatorCount, creatorCount) || other.creatorCount == creatorCount)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,locked,creatorCount,prompt,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'FeedPage(locked: $locked, creatorCount: $creatorCount, prompt: $prompt, items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$FeedPageCopyWith<$Res> implements $FeedPageCopyWith<$Res> {
  factory _$FeedPageCopyWith(_FeedPage value, $Res Function(_FeedPage) _then) = __$FeedPageCopyWithImpl;
@override @useResult
$Res call({
 bool locked,@JsonKey(name: 'creator_count') int creatorCount, Prompt? prompt, List<Submission> items,@JsonKey(name: 'next_cursor') String? nextCursor
});


@override $PromptCopyWith<$Res>? get prompt;

}
/// @nodoc
class __$FeedPageCopyWithImpl<$Res>
    implements _$FeedPageCopyWith<$Res> {
  __$FeedPageCopyWithImpl(this._self, this._then);

  final _FeedPage _self;
  final $Res Function(_FeedPage) _then;

/// Create a copy of FeedPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locked = null,Object? creatorCount = null,Object? prompt = freezed,Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_FeedPage(
locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,creatorCount: null == creatorCount ? _self.creatorCount : creatorCount // ignore: cast_nullable_to_non_nullable
as int,prompt: freezed == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as Prompt?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Submission>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of FeedPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromptCopyWith<$Res>? get prompt {
    if (_self.prompt == null) {
    return null;
  }

  return $PromptCopyWith<$Res>(_self.prompt!, (value) {
    return _then(_self.copyWith(prompt: value));
  });
}
}


/// @nodoc
mixin _$SubmissionPage {

 List<Submission> get items;@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of SubmissionPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionPageCopyWith<SubmissionPage> get copyWith => _$SubmissionPageCopyWithImpl<SubmissionPage>(this as SubmissionPage, _$identity);

  /// Serializes this SubmissionPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SubmissionPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmissionPage&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SubmissionPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as SubmissionPage;
  return 'SubmissionPage(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $SubmissionPageCopyWith<$Res>  {
  factory $SubmissionPageCopyWith(SubmissionPage value, $Res Function(SubmissionPage) _then) = _$SubmissionPageCopyWithImpl;
@useResult
$Res call({
 List<Submission> items,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class _$SubmissionPageCopyWithImpl<$Res>
    implements $SubmissionPageCopyWith<$Res> {
  _$SubmissionPageCopyWithImpl(this._self, this._then);

  final SubmissionPage _self;
  final $Res Function(SubmissionPage) _then;

/// Create a copy of SubmissionPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(SubmissionPage(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Submission>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubmissionPage].
extension SubmissionPagePatterns on SubmissionPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmissionPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmissionPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmissionPage value)  $default,){
final _that = this;
switch (_that) {
case _SubmissionPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmissionPage value)?  $default,){
final _that = this;
switch (_that) {
case _SubmissionPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Submission> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmissionPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Submission> items, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _SubmissionPage():
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Submission> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _SubmissionPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubmissionPage implements SubmissionPage {
  const _SubmissionPage({ List<Submission> items = const <Submission>[], @JsonKey(name: 'next_cursor') this.nextCursor}): _items = items;
  factory _SubmissionPage.fromJson(Map<String, dynamic> json) => _$SubmissionPageFromJson(json);

 final  List<Submission> _items;
@override@JsonKey() List<Submission> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of SubmissionPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmissionPageCopyWith<_SubmissionPage> get copyWith => __$SubmissionPageCopyWithImpl<_SubmissionPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmissionPageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmissionPage&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'SubmissionPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$SubmissionPageCopyWith<$Res> implements $SubmissionPageCopyWith<$Res> {
  factory _$SubmissionPageCopyWith(_SubmissionPage value, $Res Function(_SubmissionPage) _then) = __$SubmissionPageCopyWithImpl;
@override @useResult
$Res call({
 List<Submission> items,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class __$SubmissionPageCopyWithImpl<$Res>
    implements _$SubmissionPageCopyWith<$Res> {
  __$SubmissionPageCopyWithImpl(this._self, this._then);

  final _SubmissionPage _self;
  final $Res Function(_SubmissionPage) _then;

/// Create a copy of SubmissionPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_SubmissionPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Submission>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CommentPage {

 List<Comment> get items;@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of CommentPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentPageCopyWith<CommentPage> get copyWith => _$CommentPageCopyWithImpl<CommentPage>(this as CommentPage, _$identity);

  /// Serializes this CommentPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CommentPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentPage&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CommentPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as CommentPage;
  return 'CommentPage(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $CommentPageCopyWith<$Res>  {
  factory $CommentPageCopyWith(CommentPage value, $Res Function(CommentPage) _then) = _$CommentPageCopyWithImpl;
@useResult
$Res call({
 List<Comment> items,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class _$CommentPageCopyWithImpl<$Res>
    implements $CommentPageCopyWith<$Res> {
  _$CommentPageCopyWithImpl(this._self, this._then);

  final CommentPage _self;
  final $Res Function(CommentPage) _then;

/// Create a copy of CommentPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(CommentPage(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Comment>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentPage].
extension CommentPagePatterns on CommentPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentPage value)  $default,){
final _that = this;
switch (_that) {
case _CommentPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentPage value)?  $default,){
final _that = this;
switch (_that) {
case _CommentPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Comment> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Comment> items, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _CommentPage():
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Comment> items, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _CommentPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentPage implements CommentPage {
  const _CommentPage({ List<Comment> items = const <Comment>[], @JsonKey(name: 'next_cursor') this.nextCursor}): _items = items;
  factory _CommentPage.fromJson(Map<String, dynamic> json) => _$CommentPageFromJson(json);

 final  List<Comment> _items;
@override@JsonKey() List<Comment> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of CommentPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentPageCopyWith<_CommentPage> get copyWith => __$CommentPageCopyWithImpl<_CommentPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentPageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentPage&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'CommentPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$CommentPageCopyWith<$Res> implements $CommentPageCopyWith<$Res> {
  factory _$CommentPageCopyWith(_CommentPage value, $Res Function(_CommentPage) _then) = __$CommentPageCopyWithImpl;
@override @useResult
$Res call({
 List<Comment> items,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class __$CommentPageCopyWithImpl<$Res>
    implements _$CommentPageCopyWith<$Res> {
  __$CommentPageCopyWithImpl(this._self, this._then);

  final _CommentPage _self;
  final $Res Function(_CommentPage) _then;

/// Create a copy of CommentPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_CommentPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Comment>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UploadTarget {

 String get key;@JsonKey(name: 'upload_url') String get uploadUrl; Map<String, String> get headers;@JsonKey(name: 'public_url') String get publicUrl;
/// Create a copy of UploadTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadTargetCopyWith<UploadTarget> get copyWith => _$UploadTargetCopyWithImpl<UploadTarget>(this as UploadTarget, _$identity);

  /// Serializes this UploadTarget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UploadTarget;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadTarget&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.uploadUrl, _this.uploadUrl) || other.uploadUrl == _this.uploadUrl)&&const DeepCollectionEquality().equals(other.headers, _this.headers)&&(identical(other.publicUrl, _this.publicUrl) || other.publicUrl == _this.publicUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UploadTarget;
  return Object.hash(runtimeType,_this.key,_this.uploadUrl,const DeepCollectionEquality().hash(_this.headers),_this.publicUrl);
}

@override
String toString() {
  final _this = this as UploadTarget;
  return 'UploadTarget(key: ${_this.key}, uploadUrl: ${_this.uploadUrl}, headers: ${_this.headers}, publicUrl: ${_this.publicUrl})';
}


}

/// @nodoc
abstract mixin class $UploadTargetCopyWith<$Res>  {
  factory $UploadTargetCopyWith(UploadTarget value, $Res Function(UploadTarget) _then) = _$UploadTargetCopyWithImpl;
@useResult
$Res call({
 String key,@JsonKey(name: 'upload_url') String uploadUrl, Map<String, String> headers,@JsonKey(name: 'public_url') String publicUrl
});




}
/// @nodoc
class _$UploadTargetCopyWithImpl<$Res>
    implements $UploadTargetCopyWith<$Res> {
  _$UploadTargetCopyWithImpl(this._self, this._then);

  final UploadTarget _self;
  final $Res Function(UploadTarget) _then;

/// Create a copy of UploadTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? uploadUrl = null,Object? headers = null,Object? publicUrl = null,}) {
  return _then(UploadTarget(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,headers: null == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,publicUrl: null == publicUrl ? _self.publicUrl : publicUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadTarget].
extension UploadTargetPatterns on UploadTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadTarget value)  $default,){
final _that = this;
switch (_that) {
case _UploadTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadTarget value)?  $default,){
final _that = this;
switch (_that) {
case _UploadTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key, @JsonKey(name: 'upload_url')  String uploadUrl,  Map<String, String> headers, @JsonKey(name: 'public_url')  String publicUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadTarget() when $default != null:
return $default(_that.key,_that.uploadUrl,_that.headers,_that.publicUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key, @JsonKey(name: 'upload_url')  String uploadUrl,  Map<String, String> headers, @JsonKey(name: 'public_url')  String publicUrl)  $default,) {final _that = this;
switch (_that) {
case _UploadTarget():
return $default(_that.key,_that.uploadUrl,_that.headers,_that.publicUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key, @JsonKey(name: 'upload_url')  String uploadUrl,  Map<String, String> headers, @JsonKey(name: 'public_url')  String publicUrl)?  $default,) {final _that = this;
switch (_that) {
case _UploadTarget() when $default != null:
return $default(_that.key,_that.uploadUrl,_that.headers,_that.publicUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UploadTarget implements UploadTarget {
  const _UploadTarget({required this.key, @JsonKey(name: 'upload_url') required this.uploadUrl,  Map<String, String> headers = const <String, String>{}, @JsonKey(name: 'public_url') required this.publicUrl}): _headers = headers;
  factory _UploadTarget.fromJson(Map<String, dynamic> json) => _$UploadTargetFromJson(json);

@override final  String key;
@override@JsonKey(name: 'upload_url') final  String uploadUrl;
 final  Map<String, String> _headers;
@override@JsonKey() Map<String, String> get headers {
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_headers);
}

@override@JsonKey(name: 'public_url') final  String publicUrl;

/// Create a copy of UploadTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadTargetCopyWith<_UploadTarget> get copyWith => __$UploadTargetCopyWithImpl<_UploadTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadTargetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadTarget&&(identical(other.key, key) || other.key == key)&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&const DeepCollectionEquality().equals(other.headers, _headers)&&(identical(other.publicUrl, publicUrl) || other.publicUrl == publicUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,uploadUrl,const DeepCollectionEquality().hash(_headers),publicUrl);
}

@override
String toString() {
    return 'UploadTarget(key: $key, uploadUrl: $uploadUrl, headers: $headers, publicUrl: $publicUrl)';
}


}

/// @nodoc
abstract mixin class _$UploadTargetCopyWith<$Res> implements $UploadTargetCopyWith<$Res> {
  factory _$UploadTargetCopyWith(_UploadTarget value, $Res Function(_UploadTarget) _then) = __$UploadTargetCopyWithImpl;
@override @useResult
$Res call({
 String key,@JsonKey(name: 'upload_url') String uploadUrl, Map<String, String> headers,@JsonKey(name: 'public_url') String publicUrl
});




}
/// @nodoc
class __$UploadTargetCopyWithImpl<$Res>
    implements _$UploadTargetCopyWith<$Res> {
  __$UploadTargetCopyWithImpl(this._self, this._then);

  final _UploadTarget _self;
  final $Res Function(_UploadTarget) _then;

/// Create a copy of UploadTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? uploadUrl = null,Object? headers = null,Object? publicUrl = null,}) {
  return _then(_UploadTarget(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,headers: null == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,publicUrl: null == publicUrl ? _self.publicUrl : publicUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Session {

@JsonKey(name: 'access_token') String get accessToken;@JsonKey(name: 'refresh_token') String get refreshToken;@JsonKey(name: 'expires_in') int get expiresIn;@JsonKey(name: 'is_new_user') bool get isNewUser; DabbleUser get user;
/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCopyWith<Session> get copyWith => _$SessionCopyWithImpl<Session>(this as Session, _$identity);

  /// Serializes this Session to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Session;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Session&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken)&&(identical(other.expiresIn, _this.expiresIn) || other.expiresIn == _this.expiresIn)&&(identical(other.isNewUser, _this.isNewUser) || other.isNewUser == _this.isNewUser)&&(identical(other.user, _this.user) || other.user == _this.user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Session;
  return Object.hash(runtimeType,_this.accessToken,_this.refreshToken,_this.expiresIn,_this.isNewUser,_this.user);
}

@override
String toString() {
  final _this = this as Session;
  return 'Session(accessToken: ${_this.accessToken}, refreshToken: ${_this.refreshToken}, expiresIn: ${_this.expiresIn}, isNewUser: ${_this.isNewUser}, user: ${_this.user})';
}


}

/// @nodoc
abstract mixin class $SessionCopyWith<$Res>  {
  factory $SessionCopyWith(Session value, $Res Function(Session) _then) = _$SessionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'refresh_token') String refreshToken,@JsonKey(name: 'expires_in') int expiresIn,@JsonKey(name: 'is_new_user') bool isNewUser, DabbleUser user
});


$DabbleUserCopyWith<$Res> get user;

}
/// @nodoc
class _$SessionCopyWithImpl<$Res>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._self, this._then);

  final Session _self;
  final $Res Function(Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresIn = null,Object? isNewUser = null,Object? user = null,}) {
  return _then(Session(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as DabbleUser,
  ));
}
/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DabbleUserCopyWith<$Res> get user {
  
  return $DabbleUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [Session].
extension SessionPatterns on Session {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Session value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Session() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Session value)  $default,){
final _that = this;
switch (_that) {
case _Session():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Session value)?  $default,){
final _that = this;
switch (_that) {
case _Session() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String refreshToken, @JsonKey(name: 'expires_in')  int expiresIn, @JsonKey(name: 'is_new_user')  bool isNewUser,  DabbleUser user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresIn,_that.isNewUser,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String refreshToken, @JsonKey(name: 'expires_in')  int expiresIn, @JsonKey(name: 'is_new_user')  bool isNewUser,  DabbleUser user)  $default,) {final _that = this;
switch (_that) {
case _Session():
return $default(_that.accessToken,_that.refreshToken,_that.expiresIn,_that.isNewUser,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String refreshToken, @JsonKey(name: 'expires_in')  int expiresIn, @JsonKey(name: 'is_new_user')  bool isNewUser,  DabbleUser user)?  $default,) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresIn,_that.isNewUser,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Session implements Session {
  const _Session({@JsonKey(name: 'access_token') required this.accessToken, @JsonKey(name: 'refresh_token') required this.refreshToken, @JsonKey(name: 'expires_in') this.expiresIn = 1800, @JsonKey(name: 'is_new_user') this.isNewUser = false, required this.user});
  factory _Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

@override@JsonKey(name: 'access_token') final  String accessToken;
@override@JsonKey(name: 'refresh_token') final  String refreshToken;
@override@JsonKey(name: 'expires_in') final  int expiresIn;
@override@JsonKey(name: 'is_new_user') final  bool isNewUser;
@override final  DabbleUser user;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCopyWith<_Session> get copyWith => __$SessionCopyWithImpl<_Session>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Session&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.isNewUser, isNewUser) || other.isNewUser == isNewUser)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accessToken,refreshToken,expiresIn,isNewUser,user);
}

@override
String toString() {
    return 'Session(accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn, isNewUser: $isNewUser, user: $user)';
}


}

/// @nodoc
abstract mixin class _$SessionCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$SessionCopyWith(_Session value, $Res Function(_Session) _then) = __$SessionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'refresh_token') String refreshToken,@JsonKey(name: 'expires_in') int expiresIn,@JsonKey(name: 'is_new_user') bool isNewUser, DabbleUser user
});


@override $DabbleUserCopyWith<$Res> get user;

}
/// @nodoc
class __$SessionCopyWithImpl<$Res>
    implements _$SessionCopyWith<$Res> {
  __$SessionCopyWithImpl(this._self, this._then);

  final _Session _self;
  final $Res Function(_Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresIn = null,Object? isNewUser = null,Object? user = null,}) {
  return _then(_Session(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as DabbleUser,
  ));
}

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DabbleUserCopyWith<$Res> get user {
  
  return $DabbleUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$PublishResult {

 Submission get submission; Streak get streak;
/// Create a copy of PublishResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublishResultCopyWith<PublishResult> get copyWith => _$PublishResultCopyWithImpl<PublishResult>(this as PublishResult, _$identity);

  /// Serializes this PublishResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PublishResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublishResult&&(identical(other.submission, _this.submission) || other.submission == _this.submission)&&(identical(other.streak, _this.streak) || other.streak == _this.streak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PublishResult;
  return Object.hash(runtimeType,_this.submission,_this.streak);
}

@override
String toString() {
  final _this = this as PublishResult;
  return 'PublishResult(submission: ${_this.submission}, streak: ${_this.streak})';
}


}

/// @nodoc
abstract mixin class $PublishResultCopyWith<$Res>  {
  factory $PublishResultCopyWith(PublishResult value, $Res Function(PublishResult) _then) = _$PublishResultCopyWithImpl;
@useResult
$Res call({
 Submission submission, Streak streak
});


$SubmissionCopyWith<$Res> get submission;$StreakCopyWith<$Res> get streak;

}
/// @nodoc
class _$PublishResultCopyWithImpl<$Res>
    implements $PublishResultCopyWith<$Res> {
  _$PublishResultCopyWithImpl(this._self, this._then);

  final PublishResult _self;
  final $Res Function(PublishResult) _then;

/// Create a copy of PublishResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? submission = null,Object? streak = null,}) {
  return _then(PublishResult(
submission: null == submission ? _self.submission : submission // ignore: cast_nullable_to_non_nullable
as Submission,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as Streak,
  ));
}
/// Create a copy of PublishResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubmissionCopyWith<$Res> get submission {
  
  return $SubmissionCopyWith<$Res>(_self.submission, (value) {
    return _then(_self.copyWith(submission: value));
  });
}/// Create a copy of PublishResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreakCopyWith<$Res> get streak {
  
  return $StreakCopyWith<$Res>(_self.streak, (value) {
    return _then(_self.copyWith(streak: value));
  });
}
}


/// Adds pattern-matching-related methods to [PublishResult].
extension PublishResultPatterns on PublishResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublishResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublishResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublishResult value)  $default,){
final _that = this;
switch (_that) {
case _PublishResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublishResult value)?  $default,){
final _that = this;
switch (_that) {
case _PublishResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Submission submission,  Streak streak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublishResult() when $default != null:
return $default(_that.submission,_that.streak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Submission submission,  Streak streak)  $default,) {final _that = this;
switch (_that) {
case _PublishResult():
return $default(_that.submission,_that.streak);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Submission submission,  Streak streak)?  $default,) {final _that = this;
switch (_that) {
case _PublishResult() when $default != null:
return $default(_that.submission,_that.streak);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublishResult implements PublishResult {
  const _PublishResult({required this.submission, required this.streak});
  factory _PublishResult.fromJson(Map<String, dynamic> json) => _$PublishResultFromJson(json);

@override final  Submission submission;
@override final  Streak streak;

/// Create a copy of PublishResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublishResultCopyWith<_PublishResult> get copyWith => __$PublishResultCopyWithImpl<_PublishResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublishResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublishResult&&(identical(other.submission, submission) || other.submission == submission)&&(identical(other.streak, streak) || other.streak == streak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,submission,streak);
}

@override
String toString() {
    return 'PublishResult(submission: $submission, streak: $streak)';
}


}

/// @nodoc
abstract mixin class _$PublishResultCopyWith<$Res> implements $PublishResultCopyWith<$Res> {
  factory _$PublishResultCopyWith(_PublishResult value, $Res Function(_PublishResult) _then) = __$PublishResultCopyWithImpl;
@override @useResult
$Res call({
 Submission submission, Streak streak
});


@override $SubmissionCopyWith<$Res> get submission;@override $StreakCopyWith<$Res> get streak;

}
/// @nodoc
class __$PublishResultCopyWithImpl<$Res>
    implements _$PublishResultCopyWith<$Res> {
  __$PublishResultCopyWithImpl(this._self, this._then);

  final _PublishResult _self;
  final $Res Function(_PublishResult) _then;

/// Create a copy of PublishResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? submission = null,Object? streak = null,}) {
  return _then(_PublishResult(
submission: null == submission ? _self.submission : submission // ignore: cast_nullable_to_non_nullable
as Submission,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as Streak,
  ));
}

/// Create a copy of PublishResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubmissionCopyWith<$Res> get submission {
  
  return $SubmissionCopyWith<$Res>(_self.submission, (value) {
    return _then(_self.copyWith(submission: value));
  });
}/// Create a copy of PublishResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreakCopyWith<$Res> get streak {
  
  return $StreakCopyWith<$Res>(_self.streak, (value) {
    return _then(_self.copyWith(streak: value));
  });
}
}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'me_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeModel {

 int? get id; String? get firstName; String? get lastName; String? get maidenName; int? get age; String? get gender; String? get email; String? get phone; String? get username; String? get password; String? get birthDate; String? get image; String? get bloodGroup; double? get height; double? get weight; String? get eyeColor; MeHairModel? get hair; String? get ip; MeAddressModel? get address; String? get macAddress; String? get university; MeBankModel? get bank; MeCompanyModel? get company; String? get ein; String? get ssn; String? get userAgent; MeCryptoModel? get crypto; String? get role;
/// Create a copy of MeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeModelCopyWith<MeModel> get copyWith => _$MeModelCopyWithImpl<MeModel>(this as MeModel, _$identity);

  /// Serializes this MeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.maidenName, maidenName) || other.maidenName == maidenName)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.image, image) || other.image == image)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.eyeColor, eyeColor) || other.eyeColor == eyeColor)&&(identical(other.hair, hair) || other.hair == hair)&&(identical(other.ip, ip) || other.ip == ip)&&(identical(other.address, address) || other.address == address)&&(identical(other.macAddress, macAddress) || other.macAddress == macAddress)&&(identical(other.university, university) || other.university == university)&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.company, company) || other.company == company)&&(identical(other.ein, ein) || other.ein == ein)&&(identical(other.ssn, ssn) || other.ssn == ssn)&&(identical(other.userAgent, userAgent) || other.userAgent == userAgent)&&(identical(other.crypto, crypto) || other.crypto == crypto)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,firstName,lastName,maidenName,age,gender,email,phone,username,password,birthDate,image,bloodGroup,height,weight,eyeColor,hair,ip,address,macAddress,university,bank,company,ein,ssn,userAgent,crypto,role]);

@override
String toString() {
  return 'MeModel(id: $id, firstName: $firstName, lastName: $lastName, maidenName: $maidenName, age: $age, gender: $gender, email: $email, phone: $phone, username: $username, password: $password, birthDate: $birthDate, image: $image, bloodGroup: $bloodGroup, height: $height, weight: $weight, eyeColor: $eyeColor, hair: $hair, ip: $ip, address: $address, macAddress: $macAddress, university: $university, bank: $bank, company: $company, ein: $ein, ssn: $ssn, userAgent: $userAgent, crypto: $crypto, role: $role)';
}


}

/// @nodoc
abstract mixin class $MeModelCopyWith<$Res>  {
  factory $MeModelCopyWith(MeModel value, $Res Function(MeModel) _then) = _$MeModelCopyWithImpl;
@useResult
$Res call({
 int? id, String? firstName, String? lastName, String? maidenName, int? age, String? gender, String? email, String? phone, String? username, String? password, String? birthDate, String? image, String? bloodGroup, double? height, double? weight, String? eyeColor, MeHairModel? hair, String? ip, MeAddressModel? address, String? macAddress, String? university, MeBankModel? bank, MeCompanyModel? company, String? ein, String? ssn, String? userAgent, MeCryptoModel? crypto, String? role
});


$MeHairModelCopyWith<$Res>? get hair;$MeAddressModelCopyWith<$Res>? get address;$MeBankModelCopyWith<$Res>? get bank;$MeCompanyModelCopyWith<$Res>? get company;$MeCryptoModelCopyWith<$Res>? get crypto;

}
/// @nodoc
class _$MeModelCopyWithImpl<$Res>
    implements $MeModelCopyWith<$Res> {
  _$MeModelCopyWithImpl(this._self, this._then);

  final MeModel _self;
  final $Res Function(MeModel) _then;

/// Create a copy of MeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? maidenName = freezed,Object? age = freezed,Object? gender = freezed,Object? email = freezed,Object? phone = freezed,Object? username = freezed,Object? password = freezed,Object? birthDate = freezed,Object? image = freezed,Object? bloodGroup = freezed,Object? height = freezed,Object? weight = freezed,Object? eyeColor = freezed,Object? hair = freezed,Object? ip = freezed,Object? address = freezed,Object? macAddress = freezed,Object? university = freezed,Object? bank = freezed,Object? company = freezed,Object? ein = freezed,Object? ssn = freezed,Object? userAgent = freezed,Object? crypto = freezed,Object? role = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,maidenName: freezed == maidenName ? _self.maidenName : maidenName // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,bloodGroup: freezed == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,eyeColor: freezed == eyeColor ? _self.eyeColor : eyeColor // ignore: cast_nullable_to_non_nullable
as String?,hair: freezed == hair ? _self.hair : hair // ignore: cast_nullable_to_non_nullable
as MeHairModel?,ip: freezed == ip ? _self.ip : ip // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as MeAddressModel?,macAddress: freezed == macAddress ? _self.macAddress : macAddress // ignore: cast_nullable_to_non_nullable
as String?,university: freezed == university ? _self.university : university // ignore: cast_nullable_to_non_nullable
as String?,bank: freezed == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as MeBankModel?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as MeCompanyModel?,ein: freezed == ein ? _self.ein : ein // ignore: cast_nullable_to_non_nullable
as String?,ssn: freezed == ssn ? _self.ssn : ssn // ignore: cast_nullable_to_non_nullable
as String?,userAgent: freezed == userAgent ? _self.userAgent : userAgent // ignore: cast_nullable_to_non_nullable
as String?,crypto: freezed == crypto ? _self.crypto : crypto // ignore: cast_nullable_to_non_nullable
as MeCryptoModel?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeHairModelCopyWith<$Res>? get hair {
    if (_self.hair == null) {
    return null;
  }

  return $MeHairModelCopyWith<$Res>(_self.hair!, (value) {
    return _then(_self.copyWith(hair: value));
  });
}/// Create a copy of MeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeAddressModelCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $MeAddressModelCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of MeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeBankModelCopyWith<$Res>? get bank {
    if (_self.bank == null) {
    return null;
  }

  return $MeBankModelCopyWith<$Res>(_self.bank!, (value) {
    return _then(_self.copyWith(bank: value));
  });
}/// Create a copy of MeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeCompanyModelCopyWith<$Res>? get company {
    if (_self.company == null) {
    return null;
  }

  return $MeCompanyModelCopyWith<$Res>(_self.company!, (value) {
    return _then(_self.copyWith(company: value));
  });
}/// Create a copy of MeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeCryptoModelCopyWith<$Res>? get crypto {
    if (_self.crypto == null) {
    return null;
  }

  return $MeCryptoModelCopyWith<$Res>(_self.crypto!, (value) {
    return _then(_self.copyWith(crypto: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeModel].
extension MeModelPatterns on MeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeModel value)  $default,){
final _that = this;
switch (_that) {
case _MeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeModel value)?  $default,){
final _that = this;
switch (_that) {
case _MeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? firstName,  String? lastName,  String? maidenName,  int? age,  String? gender,  String? email,  String? phone,  String? username,  String? password,  String? birthDate,  String? image,  String? bloodGroup,  double? height,  double? weight,  String? eyeColor,  MeHairModel? hair,  String? ip,  MeAddressModel? address,  String? macAddress,  String? university,  MeBankModel? bank,  MeCompanyModel? company,  String? ein,  String? ssn,  String? userAgent,  MeCryptoModel? crypto,  String? role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeModel() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.maidenName,_that.age,_that.gender,_that.email,_that.phone,_that.username,_that.password,_that.birthDate,_that.image,_that.bloodGroup,_that.height,_that.weight,_that.eyeColor,_that.hair,_that.ip,_that.address,_that.macAddress,_that.university,_that.bank,_that.company,_that.ein,_that.ssn,_that.userAgent,_that.crypto,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? firstName,  String? lastName,  String? maidenName,  int? age,  String? gender,  String? email,  String? phone,  String? username,  String? password,  String? birthDate,  String? image,  String? bloodGroup,  double? height,  double? weight,  String? eyeColor,  MeHairModel? hair,  String? ip,  MeAddressModel? address,  String? macAddress,  String? university,  MeBankModel? bank,  MeCompanyModel? company,  String? ein,  String? ssn,  String? userAgent,  MeCryptoModel? crypto,  String? role)  $default,) {final _that = this;
switch (_that) {
case _MeModel():
return $default(_that.id,_that.firstName,_that.lastName,_that.maidenName,_that.age,_that.gender,_that.email,_that.phone,_that.username,_that.password,_that.birthDate,_that.image,_that.bloodGroup,_that.height,_that.weight,_that.eyeColor,_that.hair,_that.ip,_that.address,_that.macAddress,_that.university,_that.bank,_that.company,_that.ein,_that.ssn,_that.userAgent,_that.crypto,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? firstName,  String? lastName,  String? maidenName,  int? age,  String? gender,  String? email,  String? phone,  String? username,  String? password,  String? birthDate,  String? image,  String? bloodGroup,  double? height,  double? weight,  String? eyeColor,  MeHairModel? hair,  String? ip,  MeAddressModel? address,  String? macAddress,  String? university,  MeBankModel? bank,  MeCompanyModel? company,  String? ein,  String? ssn,  String? userAgent,  MeCryptoModel? crypto,  String? role)?  $default,) {final _that = this;
switch (_that) {
case _MeModel() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.maidenName,_that.age,_that.gender,_that.email,_that.phone,_that.username,_that.password,_that.birthDate,_that.image,_that.bloodGroup,_that.height,_that.weight,_that.eyeColor,_that.hair,_that.ip,_that.address,_that.macAddress,_that.university,_that.bank,_that.company,_that.ein,_that.ssn,_that.userAgent,_that.crypto,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeModel extends MeModel {
  const _MeModel({this.id, this.firstName, this.lastName, this.maidenName, this.age, this.gender, this.email, this.phone, this.username, this.password, this.birthDate, this.image, this.bloodGroup, this.height, this.weight, this.eyeColor, this.hair, this.ip, this.address, this.macAddress, this.university, this.bank, this.company, this.ein, this.ssn, this.userAgent, this.crypto, this.role}): super._();
  factory _MeModel.fromJson(Map<String, dynamic> json) => _$MeModelFromJson(json);

@override final  int? id;
@override final  String? firstName;
@override final  String? lastName;
@override final  String? maidenName;
@override final  int? age;
@override final  String? gender;
@override final  String? email;
@override final  String? phone;
@override final  String? username;
@override final  String? password;
@override final  String? birthDate;
@override final  String? image;
@override final  String? bloodGroup;
@override final  double? height;
@override final  double? weight;
@override final  String? eyeColor;
@override final  MeHairModel? hair;
@override final  String? ip;
@override final  MeAddressModel? address;
@override final  String? macAddress;
@override final  String? university;
@override final  MeBankModel? bank;
@override final  MeCompanyModel? company;
@override final  String? ein;
@override final  String? ssn;
@override final  String? userAgent;
@override final  MeCryptoModel? crypto;
@override final  String? role;

/// Create a copy of MeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeModelCopyWith<_MeModel> get copyWith => __$MeModelCopyWithImpl<_MeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.maidenName, maidenName) || other.maidenName == maidenName)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.image, image) || other.image == image)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.eyeColor, eyeColor) || other.eyeColor == eyeColor)&&(identical(other.hair, hair) || other.hair == hair)&&(identical(other.ip, ip) || other.ip == ip)&&(identical(other.address, address) || other.address == address)&&(identical(other.macAddress, macAddress) || other.macAddress == macAddress)&&(identical(other.university, university) || other.university == university)&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.company, company) || other.company == company)&&(identical(other.ein, ein) || other.ein == ein)&&(identical(other.ssn, ssn) || other.ssn == ssn)&&(identical(other.userAgent, userAgent) || other.userAgent == userAgent)&&(identical(other.crypto, crypto) || other.crypto == crypto)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,firstName,lastName,maidenName,age,gender,email,phone,username,password,birthDate,image,bloodGroup,height,weight,eyeColor,hair,ip,address,macAddress,university,bank,company,ein,ssn,userAgent,crypto,role]);

@override
String toString() {
  return 'MeModel(id: $id, firstName: $firstName, lastName: $lastName, maidenName: $maidenName, age: $age, gender: $gender, email: $email, phone: $phone, username: $username, password: $password, birthDate: $birthDate, image: $image, bloodGroup: $bloodGroup, height: $height, weight: $weight, eyeColor: $eyeColor, hair: $hair, ip: $ip, address: $address, macAddress: $macAddress, university: $university, bank: $bank, company: $company, ein: $ein, ssn: $ssn, userAgent: $userAgent, crypto: $crypto, role: $role)';
}


}

/// @nodoc
abstract mixin class _$MeModelCopyWith<$Res> implements $MeModelCopyWith<$Res> {
  factory _$MeModelCopyWith(_MeModel value, $Res Function(_MeModel) _then) = __$MeModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? firstName, String? lastName, String? maidenName, int? age, String? gender, String? email, String? phone, String? username, String? password, String? birthDate, String? image, String? bloodGroup, double? height, double? weight, String? eyeColor, MeHairModel? hair, String? ip, MeAddressModel? address, String? macAddress, String? university, MeBankModel? bank, MeCompanyModel? company, String? ein, String? ssn, String? userAgent, MeCryptoModel? crypto, String? role
});


@override $MeHairModelCopyWith<$Res>? get hair;@override $MeAddressModelCopyWith<$Res>? get address;@override $MeBankModelCopyWith<$Res>? get bank;@override $MeCompanyModelCopyWith<$Res>? get company;@override $MeCryptoModelCopyWith<$Res>? get crypto;

}
/// @nodoc
class __$MeModelCopyWithImpl<$Res>
    implements _$MeModelCopyWith<$Res> {
  __$MeModelCopyWithImpl(this._self, this._then);

  final _MeModel _self;
  final $Res Function(_MeModel) _then;

/// Create a copy of MeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? maidenName = freezed,Object? age = freezed,Object? gender = freezed,Object? email = freezed,Object? phone = freezed,Object? username = freezed,Object? password = freezed,Object? birthDate = freezed,Object? image = freezed,Object? bloodGroup = freezed,Object? height = freezed,Object? weight = freezed,Object? eyeColor = freezed,Object? hair = freezed,Object? ip = freezed,Object? address = freezed,Object? macAddress = freezed,Object? university = freezed,Object? bank = freezed,Object? company = freezed,Object? ein = freezed,Object? ssn = freezed,Object? userAgent = freezed,Object? crypto = freezed,Object? role = freezed,}) {
  return _then(_MeModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,maidenName: freezed == maidenName ? _self.maidenName : maidenName // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,bloodGroup: freezed == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,eyeColor: freezed == eyeColor ? _self.eyeColor : eyeColor // ignore: cast_nullable_to_non_nullable
as String?,hair: freezed == hair ? _self.hair : hair // ignore: cast_nullable_to_non_nullable
as MeHairModel?,ip: freezed == ip ? _self.ip : ip // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as MeAddressModel?,macAddress: freezed == macAddress ? _self.macAddress : macAddress // ignore: cast_nullable_to_non_nullable
as String?,university: freezed == university ? _self.university : university // ignore: cast_nullable_to_non_nullable
as String?,bank: freezed == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as MeBankModel?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as MeCompanyModel?,ein: freezed == ein ? _self.ein : ein // ignore: cast_nullable_to_non_nullable
as String?,ssn: freezed == ssn ? _self.ssn : ssn // ignore: cast_nullable_to_non_nullable
as String?,userAgent: freezed == userAgent ? _self.userAgent : userAgent // ignore: cast_nullable_to_non_nullable
as String?,crypto: freezed == crypto ? _self.crypto : crypto // ignore: cast_nullable_to_non_nullable
as MeCryptoModel?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeHairModelCopyWith<$Res>? get hair {
    if (_self.hair == null) {
    return null;
  }

  return $MeHairModelCopyWith<$Res>(_self.hair!, (value) {
    return _then(_self.copyWith(hair: value));
  });
}/// Create a copy of MeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeAddressModelCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $MeAddressModelCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of MeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeBankModelCopyWith<$Res>? get bank {
    if (_self.bank == null) {
    return null;
  }

  return $MeBankModelCopyWith<$Res>(_self.bank!, (value) {
    return _then(_self.copyWith(bank: value));
  });
}/// Create a copy of MeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeCompanyModelCopyWith<$Res>? get company {
    if (_self.company == null) {
    return null;
  }

  return $MeCompanyModelCopyWith<$Res>(_self.company!, (value) {
    return _then(_self.copyWith(company: value));
  });
}/// Create a copy of MeModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeCryptoModelCopyWith<$Res>? get crypto {
    if (_self.crypto == null) {
    return null;
  }

  return $MeCryptoModelCopyWith<$Res>(_self.crypto!, (value) {
    return _then(_self.copyWith(crypto: value));
  });
}
}


/// @nodoc
mixin _$MeHairModel {

 String? get color; String? get type;
/// Create a copy of MeHairModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeHairModelCopyWith<MeHairModel> get copyWith => _$MeHairModelCopyWithImpl<MeHairModel>(this as MeHairModel, _$identity);

  /// Serializes this MeHairModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeHairModel&&(identical(other.color, color) || other.color == color)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,color,type);

@override
String toString() {
  return 'MeHairModel(color: $color, type: $type)';
}


}

/// @nodoc
abstract mixin class $MeHairModelCopyWith<$Res>  {
  factory $MeHairModelCopyWith(MeHairModel value, $Res Function(MeHairModel) _then) = _$MeHairModelCopyWithImpl;
@useResult
$Res call({
 String? color, String? type
});




}
/// @nodoc
class _$MeHairModelCopyWithImpl<$Res>
    implements $MeHairModelCopyWith<$Res> {
  _$MeHairModelCopyWithImpl(this._self, this._then);

  final MeHairModel _self;
  final $Res Function(MeHairModel) _then;

/// Create a copy of MeHairModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? color = freezed,Object? type = freezed,}) {
  return _then(_self.copyWith(
color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeHairModel].
extension MeHairModelPatterns on MeHairModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeHairModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeHairModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeHairModel value)  $default,){
final _that = this;
switch (_that) {
case _MeHairModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeHairModel value)?  $default,){
final _that = this;
switch (_that) {
case _MeHairModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? color,  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeHairModel() when $default != null:
return $default(_that.color,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? color,  String? type)  $default,) {final _that = this;
switch (_that) {
case _MeHairModel():
return $default(_that.color,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? color,  String? type)?  $default,) {final _that = this;
switch (_that) {
case _MeHairModel() when $default != null:
return $default(_that.color,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeHairModel implements MeHairModel {
  const _MeHairModel({this.color, this.type});
  factory _MeHairModel.fromJson(Map<String, dynamic> json) => _$MeHairModelFromJson(json);

@override final  String? color;
@override final  String? type;

/// Create a copy of MeHairModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeHairModelCopyWith<_MeHairModel> get copyWith => __$MeHairModelCopyWithImpl<_MeHairModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeHairModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeHairModel&&(identical(other.color, color) || other.color == color)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,color,type);

@override
String toString() {
  return 'MeHairModel(color: $color, type: $type)';
}


}

/// @nodoc
abstract mixin class _$MeHairModelCopyWith<$Res> implements $MeHairModelCopyWith<$Res> {
  factory _$MeHairModelCopyWith(_MeHairModel value, $Res Function(_MeHairModel) _then) = __$MeHairModelCopyWithImpl;
@override @useResult
$Res call({
 String? color, String? type
});




}
/// @nodoc
class __$MeHairModelCopyWithImpl<$Res>
    implements _$MeHairModelCopyWith<$Res> {
  __$MeHairModelCopyWithImpl(this._self, this._then);

  final _MeHairModel _self;
  final $Res Function(_MeHairModel) _then;

/// Create a copy of MeHairModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? color = freezed,Object? type = freezed,}) {
  return _then(_MeHairModel(
color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MeAddressModel {

 String? get address; String? get city; String? get state; String? get stateCode; String? get postalCode; MeCoordinatesModel? get coordinates; String? get country;
/// Create a copy of MeAddressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeAddressModelCopyWith<MeAddressModel> get copyWith => _$MeAddressModelCopyWithImpl<MeAddressModel>(this as MeAddressModel, _$identity);

  /// Serializes this MeAddressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeAddressModel&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,address,city,state,stateCode,postalCode,coordinates,country);

@override
String toString() {
  return 'MeAddressModel(address: $address, city: $city, state: $state, stateCode: $stateCode, postalCode: $postalCode, coordinates: $coordinates, country: $country)';
}


}

/// @nodoc
abstract mixin class $MeAddressModelCopyWith<$Res>  {
  factory $MeAddressModelCopyWith(MeAddressModel value, $Res Function(MeAddressModel) _then) = _$MeAddressModelCopyWithImpl;
@useResult
$Res call({
 String? address, String? city, String? state, String? stateCode, String? postalCode, MeCoordinatesModel? coordinates, String? country
});


$MeCoordinatesModelCopyWith<$Res>? get coordinates;

}
/// @nodoc
class _$MeAddressModelCopyWithImpl<$Res>
    implements $MeAddressModelCopyWith<$Res> {
  _$MeAddressModelCopyWithImpl(this._self, this._then);

  final MeAddressModel _self;
  final $Res Function(MeAddressModel) _then;

/// Create a copy of MeAddressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = freezed,Object? city = freezed,Object? state = freezed,Object? stateCode = freezed,Object? postalCode = freezed,Object? coordinates = freezed,Object? country = freezed,}) {
  return _then(_self.copyWith(
address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,stateCode: freezed == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as MeCoordinatesModel?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MeAddressModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeCoordinatesModelCopyWith<$Res>? get coordinates {
    if (_self.coordinates == null) {
    return null;
  }

  return $MeCoordinatesModelCopyWith<$Res>(_self.coordinates!, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeAddressModel].
extension MeAddressModelPatterns on MeAddressModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeAddressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeAddressModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeAddressModel value)  $default,){
final _that = this;
switch (_that) {
case _MeAddressModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeAddressModel value)?  $default,){
final _that = this;
switch (_that) {
case _MeAddressModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? address,  String? city,  String? state,  String? stateCode,  String? postalCode,  MeCoordinatesModel? coordinates,  String? country)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeAddressModel() when $default != null:
return $default(_that.address,_that.city,_that.state,_that.stateCode,_that.postalCode,_that.coordinates,_that.country);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? address,  String? city,  String? state,  String? stateCode,  String? postalCode,  MeCoordinatesModel? coordinates,  String? country)  $default,) {final _that = this;
switch (_that) {
case _MeAddressModel():
return $default(_that.address,_that.city,_that.state,_that.stateCode,_that.postalCode,_that.coordinates,_that.country);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? address,  String? city,  String? state,  String? stateCode,  String? postalCode,  MeCoordinatesModel? coordinates,  String? country)?  $default,) {final _that = this;
switch (_that) {
case _MeAddressModel() when $default != null:
return $default(_that.address,_that.city,_that.state,_that.stateCode,_that.postalCode,_that.coordinates,_that.country);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeAddressModel implements MeAddressModel {
  const _MeAddressModel({this.address, this.city, this.state, this.stateCode, this.postalCode, this.coordinates, this.country});
  factory _MeAddressModel.fromJson(Map<String, dynamic> json) => _$MeAddressModelFromJson(json);

@override final  String? address;
@override final  String? city;
@override final  String? state;
@override final  String? stateCode;
@override final  String? postalCode;
@override final  MeCoordinatesModel? coordinates;
@override final  String? country;

/// Create a copy of MeAddressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeAddressModelCopyWith<_MeAddressModel> get copyWith => __$MeAddressModelCopyWithImpl<_MeAddressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeAddressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeAddressModel&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,address,city,state,stateCode,postalCode,coordinates,country);

@override
String toString() {
  return 'MeAddressModel(address: $address, city: $city, state: $state, stateCode: $stateCode, postalCode: $postalCode, coordinates: $coordinates, country: $country)';
}


}

/// @nodoc
abstract mixin class _$MeAddressModelCopyWith<$Res> implements $MeAddressModelCopyWith<$Res> {
  factory _$MeAddressModelCopyWith(_MeAddressModel value, $Res Function(_MeAddressModel) _then) = __$MeAddressModelCopyWithImpl;
@override @useResult
$Res call({
 String? address, String? city, String? state, String? stateCode, String? postalCode, MeCoordinatesModel? coordinates, String? country
});


@override $MeCoordinatesModelCopyWith<$Res>? get coordinates;

}
/// @nodoc
class __$MeAddressModelCopyWithImpl<$Res>
    implements _$MeAddressModelCopyWith<$Res> {
  __$MeAddressModelCopyWithImpl(this._self, this._then);

  final _MeAddressModel _self;
  final $Res Function(_MeAddressModel) _then;

/// Create a copy of MeAddressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? address = freezed,Object? city = freezed,Object? state = freezed,Object? stateCode = freezed,Object? postalCode = freezed,Object? coordinates = freezed,Object? country = freezed,}) {
  return _then(_MeAddressModel(
address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,stateCode: freezed == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as MeCoordinatesModel?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MeAddressModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeCoordinatesModelCopyWith<$Res>? get coordinates {
    if (_self.coordinates == null) {
    return null;
  }

  return $MeCoordinatesModelCopyWith<$Res>(_self.coordinates!, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}


/// @nodoc
mixin _$MeCoordinatesModel {

 double? get lat; double? get lng;
/// Create a copy of MeCoordinatesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeCoordinatesModelCopyWith<MeCoordinatesModel> get copyWith => _$MeCoordinatesModelCopyWithImpl<MeCoordinatesModel>(this as MeCoordinatesModel, _$identity);

  /// Serializes this MeCoordinatesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeCoordinatesModel&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'MeCoordinatesModel(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class $MeCoordinatesModelCopyWith<$Res>  {
  factory $MeCoordinatesModelCopyWith(MeCoordinatesModel value, $Res Function(MeCoordinatesModel) _then) = _$MeCoordinatesModelCopyWithImpl;
@useResult
$Res call({
 double? lat, double? lng
});




}
/// @nodoc
class _$MeCoordinatesModelCopyWithImpl<$Res>
    implements $MeCoordinatesModelCopyWith<$Res> {
  _$MeCoordinatesModelCopyWithImpl(this._self, this._then);

  final MeCoordinatesModel _self;
  final $Res Function(MeCoordinatesModel) _then;

/// Create a copy of MeCoordinatesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = freezed,Object? lng = freezed,}) {
  return _then(_self.copyWith(
lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeCoordinatesModel].
extension MeCoordinatesModelPatterns on MeCoordinatesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeCoordinatesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeCoordinatesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeCoordinatesModel value)  $default,){
final _that = this;
switch (_that) {
case _MeCoordinatesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeCoordinatesModel value)?  $default,){
final _that = this;
switch (_that) {
case _MeCoordinatesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? lat,  double? lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeCoordinatesModel() when $default != null:
return $default(_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? lat,  double? lng)  $default,) {final _that = this;
switch (_that) {
case _MeCoordinatesModel():
return $default(_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? lat,  double? lng)?  $default,) {final _that = this;
switch (_that) {
case _MeCoordinatesModel() when $default != null:
return $default(_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeCoordinatesModel implements MeCoordinatesModel {
  const _MeCoordinatesModel({this.lat, this.lng});
  factory _MeCoordinatesModel.fromJson(Map<String, dynamic> json) => _$MeCoordinatesModelFromJson(json);

@override final  double? lat;
@override final  double? lng;

/// Create a copy of MeCoordinatesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeCoordinatesModelCopyWith<_MeCoordinatesModel> get copyWith => __$MeCoordinatesModelCopyWithImpl<_MeCoordinatesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeCoordinatesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeCoordinatesModel&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'MeCoordinatesModel(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$MeCoordinatesModelCopyWith<$Res> implements $MeCoordinatesModelCopyWith<$Res> {
  factory _$MeCoordinatesModelCopyWith(_MeCoordinatesModel value, $Res Function(_MeCoordinatesModel) _then) = __$MeCoordinatesModelCopyWithImpl;
@override @useResult
$Res call({
 double? lat, double? lng
});




}
/// @nodoc
class __$MeCoordinatesModelCopyWithImpl<$Res>
    implements _$MeCoordinatesModelCopyWith<$Res> {
  __$MeCoordinatesModelCopyWithImpl(this._self, this._then);

  final _MeCoordinatesModel _self;
  final $Res Function(_MeCoordinatesModel) _then;

/// Create a copy of MeCoordinatesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = freezed,Object? lng = freezed,}) {
  return _then(_MeCoordinatesModel(
lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$MeBankModel {

 String? get cardExpire; String? get cardNumber; String? get cardType; String? get currency; String? get iban;
/// Create a copy of MeBankModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeBankModelCopyWith<MeBankModel> get copyWith => _$MeBankModelCopyWithImpl<MeBankModel>(this as MeBankModel, _$identity);

  /// Serializes this MeBankModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeBankModel&&(identical(other.cardExpire, cardExpire) || other.cardExpire == cardExpire)&&(identical(other.cardNumber, cardNumber) || other.cardNumber == cardNumber)&&(identical(other.cardType, cardType) || other.cardType == cardType)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.iban, iban) || other.iban == iban));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cardExpire,cardNumber,cardType,currency,iban);

@override
String toString() {
  return 'MeBankModel(cardExpire: $cardExpire, cardNumber: $cardNumber, cardType: $cardType, currency: $currency, iban: $iban)';
}


}

/// @nodoc
abstract mixin class $MeBankModelCopyWith<$Res>  {
  factory $MeBankModelCopyWith(MeBankModel value, $Res Function(MeBankModel) _then) = _$MeBankModelCopyWithImpl;
@useResult
$Res call({
 String? cardExpire, String? cardNumber, String? cardType, String? currency, String? iban
});




}
/// @nodoc
class _$MeBankModelCopyWithImpl<$Res>
    implements $MeBankModelCopyWith<$Res> {
  _$MeBankModelCopyWithImpl(this._self, this._then);

  final MeBankModel _self;
  final $Res Function(MeBankModel) _then;

/// Create a copy of MeBankModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cardExpire = freezed,Object? cardNumber = freezed,Object? cardType = freezed,Object? currency = freezed,Object? iban = freezed,}) {
  return _then(_self.copyWith(
cardExpire: freezed == cardExpire ? _self.cardExpire : cardExpire // ignore: cast_nullable_to_non_nullable
as String?,cardNumber: freezed == cardNumber ? _self.cardNumber : cardNumber // ignore: cast_nullable_to_non_nullable
as String?,cardType: freezed == cardType ? _self.cardType : cardType // ignore: cast_nullable_to_non_nullable
as String?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,iban: freezed == iban ? _self.iban : iban // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeBankModel].
extension MeBankModelPatterns on MeBankModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeBankModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeBankModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeBankModel value)  $default,){
final _that = this;
switch (_that) {
case _MeBankModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeBankModel value)?  $default,){
final _that = this;
switch (_that) {
case _MeBankModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? cardExpire,  String? cardNumber,  String? cardType,  String? currency,  String? iban)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeBankModel() when $default != null:
return $default(_that.cardExpire,_that.cardNumber,_that.cardType,_that.currency,_that.iban);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? cardExpire,  String? cardNumber,  String? cardType,  String? currency,  String? iban)  $default,) {final _that = this;
switch (_that) {
case _MeBankModel():
return $default(_that.cardExpire,_that.cardNumber,_that.cardType,_that.currency,_that.iban);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? cardExpire,  String? cardNumber,  String? cardType,  String? currency,  String? iban)?  $default,) {final _that = this;
switch (_that) {
case _MeBankModel() when $default != null:
return $default(_that.cardExpire,_that.cardNumber,_that.cardType,_that.currency,_that.iban);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeBankModel implements MeBankModel {
  const _MeBankModel({this.cardExpire, this.cardNumber, this.cardType, this.currency, this.iban});
  factory _MeBankModel.fromJson(Map<String, dynamic> json) => _$MeBankModelFromJson(json);

@override final  String? cardExpire;
@override final  String? cardNumber;
@override final  String? cardType;
@override final  String? currency;
@override final  String? iban;

/// Create a copy of MeBankModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeBankModelCopyWith<_MeBankModel> get copyWith => __$MeBankModelCopyWithImpl<_MeBankModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeBankModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeBankModel&&(identical(other.cardExpire, cardExpire) || other.cardExpire == cardExpire)&&(identical(other.cardNumber, cardNumber) || other.cardNumber == cardNumber)&&(identical(other.cardType, cardType) || other.cardType == cardType)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.iban, iban) || other.iban == iban));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cardExpire,cardNumber,cardType,currency,iban);

@override
String toString() {
  return 'MeBankModel(cardExpire: $cardExpire, cardNumber: $cardNumber, cardType: $cardType, currency: $currency, iban: $iban)';
}


}

/// @nodoc
abstract mixin class _$MeBankModelCopyWith<$Res> implements $MeBankModelCopyWith<$Res> {
  factory _$MeBankModelCopyWith(_MeBankModel value, $Res Function(_MeBankModel) _then) = __$MeBankModelCopyWithImpl;
@override @useResult
$Res call({
 String? cardExpire, String? cardNumber, String? cardType, String? currency, String? iban
});




}
/// @nodoc
class __$MeBankModelCopyWithImpl<$Res>
    implements _$MeBankModelCopyWith<$Res> {
  __$MeBankModelCopyWithImpl(this._self, this._then);

  final _MeBankModel _self;
  final $Res Function(_MeBankModel) _then;

/// Create a copy of MeBankModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cardExpire = freezed,Object? cardNumber = freezed,Object? cardType = freezed,Object? currency = freezed,Object? iban = freezed,}) {
  return _then(_MeBankModel(
cardExpire: freezed == cardExpire ? _self.cardExpire : cardExpire // ignore: cast_nullable_to_non_nullable
as String?,cardNumber: freezed == cardNumber ? _self.cardNumber : cardNumber // ignore: cast_nullable_to_non_nullable
as String?,cardType: freezed == cardType ? _self.cardType : cardType // ignore: cast_nullable_to_non_nullable
as String?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,iban: freezed == iban ? _self.iban : iban // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MeCompanyModel {

 String? get department; String? get name; String? get title; MeAddressModel? get address;
/// Create a copy of MeCompanyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeCompanyModelCopyWith<MeCompanyModel> get copyWith => _$MeCompanyModelCopyWithImpl<MeCompanyModel>(this as MeCompanyModel, _$identity);

  /// Serializes this MeCompanyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeCompanyModel&&(identical(other.department, department) || other.department == department)&&(identical(other.name, name) || other.name == name)&&(identical(other.title, title) || other.title == title)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,department,name,title,address);

@override
String toString() {
  return 'MeCompanyModel(department: $department, name: $name, title: $title, address: $address)';
}


}

/// @nodoc
abstract mixin class $MeCompanyModelCopyWith<$Res>  {
  factory $MeCompanyModelCopyWith(MeCompanyModel value, $Res Function(MeCompanyModel) _then) = _$MeCompanyModelCopyWithImpl;
@useResult
$Res call({
 String? department, String? name, String? title, MeAddressModel? address
});


$MeAddressModelCopyWith<$Res>? get address;

}
/// @nodoc
class _$MeCompanyModelCopyWithImpl<$Res>
    implements $MeCompanyModelCopyWith<$Res> {
  _$MeCompanyModelCopyWithImpl(this._self, this._then);

  final MeCompanyModel _self;
  final $Res Function(MeCompanyModel) _then;

/// Create a copy of MeCompanyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? department = freezed,Object? name = freezed,Object? title = freezed,Object? address = freezed,}) {
  return _then(_self.copyWith(
department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as MeAddressModel?,
  ));
}
/// Create a copy of MeCompanyModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeAddressModelCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $MeAddressModelCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeCompanyModel].
extension MeCompanyModelPatterns on MeCompanyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeCompanyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeCompanyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeCompanyModel value)  $default,){
final _that = this;
switch (_that) {
case _MeCompanyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeCompanyModel value)?  $default,){
final _that = this;
switch (_that) {
case _MeCompanyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? department,  String? name,  String? title,  MeAddressModel? address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeCompanyModel() when $default != null:
return $default(_that.department,_that.name,_that.title,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? department,  String? name,  String? title,  MeAddressModel? address)  $default,) {final _that = this;
switch (_that) {
case _MeCompanyModel():
return $default(_that.department,_that.name,_that.title,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? department,  String? name,  String? title,  MeAddressModel? address)?  $default,) {final _that = this;
switch (_that) {
case _MeCompanyModel() when $default != null:
return $default(_that.department,_that.name,_that.title,_that.address);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeCompanyModel implements MeCompanyModel {
  const _MeCompanyModel({this.department, this.name, this.title, this.address});
  factory _MeCompanyModel.fromJson(Map<String, dynamic> json) => _$MeCompanyModelFromJson(json);

@override final  String? department;
@override final  String? name;
@override final  String? title;
@override final  MeAddressModel? address;

/// Create a copy of MeCompanyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeCompanyModelCopyWith<_MeCompanyModel> get copyWith => __$MeCompanyModelCopyWithImpl<_MeCompanyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeCompanyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeCompanyModel&&(identical(other.department, department) || other.department == department)&&(identical(other.name, name) || other.name == name)&&(identical(other.title, title) || other.title == title)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,department,name,title,address);

@override
String toString() {
  return 'MeCompanyModel(department: $department, name: $name, title: $title, address: $address)';
}


}

/// @nodoc
abstract mixin class _$MeCompanyModelCopyWith<$Res> implements $MeCompanyModelCopyWith<$Res> {
  factory _$MeCompanyModelCopyWith(_MeCompanyModel value, $Res Function(_MeCompanyModel) _then) = __$MeCompanyModelCopyWithImpl;
@override @useResult
$Res call({
 String? department, String? name, String? title, MeAddressModel? address
});


@override $MeAddressModelCopyWith<$Res>? get address;

}
/// @nodoc
class __$MeCompanyModelCopyWithImpl<$Res>
    implements _$MeCompanyModelCopyWith<$Res> {
  __$MeCompanyModelCopyWithImpl(this._self, this._then);

  final _MeCompanyModel _self;
  final $Res Function(_MeCompanyModel) _then;

/// Create a copy of MeCompanyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? department = freezed,Object? name = freezed,Object? title = freezed,Object? address = freezed,}) {
  return _then(_MeCompanyModel(
department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as MeAddressModel?,
  ));
}

/// Create a copy of MeCompanyModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeAddressModelCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $MeAddressModelCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}


/// @nodoc
mixin _$MeCryptoModel {

 String? get coin; String? get wallet; String? get network;
/// Create a copy of MeCryptoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeCryptoModelCopyWith<MeCryptoModel> get copyWith => _$MeCryptoModelCopyWithImpl<MeCryptoModel>(this as MeCryptoModel, _$identity);

  /// Serializes this MeCryptoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeCryptoModel&&(identical(other.coin, coin) || other.coin == coin)&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.network, network) || other.network == network));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coin,wallet,network);

@override
String toString() {
  return 'MeCryptoModel(coin: $coin, wallet: $wallet, network: $network)';
}


}

/// @nodoc
abstract mixin class $MeCryptoModelCopyWith<$Res>  {
  factory $MeCryptoModelCopyWith(MeCryptoModel value, $Res Function(MeCryptoModel) _then) = _$MeCryptoModelCopyWithImpl;
@useResult
$Res call({
 String? coin, String? wallet, String? network
});




}
/// @nodoc
class _$MeCryptoModelCopyWithImpl<$Res>
    implements $MeCryptoModelCopyWith<$Res> {
  _$MeCryptoModelCopyWithImpl(this._self, this._then);

  final MeCryptoModel _self;
  final $Res Function(MeCryptoModel) _then;

/// Create a copy of MeCryptoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coin = freezed,Object? wallet = freezed,Object? network = freezed,}) {
  return _then(_self.copyWith(
coin: freezed == coin ? _self.coin : coin // ignore: cast_nullable_to_non_nullable
as String?,wallet: freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as String?,network: freezed == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeCryptoModel].
extension MeCryptoModelPatterns on MeCryptoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeCryptoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeCryptoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeCryptoModel value)  $default,){
final _that = this;
switch (_that) {
case _MeCryptoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeCryptoModel value)?  $default,){
final _that = this;
switch (_that) {
case _MeCryptoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? coin,  String? wallet,  String? network)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeCryptoModel() when $default != null:
return $default(_that.coin,_that.wallet,_that.network);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? coin,  String? wallet,  String? network)  $default,) {final _that = this;
switch (_that) {
case _MeCryptoModel():
return $default(_that.coin,_that.wallet,_that.network);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? coin,  String? wallet,  String? network)?  $default,) {final _that = this;
switch (_that) {
case _MeCryptoModel() when $default != null:
return $default(_that.coin,_that.wallet,_that.network);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeCryptoModel implements MeCryptoModel {
  const _MeCryptoModel({this.coin, this.wallet, this.network});
  factory _MeCryptoModel.fromJson(Map<String, dynamic> json) => _$MeCryptoModelFromJson(json);

@override final  String? coin;
@override final  String? wallet;
@override final  String? network;

/// Create a copy of MeCryptoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeCryptoModelCopyWith<_MeCryptoModel> get copyWith => __$MeCryptoModelCopyWithImpl<_MeCryptoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeCryptoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeCryptoModel&&(identical(other.coin, coin) || other.coin == coin)&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.network, network) || other.network == network));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coin,wallet,network);

@override
String toString() {
  return 'MeCryptoModel(coin: $coin, wallet: $wallet, network: $network)';
}


}

/// @nodoc
abstract mixin class _$MeCryptoModelCopyWith<$Res> implements $MeCryptoModelCopyWith<$Res> {
  factory _$MeCryptoModelCopyWith(_MeCryptoModel value, $Res Function(_MeCryptoModel) _then) = __$MeCryptoModelCopyWithImpl;
@override @useResult
$Res call({
 String? coin, String? wallet, String? network
});




}
/// @nodoc
class __$MeCryptoModelCopyWithImpl<$Res>
    implements _$MeCryptoModelCopyWith<$Res> {
  __$MeCryptoModelCopyWithImpl(this._self, this._then);

  final _MeCryptoModel _self;
  final $Res Function(_MeCryptoModel) _then;

/// Create a copy of MeCryptoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coin = freezed,Object? wallet = freezed,Object? network = freezed,}) {
  return _then(_MeCryptoModel(
coin: freezed == coin ? _self.coin : coin // ignore: cast_nullable_to_non_nullable
as String?,wallet: freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as String?,network: freezed == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

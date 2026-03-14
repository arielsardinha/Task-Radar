// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeModel _$MeModelFromJson(Map<String, dynamic> json) => _MeModel(
  id: (json['id'] as num?)?.toInt(),
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  maidenName: json['maidenName'] as String?,
  age: (json['age'] as num?)?.toInt(),
  gender: json['gender'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  username: json['username'] as String?,
  password: json['password'] as String?,
  birthDate: json['birthDate'] as String?,
  image: json['image'] as String?,
  bloodGroup: json['bloodGroup'] as String?,
  height: (json['height'] as num?)?.toDouble(),
  weight: (json['weight'] as num?)?.toDouble(),
  eyeColor: json['eyeColor'] as String?,
  hair: json['hair'] == null
      ? null
      : MeHairModel.fromJson(json['hair'] as Map<String, dynamic>),
  ip: json['ip'] as String?,
  address: json['address'] == null
      ? null
      : MeAddressModel.fromJson(json['address'] as Map<String, dynamic>),
  macAddress: json['macAddress'] as String?,
  university: json['university'] as String?,
  bank: json['bank'] == null
      ? null
      : MeBankModel.fromJson(json['bank'] as Map<String, dynamic>),
  company: json['company'] == null
      ? null
      : MeCompanyModel.fromJson(json['company'] as Map<String, dynamic>),
  ein: json['ein'] as String?,
  ssn: json['ssn'] as String?,
  userAgent: json['userAgent'] as String?,
  crypto: json['crypto'] == null
      ? null
      : MeCryptoModel.fromJson(json['crypto'] as Map<String, dynamic>),
  role: json['role'] as String?,
);

Map<String, dynamic> _$MeModelToJson(_MeModel instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'maidenName': instance.maidenName,
  'age': instance.age,
  'gender': instance.gender,
  'email': instance.email,
  'phone': instance.phone,
  'username': instance.username,
  'password': instance.password,
  'birthDate': instance.birthDate,
  'image': instance.image,
  'bloodGroup': instance.bloodGroup,
  'height': instance.height,
  'weight': instance.weight,
  'eyeColor': instance.eyeColor,
  'hair': instance.hair,
  'ip': instance.ip,
  'address': instance.address,
  'macAddress': instance.macAddress,
  'university': instance.university,
  'bank': instance.bank,
  'company': instance.company,
  'ein': instance.ein,
  'ssn': instance.ssn,
  'userAgent': instance.userAgent,
  'crypto': instance.crypto,
  'role': instance.role,
};

_MeHairModel _$MeHairModelFromJson(Map<String, dynamic> json) => _MeHairModel(
  color: json['color'] as String?,
  type: json['type'] as String?,
);

Map<String, dynamic> _$MeHairModelToJson(_MeHairModel instance) =>
    <String, dynamic>{'color': instance.color, 'type': instance.type};

_MeAddressModel _$MeAddressModelFromJson(Map<String, dynamic> json) =>
    _MeAddressModel(
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      stateCode: json['stateCode'] as String?,
      postalCode: json['postalCode'] as String?,
      coordinates: json['coordinates'] == null
          ? null
          : MeCoordinatesModel.fromJson(
              json['coordinates'] as Map<String, dynamic>,
            ),
      country: json['country'] as String?,
    );

Map<String, dynamic> _$MeAddressModelToJson(_MeAddressModel instance) =>
    <String, dynamic>{
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'stateCode': instance.stateCode,
      'postalCode': instance.postalCode,
      'coordinates': instance.coordinates,
      'country': instance.country,
    };

_MeCoordinatesModel _$MeCoordinatesModelFromJson(Map<String, dynamic> json) =>
    _MeCoordinatesModel(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MeCoordinatesModelToJson(_MeCoordinatesModel instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};

_MeBankModel _$MeBankModelFromJson(Map<String, dynamic> json) => _MeBankModel(
  cardExpire: json['cardExpire'] as String?,
  cardNumber: json['cardNumber'] as String?,
  cardType: json['cardType'] as String?,
  currency: json['currency'] as String?,
  iban: json['iban'] as String?,
);

Map<String, dynamic> _$MeBankModelToJson(_MeBankModel instance) =>
    <String, dynamic>{
      'cardExpire': instance.cardExpire,
      'cardNumber': instance.cardNumber,
      'cardType': instance.cardType,
      'currency': instance.currency,
      'iban': instance.iban,
    };

_MeCompanyModel _$MeCompanyModelFromJson(Map<String, dynamic> json) =>
    _MeCompanyModel(
      department: json['department'] as String?,
      name: json['name'] as String?,
      title: json['title'] as String?,
      address: json['address'] == null
          ? null
          : MeAddressModel.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MeCompanyModelToJson(_MeCompanyModel instance) =>
    <String, dynamic>{
      'department': instance.department,
      'name': instance.name,
      'title': instance.title,
      'address': instance.address,
    };

_MeCryptoModel _$MeCryptoModelFromJson(Map<String, dynamic> json) =>
    _MeCryptoModel(
      coin: json['coin'] as String?,
      wallet: json['wallet'] as String?,
      network: json['network'] as String?,
    );

Map<String, dynamic> _$MeCryptoModelToJson(_MeCryptoModel instance) =>
    <String, dynamic>{
      'coin': instance.coin,
      'wallet': instance.wallet,
      'network': instance.network,
    };

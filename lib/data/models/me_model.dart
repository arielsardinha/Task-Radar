import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_radar/domain/user.dart';
part 'me_model.freezed.dart';
part 'me_model.g.dart';

@freezed
abstract class MeModel with _$MeModel {
  const MeModel._();

  const factory MeModel({
    int? id,
    String? firstName,
    String? lastName,
    String? maidenName,
    int? age,
    String? gender,
    String? email,
    String? phone,
    String? username,
    String? password,
    String? birthDate,
    String? image,
    String? bloodGroup,
    double? height,
    double? weight,
    String? eyeColor,
    MeHairModel? hair,
    String? ip,
    MeAddressModel? address,
    String? macAddress,
    String? university,
    MeBankModel? bank,
    MeCompanyModel? company,
    String? ein,
    String? ssn,
    String? userAgent,
    MeCryptoModel? crypto,
    String? role,
  }) = _MeModel;

  factory MeModel.fromJson(Map<String, dynamic> json) =>
      _$MeModelFromJson(json);

  User toUser() {
    final composedName = [firstName, lastName]
        .whereType<String>()
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .join(' ')
        .trim();

    final normalizedRole = (role ?? '').trim().toLowerCase();

    return User(
      fullName: composedName,
      email: email ?? '',
      phone: phone ?? '',
      company: company?.name ?? '',
      department: company?.department ?? '',
      photo: image ?? '',
      userType: normalizedRole == 'admin' ? UserType.admin : UserType.moderator,
    );
  }
}

@freezed
abstract class MeHairModel with _$MeHairModel {
  const factory MeHairModel({String? color, String? type}) = _MeHairModel;

  factory MeHairModel.fromJson(Map<String, dynamic> json) =>
      _$MeHairModelFromJson(json);
}

@freezed
abstract class MeAddressModel with _$MeAddressModel {
  const factory MeAddressModel({
    String? address,
    String? city,
    String? state,
    String? stateCode,
    String? postalCode,
    MeCoordinatesModel? coordinates,
    String? country,
  }) = _MeAddressModel;

  factory MeAddressModel.fromJson(Map<String, dynamic> json) =>
      _$MeAddressModelFromJson(json);
}

@freezed
abstract class MeCoordinatesModel with _$MeCoordinatesModel {
  const factory MeCoordinatesModel({double? lat, double? lng}) =
      _MeCoordinatesModel;

  factory MeCoordinatesModel.fromJson(Map<String, dynamic> json) =>
      _$MeCoordinatesModelFromJson(json);
}

@freezed
abstract class MeBankModel with _$MeBankModel {
  const factory MeBankModel({
    String? cardExpire,
    String? cardNumber,
    String? cardType,
    String? currency,
    String? iban,
  }) = _MeBankModel;

  factory MeBankModel.fromJson(Map<String, dynamic> json) =>
      _$MeBankModelFromJson(json);
}

@freezed
abstract class MeCompanyModel with _$MeCompanyModel {
  const factory MeCompanyModel({
    String? department,
    String? name,
    String? title,
    MeAddressModel? address,
  }) = _MeCompanyModel;

  factory MeCompanyModel.fromJson(Map<String, dynamic> json) =>
      _$MeCompanyModelFromJson(json);
}

@freezed
abstract class MeCryptoModel with _$MeCryptoModel {
  const factory MeCryptoModel({String? coin, String? wallet, String? network}) =
      _MeCryptoModel;

  factory MeCryptoModel.fromJson(Map<String, dynamic> json) =>
      _$MeCryptoModelFromJson(json);
}

class RefreshTokenModel {
  final String refreshToken;
  final String token;

  RefreshTokenModel({required this.refreshToken, required this.token});

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenModel(
      refreshToken: json['refresh_token'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"refresh_token": refreshToken, "token": token};
  }

  RefreshTokenModel copyWith({String? token, String? refreshToken}) {
    return RefreshTokenModel(
      refreshToken: refreshToken ?? this.refreshToken,
      token: token ?? this.token,
    );
  }
}

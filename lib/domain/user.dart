enum UserType { admin, moderator }

final class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String company;
  final String department;
  final String photo;
  final UserType userType;

  const User({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.company,
    required this.department,
    required this.photo,
    required this.userType,
    required this.id,
  });

  String get initialName {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty) {
      return '';
    }

    final firstInitial = parts.first[0];
    final lastInitial = parts.length > 1 ? parts.last[0] : '';

    return (firstInitial + lastInitial).toUpperCase();
  }

  factory User.fromSqliteRow(Map<String, Object?> row) {
    final rawType = (row['user_type'] as String?)?.trim().toLowerCase() ?? '';
    final userType = rawType == UserType.admin.name
        ? UserType.admin
        : UserType.moderator;

    return User(
      fullName: (row['full_name'] as String?) ?? '',
      email: (row['email'] as String?) ?? '',
      phone: (row['phone'] as String?) ?? '',
      company: (row['company'] as String?) ?? '',
      department: (row['department'] as String?) ?? '',
      photo: (row['photo'] as String?) ?? '',
      userType: userType,
      id: (row['id'] as String?) ?? '',
    );
  }

  factory User.fromDummyJson(Map<String, dynamic> json) {
    final firstName = (json['firstName'] as String?)?.trim() ?? '';
    final lastName = (json['lastName'] as String?)?.trim() ?? '';
    final maiden = (json['maidenName'] as String?)?.trim();

    final roleRaw = (json['role'] as String?)?.trim().toLowerCase() ?? '';
    final userType = roleRaw == UserType.admin.name
        ? UserType.admin
        : UserType.moderator;

    final companyMap = (json['company'] as Map?) ?? const {};
    final companyName = (companyMap['name'] as String?)?.trim() ?? '';
    final department = (companyMap['department'] as String?)?.trim() ?? '';

    return User(
      fullName: [
        firstName,
        (lastName.isNotEmpty ? lastName : (maiden ?? '')),
      ].where((s) => s.isNotEmpty).join(' ').trim(),
      email: (json['email'] as String?)?.trim() ?? '',
      phone: (json['phone'] as String?)?.trim() ?? '',
      company: companyName,
      department: department,
      photo: (json['image'] as String?)?.trim() ?? '',
      userType: userType,
      id: '${json['id'] ?? ''}',
    );
  }

  factory User.fromStorageJson(Map<String, dynamic> json) {
    final roleRaw = (json['userType'] as String?)?.trim().toLowerCase() ?? '';
    final userType = roleRaw == UserType.admin.name
        ? UserType.admin
        : UserType.moderator;

    return User(
      fullName: (json['fullName'] as String?)?.trim() ?? '',
      email: (json['email'] as String?)?.trim() ?? '',
      phone: (json['phone'] as String?)?.trim() ?? '',
      company: (json['company'] as String?)?.trim() ?? '',
      department: (json['department'] as String?)?.trim() ?? '',
      photo: (json['photo'] as String?)?.trim() ?? '',
      userType: userType,
      id: (json['id'] as String?)?.trim() ?? '',
    );
  }

  Map<String, Object?> toSqliteRow() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'company': company,
      'department': department,
      'photo': photo,
      'user_type': userType.name,
      'id': id,
    };
  }

  Map<String, dynamic> toStorageJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'company': company,
      'department': department,
      'photo': photo,
      'userType': userType.name,
      'id': id,
    };
  }
}

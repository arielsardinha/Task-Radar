enum UserType {
  admin,
  moderator;

  static UserType fromRole(String? role) {
    final normalized = role?.trim().toLowerCase();

    switch (normalized) {
      case 'admin':
        return UserType.admin;
      case 'moderator':
        return UserType.moderator;
      default:
        return throw Exception('Unknown user role: $role');
    }
  }
}

final class User {
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
  });
}

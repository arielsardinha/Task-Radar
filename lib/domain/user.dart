enum UserType {
  admin,
  moderator;
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

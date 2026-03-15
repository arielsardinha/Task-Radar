import 'package:task_radar/domain/user.dart';

abstract class ProfileState {
  const ProfileState();
}

final class ProfileStateInitial extends ProfileState {
  const ProfileStateInitial();
}

final class ProfileStateLoading extends ProfileState {
  const ProfileStateLoading();
}

final class ProfileStateFailure extends ProfileState {
  final String message;

  const ProfileStateFailure({required this.message});
}

final class ProfileStateLoggedOut extends ProfileState {
  const ProfileStateLoggedOut();
}

final class ProfileStateSuccess extends ProfileState {
  final ProfileViewData profile;

  const ProfileStateSuccess({required this.profile});
}

final class ProfileViewData {
  final String firstName;
  final String fullName;
  final String email;
  final String phone;
  final String company;
  final String department;
  final String type;
  final String photo;

  const ProfileViewData({
    required this.firstName,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.company,
    required this.department,
    required this.type,
    required this.photo,
  });

  factory ProfileViewData.fromUser(User user) {
    final firstName = user.fullName;
    final fallbackFirstName = _extractFirstName(user.fullName);

    return ProfileViewData(
      firstName: firstName.isNotEmpty ? firstName : fallbackFirstName,
      fullName: _valueOrDash(user.fullName),
      email: _valueOrDash(user.email),
      phone: _valueOrDash(user.phone),
      company: _valueOrDash(user.company),
      department: _valueOrDash(user.department),
      type: switch (user.userType) {
        UserType.admin => 'Admin',
        UserType.moderator => 'Moderador',
      },
      photo: user.photo,
    );
  }

  String get initialLetter {
    final source = firstName.trim().isNotEmpty ? firstName : fullName;
    if (source.trim().isEmpty || source.trim() == '-') {
      return '?';
    }

    return source.trim().substring(0, 1).toUpperCase();
  }

  static String _extractFirstName(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);

    if (parts.isEmpty) {
      return '-';
    }

    return parts.first;
  }

  static String _valueOrDash(String value) {
    final normalized = value.trim();
    return normalized.isEmpty ? '-' : normalized;
  }

  static ProfileViewData skeleton() {
    return const ProfileViewData(
      firstName: "Lorem ipsum dolor sit amet",
      fullName: "Lorem ipsum dolor sit amet",
      email: "Lorem ipsum dolor sit amet",
      phone: "Lorem ipsum dolor sit amet",
      company: "Lorem ipsum dolor sit amet",
      department: "Lorem ipsum dolor sit amet",
      type: "Lorem ipsum dolor sit amet",
      photo: "Lorem ipsum dolor sit amet",
    );
  }

  static ProfileViewData empty() {
    return const ProfileViewData(
      firstName: '-',
      fullName: '-',
      email: '-',
      phone: '-',
      company: '-',
      department: '-',
      type: '-',
      photo: '',
    );
  }
}

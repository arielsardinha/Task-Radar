import 'package:flutter/foundation.dart';
import 'package:task_radar/data/repositories/login_repository.dart';
import 'package:task_radar/domain/user.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required LoginRepository loginRepository})
    : _loginRepository = loginRepository;

  final LoginRepository _loginRepository;

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<User?> authenticate(String username, String password) async {
    if (_isLoading) return null;

    _setLoading(true);
    try {
      return await _loginRepository.login(username, password);
    } catch (_) {
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }
}

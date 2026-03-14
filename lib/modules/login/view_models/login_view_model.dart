import 'package:flutter/foundation.dart';
import 'package:task_radar/data/repositories/login_repository.dart';

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

  Future<bool> authenticate(String username, String password) async {
    if (_isLoading) return false;

    _setLoading(true);
    try {
      await _loginRepository.login(username, password);
      return true;
    } catch (_) {
      notifyListeners();
      return false;
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

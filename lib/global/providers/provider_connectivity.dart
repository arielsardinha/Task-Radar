import 'package:flutter/foundation.dart';

class ProviderConnectivity extends ChangeNotifier {
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  void setOnline(bool isOnline) {
    if (_isOnline == isOnline) {
      return;
    }
    _isOnline = isOnline;
    notifyListeners();
  }
}
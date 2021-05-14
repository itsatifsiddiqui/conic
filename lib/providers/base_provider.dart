import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  bool isLoading = false;

  void setBusy() {
    isLoading = true;
    notifyListeners();
  }

  void setIdle() {
    isLoading = false;
    notifyListeners();
  }
}

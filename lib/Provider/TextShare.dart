import 'package:flutter/material.dart';

class ShareText with ChangeNotifier {
  String value = "";
  String get Value => this.value;

  void Set(String value) {
    this.value = value;;
    notifyListeners();
  }
}
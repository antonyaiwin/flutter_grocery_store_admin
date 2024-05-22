import 'package:flutter/material.dart';

class CustomPageIndicatorController extends ChangeNotifier {
  int selectedIndex = 0;

  setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class OptionProvider with ChangeNotifier {
  String _selectedOption = '';

  String get selectedOption => _selectedOption;

  void setSelectedOption(String option) {
    _selectedOption = option;
    notifyListeners();
  }
}

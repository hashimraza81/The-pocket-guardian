import 'package:flutter/material.dart';

class UserChoiceProvider with ChangeNotifier {
  String _userChoice = 'Track'; // Default value

  String get userChoice => _userChoice;

  void setUserChoice(String choice) {
    _userChoice = choice;
    notifyListeners();
  }
}

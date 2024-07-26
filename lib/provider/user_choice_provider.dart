import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserChoiceProvider with ChangeNotifier {
  String _userChoice = 'Track'; // Default value

  String get userChoice => _userChoice;

  UserChoiceProvider() {
    _loadUserChoice();
  }

  void setUserChoice(String choice) async {
    _userChoice = choice;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userChoice', choice);
  }

  void _loadUserChoice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userChoice = prefs.getString('userChoice') ?? 'Track';
    notifyListeners();
  }
}

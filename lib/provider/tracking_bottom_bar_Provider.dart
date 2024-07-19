import 'package:flutter/material.dart';
import 'package:gentech/routes/routes_names.dart';

class TrackingBottomBarProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeIndex(int index, BuildContext context) {
    _selectedIndex = index;
    notifyListeners();

    switch (index) {
      case 0:
        Navigator.pushNamed(context, RoutesName.hometracking);
        break;
      case 1:
        Navigator.pushNamed(context, RoutesName.notification);
        break;
    }
  }
}

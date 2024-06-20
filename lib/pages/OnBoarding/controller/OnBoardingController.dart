import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OnBoardingController with ChangeNotifier {
  int pageIndex = 0;
  // PageController

  void changePageIndex(int newValue) {
    pageIndex = newValue;
    print(pageIndex);
    notifyListeners();
  }
}

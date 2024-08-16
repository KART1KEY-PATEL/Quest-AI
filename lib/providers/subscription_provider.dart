import 'package:flutter/material.dart';

class SubscriptionProvider with ChangeNotifier {
  String selectedPlan = "basic";
  String currentPlan = "basic";

  void changePlan(String plan) {
    selectedPlan = plan;
    notifyListeners();
  }

  void setCurrentPlan(String plan) {
    currentPlan = plan;
    selectedPlan = plan;
    print("Current Plan: $currentPlan");
    notifyListeners();
  }
}

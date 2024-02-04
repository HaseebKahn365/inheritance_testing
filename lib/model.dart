import 'package:flutter/material.dart';

class Parent extends ChangeNotifier {
  List<Category> categoryList = [];
  List<Activity> activityList = [];

  void addToCategoryList(Category category) {
    categoryList.add(category);
    notifyListeners();
  }

  void addToActivityList(Activity activity) {
    activityList.add(activity);
    notifyListeners();
  }
}

class Category {
  final String cName;
  final bool isCountBased;
  final DateTime cCreatedOn;

  Category({
    required this.cName,
    required this.isCountBased,
    required this.cCreatedOn,
  });
}

class Activity extends Category with ChangeNotifier {
  final String aName;
  final DateTime aCreateOn;
  final Map<DateTime, int> countMap = {};

  Activity({
    required this.aName,
    required this.aCreateOn,
    required String cName,
    required bool isCountBased,
    required DateTime cCreatedOn,
  }) : super(
          cName: cName,
          isCountBased: isCountBased,
          cCreatedOn: cCreatedOn,
        );

  void addToCountMap(int count) {
    countMap[DateTime.now()] = count;
    notifyListeners();
  }
}

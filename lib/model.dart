/*
Switching to inheritance:
This redesign incorporates the concept of inheritance to solve the challenge of UI updating. for the initial version, we will simply  have only the category class from which the activity class will inherit. Then there will be a parent class that will act as a state class for the UI. Following are the components and the data members of the classes. The state management is handled using the Riverpod.
Category:
•	String cName;
•	Bool isCountBased;
•	DateTime cCreatedOn;
Activity:
•	String aName;
•	DateTime aCreateOn;
•	Map<Date, count> CountMap;
•	addToCountMap(int count);
Parent:
•	List<Category> categoryList; 	addToCategoryList(); //with notifyListeners to update the UI.
•	List<Activity> activityList;	addToActivityList(); //with notifyListeners to update the UI.
 //each activity will have a Map<DateTime, int> managed using statefull widget and setState()

 */

//this file contains the model classes for the app

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
  static int childrenCount = 0;
  final String aName;
  final DateTime aCreateOn;
  final Map<DateTime, int> countMap;

  Activity._internal(
    this.aName,
    this.aCreateOn,
    this.countMap,
    String cName,
    bool isCountBased,
    DateTime cCreatedOn,
  ) : super(
          cName: cName,
          isCountBased: isCountBased,
          cCreatedOn: cCreatedOn,
        ) {
    childrenCount++;
  }

  factory Activity({
    required String aName,
    required DateTime aCreateOn,
    required Map<DateTime, int> countMap,
    required String cName,
    required bool isCountBased,
    required DateTime cCreatedOn,
  }) {
    return Activity._internal(
      aName,
      aCreateOn,
      countMap,
      cName,
      isCountBased,
      cCreatedOn,
    );
  }

  void addToCountMap(int count) {
    countMap[DateTime.now()] = count;
    notifyListeners();
  }
}

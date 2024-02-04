// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inheritance_testing/model.dart';

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

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

//creating an instance of the parent class for state
final parent = ChangeNotifierProvider<Parent>((ref) {
  return Parent();
});

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Activity Tracker'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  TextEditingController _categoryNameController = TextEditingController();
  bool _isCountBased = true;

  @override
  Widget build(BuildContext context) {
    final parentState = ref.watch(parent);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Welcome to the Personal Tracker',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: Text('Add a new category'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Category Name',
                                ),
                                controller: _categoryNameController,
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Text('Count Based'),
                                      Radio(
                                        value: true,
                                        groupValue: _isCountBased,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _isCountBased = true;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Time Based'),
                                      Radio(
                                        value: false,
                                        groupValue: _isCountBased,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _isCountBased = false;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                //create category and add it to the list of categories.
                                parentState.addToCategoryList(
                                  Category(
                                    cName: _categoryNameController.text,
                                    isCountBased: _isCountBased,
                                    cCreatedOn: DateTime.now(),
                                  ),
                                );

                                Navigator.of(context).pop();
                              },
                              child: Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: Text('Add a new category'),
            ),

            //using ... operator and cards to display the list of categories
            ...parentState.categoryList.map(
              (category) {
                return Card(
                  child: ListTile(
                    title: Text('${category.cName} (${Activity.childrenCount})'),
                    subtitle: Text(
                      category.isCountBased ? 'Count Based' : 'Time Based',
                    ),
                    onTap: () {
                      //navigate to the activity page with material route by passing the category object
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityPage(category: category),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

//activity page with an elevated button to add a new activity

class ActivityPage extends ConsumerStatefulWidget {
  const ActivityPage({super.key, required this.category});

  final Category category;

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends ConsumerState<ActivityPage> {
  TextEditingController _activityNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final parentState = ref.watch(parent);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Activities for ' + widget.category.cName),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Add a new activity',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Add a new activity'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Activity Name',
                            ),
                            controller: _activityNameController,
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            //create activity and add it to the list of activities.
                            parentState.addToActivityList(
                              Activity(
                                aName: _activityNameController.text,
                                aCreateOn: DateTime.now(),
                                countMap: {},
                                cName: widget.category.cName,
                                isCountBased: widget.category.isCountBased,
                                cCreatedOn: widget.category.cCreatedOn,
                              ),
                            );

                            Navigator.of(context).pop();
                          },
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add a new activity'),
            ),

            //using ... operator and cards to display the list of activities
            ...parentState.activityList.map(
              (activity) {
                return Card(
                  child: ListTile(
                    title: Text(activity.aName.toString() + "  total records = " + activity.countMap.length.toString()),
                    subtitle: Text(
                      activity.isCountBased ? 'Count Based' : 'Time Based',
                    ),
                    onTap: () {
                      //show an alert dialogue box for adding count
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Add count'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Count',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (String value) {
                                      //add the count to the count map of the activity
                                      activity.addToCountMap(int.parse(value));
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

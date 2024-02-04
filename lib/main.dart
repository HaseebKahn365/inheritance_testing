import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

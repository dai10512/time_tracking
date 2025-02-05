import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking/providers/project_provider.dart';
import 'package:time_tracking/providers/task_provder.dart';

import 'providers/time_entry_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.localStorage});
  final LocalStorage localStorage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TimeEntryProvider>(
            create: (context) => TimeEntryProvider(localStorage: localStorage)),
        Provider<ProjectProvider>(
            create: (context) => ProjectProvider(localStorage: localStorage)),
        Provider<TaskProvider>(
            create: (context) => TaskProvider(localStorage: localStorage)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

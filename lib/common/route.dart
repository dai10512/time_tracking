import 'package:flutter/material.dart';

import '../screens/add_time_entry_screen.dart';
import '../screens/home_screen.dart';
import '../screens/manage_project_screen.dart';
import '../screens/manage_task_screen.dart';

class RouteName {
  static const String home = '/';
  static const String addTimeEntry = '/add_time_entry';
  static const String manageProjects = '/manage_projects';
  static const String manageTasks = '/manage_tasks';
}

class RouteManager {
  static final Map<String, WidgetBuilder> routes = {
    RouteName.home: (context) => HomeScreen(),
    RouteName.addTimeEntry: (context) => AddTimeEntryScreen(),
    RouteName.manageProjects: (context) => ProjectManagementScreen(),
    RouteName.manageTasks: (context) => TaskManagementScreen(),
  };
}

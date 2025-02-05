import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../models/Task.dart';

class TaskProvider with ChangeNotifier {
  late final LocalStorage localStorage;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  TaskProvider(this.localStorage) {
    _loadStorage();
  }

  void _loadStorage() {
    final storedData = localStorage.getItem('Tasks') ?? [];
    _tasks = (storedData as List).map((e) => Task.fromJson(e)).toList();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }
}

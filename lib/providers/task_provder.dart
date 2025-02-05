import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../common/storage_key.dart';
import '../models/Task.dart';

class TaskProvider with ChangeNotifier {
  late final LocalStorage localStorage;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  TaskProvider(this.localStorage) {
    _loadStorage();
  }

  void _loadStorage() {
    final storedData = localStorage.getItem(StorageKey.tasks);
    if (storedData != null) {
      final List<dynamic> jsonData = jsonDecode(storedData);
      _tasks = jsonData.map((e) => Task.fromJson(e)).toList();
    }
  }

  void setStorage() {
    localStorage.setItem(
        StorageKey.tasks, jsonEncode(_tasks.map((e) => e.toJson()).toList()));
  }

  void addTask(Task task) {
    _tasks.add(task);
    setStorage();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    setStorage();
    notifyListeners();
  }

  void updateTask(Task task) {
    print('updateTask: ${task.toJson()}');
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      setStorage();
      notifyListeners();
    }
  }

  void deleteAll() {
    _tasks.clear();
    setStorage();
    notifyListeners();
  }
}

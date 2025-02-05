import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../models/Task.dart';
class TaskProvider with ChangeNotifier {
  late final LocalStorage _storage;

  List<Task> _Tasks = [];
  List<Task> get Tasks => _Tasks;

  TaskProvider({required LocalStorage localStorage}) {
    _loadStorage();
  }

  void _loadStorage() {
    final storedData = _storage.getItem('Tasks') ?? [];
    _Tasks = (storedData as List).map((e) => Task.fromJson(e)).toList();
  }

  void addTask(Task Task) {
    _Tasks.add(Task);
    notifyListeners();
  }

  void deleteTask(String id) {
    _Tasks.removeWhere((Task) => Task.id == id);
    notifyListeners();
  }

  void updateTask(Task Task) {
    final index = _Tasks.indexWhere((t) => t.id == Task.id);
    if (index != -1) {
      _Tasks[index] = Task;
      notifyListeners();
    }
  }
}

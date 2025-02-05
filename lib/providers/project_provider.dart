import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../common/storage_key.dart';
import '../models/project.dart';

class ProjectProvider with ChangeNotifier {
  late final LocalStorage localStorage;

  List<Project> _projects = [];
  List<Project> get projects => _projects;

  ProjectProvider(this.localStorage) {
    _loadStorage();
  }

  void _loadStorage() {
    final storedData = localStorage.getItem(StorageKey.projects);
    if (storedData != null) {
      final List<dynamic> jsonData = jsonDecode(storedData);
      _projects = jsonData.map((e) => Project.fromJson(e)).toList();
    }
  }

  void setStorage() {
    localStorage.setItem(StorageKey.projects,
        jsonEncode(_projects.map((e) => e.toJson()).toList()));
  }

  void add(Project project) {
    _projects.add(project);
    setStorage();
    notifyListeners();
  }

  void delete(String id) {
    _projects.removeWhere((project) => project.id == id);
    setStorage();
    notifyListeners();
  }

  void update(Project project) {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      setStorage();
      notifyListeners();
    }
  }

  void deleteAll() {
    _projects.clear();
    setStorage();
    notifyListeners();
  }
}

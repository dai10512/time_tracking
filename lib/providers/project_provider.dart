import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../models/project.dart';

class ProjectProvider with ChangeNotifier {
  late final LocalStorage localStorage;

  List<Project> _projects = [];
  List<Project> get projects => _projects;

  ProjectProvider(this.localStorage) {
    _loadStorage();
  }

  void _loadStorage() {
    final storedData = localStorage.getItem('projects') ?? [];
    _projects = (storedData as List).map((e) => Project.fromJson(e)).toList();
  }

  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }

  void updateProject(Project project) {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      notifyListeners();
    }
  }
}

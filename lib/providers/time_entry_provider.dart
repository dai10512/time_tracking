import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

import '../common/storage_key.dart';
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage localStorage;

  List<TimeEntry> _entries = [];
  List<TimeEntry> get entries => _entries;

  TimeEntryProvider(this.localStorage) {
    _loadStorage();
  }

  void _loadStorage() {
    final jsonString = localStorage.getItem(StorageKey.timeEntries) ?? '[]';
    final storedData = jsonDecode(jsonString) as List;
    _entries = storedData.map((item) => TimeEntry.fromJson(item)).toList();
  }

  void _setStorage() {
    final jsonString = jsonEncode(_entries.map((e) => e.toJson()).toList());
    localStorage.setItem(StorageKey.timeEntries, jsonString);
  }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _setStorage();
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _setStorage();
    notifyListeners();
  }

  void deleteAll() {
    _entries.clear();
    _setStorage();
    notifyListeners();
  }
}

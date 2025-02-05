import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  late final LocalStorage _storage;

  List<TimeEntry> _entries = [];
  List<TimeEntry> get entries => _entries;

  TimeEntryProvider({required LocalStorage localStorage}) {
    _loadStorage();
  }

  void _loadStorage() {
    final storedData = _storage.getItem('timeEntries') ?? [];
    _entries = (storedData as List).map((e) => TimeEntry.fromJson(e)).toList();
  }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}



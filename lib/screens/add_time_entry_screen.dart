import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/time_entry.dart';
import '../providers/project_provider.dart';
import '../providers/task_provder.dart';
import '../providers/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});

  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? projectId;
  String? taskId;
  double? totalTime;
  DateTime? date;
  String? notes;

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Time Entry'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: projectId,
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue != null) {
                      projectId = newValue;
                    }
                  });
                },
                decoration: InputDecoration(labelText: 'Project'),
                items: projectProvider.projects
                    .map<DropdownMenuItem<String>>((project) {
                  return DropdownMenuItem<String>(
                    value: project.id,
                    child: Text(project.name),
                  );
                }).toList()
                  ..add(DropdownMenuItem(
                    value: 'new_project',
                    child: Text('New Project'),
                  )),
              ),
              DropdownButtonFormField<String>(
                value: taskId,
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue != null) {
                      taskId = newValue;
                    }
                  });
                },
                decoration: InputDecoration(labelText: 'Task'),
                items: taskProvider.tasks.map<DropdownMenuItem<String>>((task) {
                  return DropdownMenuItem<String>(
                    value: task.id,
                    child: Text(task.name),
                  );
                }).toList()
                  ..add(DropdownMenuItem(
                    value: 'new_task',
                    child: Text('New Task'),
                  )),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                controller: TextEditingController(
                  text: date != null
                      ? DateFormat('yyyy-MM-dd').format(date!)
                      : '',
                ),
                readOnly: true,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: date ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      date = selectedDate;
                    });
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Total Time (hours)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total time';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => totalTime = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some notes';
                  }
                  return null;
                },
                onSaved: (value) => notes = value!,
              ),
              ElevatedButton(
                onPressed: () {
                  print('onPressed');
                  print('projectId: $projectId');
                  print('taskId: $taskId');
                  print('totalTime: $totalTime');
                  print('date: $date');
                  print('notes: $notes');

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final timeEntry = TimeEntry(
                      id: DateTime.now().toString(),
                      projectId: projectId!,
                      taskId: taskId!,
                      totalTime: totalTime!,
                      date: date!,
                      notes: notes!,
                    );
                    debugPrint('timeEntry:${timeEntry.toString()}');
                    Provider.of<TimeEntryProvider>(context, listen: false)
                        .addTimeEntry(timeEntry);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

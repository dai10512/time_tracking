import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../common/route.dart';
import '../providers/project_provider.dart';
import '../providers/task_provder.dart';
import '../providers/time_entry_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String getCategoryNameById(BuildContext context, String projectId) {
    var category = Provider.of<ProjectProvider>(context, listen: false)
        .projects
        .firstWhere((cat) => cat.id == projectId);
    return category.name;
  }

  String getTaskNameById(BuildContext context, String taskId) {
    var task = Provider.of<TaskProvider>(context, listen: false)
        .tasks
        .firstWhere((task) => task.id == taskId);
    return task.name;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Time Entries'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Time Entries'),
              Tab(text: 'Grouped by Project'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.deepPurple),
                child: Text('Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: Icon(Icons.category, color: Colors.deepPurple),
                title: Text('Manage Projects'),
                onTap: () async {
                  await Navigator.pushNamed(context, RouteName.manageProjects);
                },
              ),
              ListTile(
                leading: Icon(Icons.tag, color: Colors.deepPurple),
                title: Text('Manage Tasks'),
                onTap: () {
                  Navigator.pushNamed(context, RouteName.manageTasks);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.deepPurple),
                title: Text('debug: Delete All Storage'),
                onTap: () {
                  Provider.of<TimeEntryProvider>(context, listen: false)
                      .deleteAll();
                  Provider.of<ProjectProvider>(context, listen: false)
                      .deleteAll();
                  Provider.of<TaskProvider>(context, listen: false).deleteAll();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('All storage deleted'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Consumer<TimeEntryProvider>(
              builder: (context, provider, child) {
                if (provider.entries.isEmpty) {
                  return Center(
                    child: Text('No time entries found'),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: provider.entries.length,
                  itemBuilder: (context, index) {
                    final entry = provider.entries[index];
                    final projectName =
                        getCategoryNameById(context, entry.projectId);
                    return Card(
                      child: ListTile(
                        title:
                            Text(projectName, style: TextStyle(fontSize: 20)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.totalTime} hours',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd').format(entry.date),
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Notes: ${entry.notes}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        onTap: () {
                          // This could open a detailed view or edit screen
                        },
                        trailing: IconButton(
                          onPressed: () {
                            Provider.of<TimeEntryProvider>(context,
                                    listen: false)
                                .deleteTimeEntry(entry.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Time entry deleted'),
                              ),
                            );
                          },
                          icon: Icon(Icons.delete, color: Colors.red, size: 24),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Consumer<TimeEntryProvider>(
              builder: (context, provider, child) {
                if (provider.entries.isEmpty) {
                  return Center(
                    child: Text('No time entries found'),
                  );
                }
                var grouped = groupBy(provider.entries, (e) => e.projectId);
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: grouped.length,
                  itemBuilder: (context, index) {
                    final entries = grouped.values.toList()[index];
                    final projectName =
                        getCategoryNameById(context, entries.first.projectId);
                    return Card(
                      child: ListTile(
                        title: Text('$projectName '),
                        subtitle: ListView.builder(
                          shrinkWrap: true,
                          itemCount: entries.length,
                          itemBuilder: (context, index) {
                            final entry = entries[index];
                            final taskName =
                                getTaskNameById(context, entry.taskId);
                            return Text(
                                '$taskName - ${entry.totalTime} hours (${DateFormat('yyyy-MM-dd').format(entry.date)})');
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteName.addTimeEntry);
          },
          tooltip: 'Add Time Entry',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

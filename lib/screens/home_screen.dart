import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/route.dart';
import '../providers/time_entry_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  itemCount: provider.entries.length,
                  itemBuilder: (context, index) {
                    final entry = provider.entries[index];
                    return ListTile(
                      title:
                          Text('${entry.projectId} - ${entry.totalTime} hours'),
                      subtitle: Text(
                          '${entry.date.toString()} - Notes: ${entry.notes}'),
                      onTap: () {
                        // This could open a detailed view or edit screen
                      },
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
                return ListView.builder(
                  itemCount: provider.entries.length,
                  itemBuilder: (context, index) {
                    final entry = provider.entries[index];
                    return ListTile(
                      title:
                          Text('${entry.projectId} - ${entry.totalTime} hours'),
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

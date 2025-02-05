import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/time_entry_provider.dart';
import 'add_time_entry_screen.dart';

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
                title: Text('Manage Categories'),
                onTap: () {
                  Navigator.pop(context); // This closes the drawer
                  Navigator.pushNamed(context, '/manage_categories');
                },
              ),
              ListTile(
                leading: Icon(Icons.tag, color: Colors.deepPurple),
                title: Text('Manage Tags'),
                onTap: () {
                  Navigator.pop(context); // This closes the drawer
                  Navigator.pushNamed(context, '/manage_tags');
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Consumer<TimeEntryProvider>(
              builder: (context, provider, child) {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AddTimeEntryScreen()),
            );
          },
          tooltip: 'Add Time Entry',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

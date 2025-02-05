import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/project_provider.dart';

class ProjectManagementScreen extends StatelessWidget {
  const ProjectManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Projects'),
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          if (projectProvider.projects.isEmpty) {
            return Center(
              child: Text('No projects found'),
            );
          }
          return ListView.builder(
            itemCount: projectProvider.projects.length,
            itemBuilder: (context, index) {
              final project = projectProvider.projects[index];
              return ListTile(
                title: Text(project.name),
                onTap: () {
                  // Handle project tap
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Project',
        child: Icon(Icons.add),
      ),
    );
  }
}

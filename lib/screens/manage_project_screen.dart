import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';
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
                onTap: () async {
                  final isUpdated = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      String newName = '';
                      return AlertDialog(
                        title: Text('Edit Project'),
                        content: TextField(
                          controller: TextEditingController(text: project.name),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              newName = value;
                            }
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                              onPressed: () {
                                Provider.of<ProjectProvider>(context,
                                        listen: false)
                                    .update(Project(
                                  id: project.id,
                                  name: newName,
                                ));
                                Navigator.pop(context, true);
                              },
                              child: Text('Save')),
                        ],
                      );
                    },
                  );
                  if (isUpdated == true && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Project updated'),
                      ),
                    );
                  }
                },
                trailing: IconButton(
                  onPressed: () {
                    Provider.of<ProjectProvider>(context, listen: false)
                        .delete(project.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Project deleted'),
                      ),
                    );
                  },
                  icon: Icon(Icons.delete),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final projectController = TextEditingController();
              return AlertDialog(
                title: Text('Add Project'),
                content: TextField(
                  controller: projectController,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<ProjectProvider>(context, listen: false)
                          .add(Project(
                        id: DateTime.now().toString(),
                        name: projectController.text,
                      ));
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add Project',
        child: Icon(Icons.add),
      ),
    );
  }
}

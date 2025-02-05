import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking/models/Task.dart';

import '../providers/task_provder.dart';

class TaskManagementScreen extends StatelessWidget {
  const TaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tasks'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.tasks.isEmpty) {
            return Center(
              child: Text('No tasks found'),
            );
          }
          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return ListTile(
                title: Text(task.name),
                onTap: () async {
                  final isUpdated = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      String newName = '';
                      return AlertDialog(
                        title: Text('Edit Task'),
                        content: TextField(
                          controller: TextEditingController(text: task.name),
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
                                Provider.of<TaskProvider>(context,
                                        listen: false)
                                    .updateTask(Task(
                                  id: task.id,
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
                        content: Text('Task updated'),
                      ),
                    );
                  }
                },
                trailing: IconButton(
                  onPressed: () {
                    Provider.of<TaskProvider>(context, listen: false)
                        .deleteTask(task.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task deleted'),
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
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final taskController = TextEditingController();
              return AlertDialog(
                title: Text('Add Task'),
                content: TextField(
                  controller: taskController,
                  decoration: InputDecoration(hintText: 'Task Name'),
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
                      Provider.of<TaskProvider>(context, listen: false).addTask(
                        Task(
                          id: DateTime.now().toString(),
                          name: taskController.text,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Task added'),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:crud_tasks/task_add_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_tasks/tasks_api.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskProvider>(
        create: (_) => TaskProvider(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: taskProvider.tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // subtitle: Text('${task.status} - ${task.priority}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 5),
                          Text('Responsible: ${task.responsible}'),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 5),
                          Text(
                              'Deadline: ${DateFormat('yyyy-MM-dd').format(task.deadline)}'),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.work),
                          const SizedBox(width: 5),
                          Text('${task.status} - ${task.priority}'),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => navigateToEditTask(task.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => taskProvider.deleteTask(task.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => navigateToAddTask(),
      ),
    );
  }

  void navigateToAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage()),
    );
  }
}

void navigateToEditTask(int taskId) {}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  List<dynamic> tasks = [];
  int? workerId;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
  final prefs = await SharedPreferences.getInstance();
  final workerJson = prefs.getString('worker');

  print("workerJson: $workerJson");

  if (workerJson == null) {
    print("No worker data found in SharedPreferences.");
    return;
  }

  final worker = jsonDecode(workerJson);
  workerId = int.parse(worker['id']);

  print("Sending worker ID: $workerId");

  final url = Uri.parse('http://10.0.2.2/wtms_api/get_works.php');

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"worker_id": workerId}),
  );

  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}");

  if (response.statusCode == 200) {
    setState(() {
      tasks = jsonDecode(response.body);
      print("Decoded tasks: $tasks");
    });

    print("Tasks loaded: ${tasks.length}");
  } else {
    print("Failed to fetch tasks.");
  }
}


  void _goToSubmitReport(task) {
    Navigator.pushNamed(
      context,
      "/submit_report",
      arguments: {"task": task, "worker_id": workerId},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Tasks")),
      body: tasks.isEmpty
          ? Center(child: Text("No tasks assigned."))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  child: ListTile(
                    title: Text(task['title']),
                    subtitle: Text("Deadline: ${task['deadline']}"),
                    onTap: () => _goToSubmitReport(task),
                  ),
                );
              },
            ),
    );
  }
}

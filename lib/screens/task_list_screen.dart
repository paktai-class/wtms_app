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
  List<int> submittedTaskIds = [];
  int? workerId;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final workerJson = prefs.getString('worker');

    if (workerJson == null) return;
    final worker = jsonDecode(workerJson);
    workerId = int.parse(worker['id']);

    // Load tasks
    final taskRes = await http.post(
      Uri.parse('http://10.0.2.2/wtms_api/get_works.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"worker_id": workerId}),
    );

    // Load submissions
    final subRes = await http.post(
      Uri.parse("http://10.0.2.2/wtms_api/get_submissions.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"worker_id": workerId}),
    );

    if (taskRes.statusCode == 200 && subRes.statusCode == 200) {
      setState(() {
        tasks = jsonDecode(taskRes.body);
        final submissions = jsonDecode(subRes.body);
        submittedTaskIds = submissions.map<int>((s) => int.parse(s['work_id'])).toList();
      });
    }
  }

  void _handleTaskTap(dynamic task) {
    final workId = int.parse(task['work_id']);
    if (submittedTaskIds.contains(workId)) {
      _showDialog("Already Submitted",
        "You’ve already submitted a report for this task.\nYou can edit it in your submission history.");
    } else {
      Navigator.pushNamed(
        context,
        "/submit_report",
        arguments: {"task": task, "worker_id": workerId},
      );
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        title: Text("My Tasks"),
        backgroundColor: Colors.deepPurple,
      ),
      body: tasks.isEmpty
          ? Center(child: Text("No tasks assigned."))
          : ListView.builder(
              itemCount: tasks.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final task = tasks[index];
                final isSubmitted = submittedTaskIds.contains(int.parse(task['work_id']));
                return Card(
                  color: isSubmitted ? Colors.grey[200] : Colors.white,
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSubmitted ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: Text("Deadline: ${task['deadline']}"),
                    trailing: Icon(
                      isSubmitted ? Icons.check_circle : Icons.arrow_forward,
                      color: isSubmitted ? Colors.green : Colors.deepPurple,
                    ),
                    onTap: () => _handleTaskTap(task),
                  ),
                );
              },
            ),
    );
  }
}
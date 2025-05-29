import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubmitReportScreen extends StatefulWidget {
  const SubmitReportScreen({Key? key}) : super(key: key);

  @override
  SubmitReportScreenState createState() => SubmitReportScreenState();
}

class SubmitReportScreenState extends State<SubmitReportScreen> {
  final TextEditingController _reportController = TextEditingController();
  Map<String, dynamic>? task;
  int? workerId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      task = args['task'];
      workerId = args['worker_id'];
    }
  }

  Future<void> _submitReport() async {
    if (_reportController.text.isEmpty || task == null || workerId == null) return;

    final response = await http.post(
      Uri.parse("http://10.0.2.2/wtms_api/submit_work.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "worker_id": workerId,
        "work_id": task!['work_id'],
        "report": _reportController.text,
      }),
    );

    if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Report submitted successfully")));
      Navigator.pop(context); // Go back to task list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Submission failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Submit Report")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Task: ${task!['title']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Deadline: ${task!['deadline']}"),
            SizedBox(height: 16),
            TextField(
              controller: _reportController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Write your report here...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReport,
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}
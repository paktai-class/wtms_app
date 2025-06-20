import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubmitReportScreen extends StatefulWidget {
  const SubmitReportScreen({Key? key}) : super(key: key);

  @override
  State<SubmitReportScreen> createState() => _SubmitReportScreenState();
}

class _SubmitReportScreenState extends State<SubmitReportScreen> {
  final TextEditingController _reportController = TextEditingController();
  late Map<String, dynamic> task;
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
    final reportText = _reportController.text.trim();
    if (reportText.isEmpty) {
      _showDialog("Warning", "Please enter a report.");
      return;
    }

    final response = await http.post(
      Uri.parse("http://10.0.2.2/wtms_api/submit_work.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "worker_id": workerId,
        "work_id": task['work_id'],
        "report": reportText,
      }),
    );

    final success = response.statusCode == 200 && jsonDecode(response.body)['success'];

    _showDialog(
      success ? "Success" : "Failed",
      success ? "Report submitted successfully." : "Failed to submit report.",
      onClose: () {
        if (success) Navigator.pop(context); // Close screen
      },
    );
  }

  void _showDialog(String title, String message, {VoidCallback? onClose}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
              if (onClose != null) onClose();
            },
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
        title: Text("Submit Report"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: ListTile(
                title: Text(task['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Deadline: ${task['deadline']}"),
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _reportController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: "Enter your report",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.send),
              label: Text("Submit Report"),
              onPressed: _submitReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubmissionHistoryScreen extends StatefulWidget {
  const SubmissionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SubmissionHistoryScreen> createState() => _SubmissionHistoryScreenState();
}

class _SubmissionHistoryScreenState extends State<SubmissionHistoryScreen> {
  List<dynamic> submissions = [];
  int? workerId;

  @override
  void initState() {
    super.initState();
    _loadSubmissions();
  }

  Future<void> _loadSubmissions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('worker');
    if (jsonData == null) return;

    final worker = jsonDecode(jsonData);
    workerId = int.parse(worker['id']);

    final response = await http.post(
      Uri.parse("http://10.0.2.2/wtms_api/get_submissions.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"worker_id": workerId}),
    );

    if (response.statusCode == 200) {
      setState(() {
        submissions = jsonDecode(response.body);
      });
    }
  }

  void _editSubmission(dynamic submission) {
    TextEditingController controller = TextEditingController(text: submission['report']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Report"),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Update your report",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.save),
            label: Text("Save"),
            onPressed: () async {
              final response = await http.post(
                Uri.parse("http://10.0.2.2/wtms_api/edit_submission.php"),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({
                  "submission_id": submission['submission_id'],
                  "report": controller.text,
                }),
              );

              Navigator.pop(context);

              final success = response.statusCode == 200 &&
                  jsonDecode(response.body)['success'];

              _showDialog(
                success ? "Success" : "Failed",
                success ? "Report updated." : "Update failed.",
                onClose: _loadSubmissions,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
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
      appBar: AppBar(title: Text("Submission History"), backgroundColor: Colors.deepPurple),
      body: submissions.isEmpty
          ? Center(child: Text("No submissions yet."))
          : ListView.builder(
              itemCount: submissions.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final sub = submissions[index];
                return Card(
                  color: Colors.white,
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.task, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            sub['title'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text("Report:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(sub['report']),
                        if (sub.containsKey("timestamp"))
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Submitted: ${sub['timestamp']}",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                    onTap: () => _editSubmission(sub),
                  ),
                );
              },
            ),
    );
  }
}
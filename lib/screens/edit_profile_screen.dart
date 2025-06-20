import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();

  int? workerId;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('worker');
    if (jsonData == null) return;

    final worker = jsonDecode(jsonData);
    workerId = int.parse(worker['id']);

    final response = await http.post(
      Uri.parse("http://10.0.2.2/wtms_api/get_profile.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"worker_id": workerId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        final w = data['worker'];
        _name.text = w['full_name'];
        _email.text = w['email'];
        _phone.text = w['phone'];
        _address.text = w['address'];
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await http.post(
      Uri.parse("http://10.0.2.2/wtms_api/update_profile.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "worker_id": workerId,
        "full_name": _name.text,
        "email": _email.text,
        "phone": _phone.text,
        "address": _address.text,
      }),
    );

    final success = response.statusCode == 200 && jsonDecode(response.body)['success'];

    _showDialog(
      success ? "Success" : "Failed",
      success ? "Profile updated!" : "Update failed.",
      onClose: () {
        if (success) Navigator.pop(context);
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
      appBar: AppBar(title: Text("Edit Profile"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(controller: _name, decoration: InputDecoration(labelText: "Full Name")),
                  TextFormField(controller: _email, decoration: InputDecoration(labelText: "Email")),
                  TextFormField(controller: _phone, decoration: InputDecoration(labelText: "Phone")),
                  TextFormField(controller: _address, decoration: InputDecoration(labelText: "Address")),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.save),
                    label: Text("Save Changes"),
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
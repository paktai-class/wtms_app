import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? worker;

  @override
  void initState() {
    super.initState();
    _loadWorkerData();
  }

  void _loadWorkerData() async {
    final prefs = await SharedPreferences.getInstance();
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null) {
      setState(() => worker = args as Map<String, dynamic>);
    } else {
      final saved = prefs.getString('worker');
      if (saved != null) setState(() => worker = jsonDecode(saved));
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    if (worker == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Worker Profile")),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Full Name: ${worker!['full_name']}"),
            Text("Email: ${worker!['email']}"),
            Text("Phone: ${worker!['phone']}"),
            Text("Address: ${worker!['address']}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              child: Text("Logout"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/tasks"),
              child: Text("View My Tasks"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();

  void _register() async {
    bool success = await ApiService.registerWorker(
      _name.text,
      _email.text,
      _password.text,
      _phone.text,
      _address.text,
    );

    if (success) {
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(controller: _name, decoration: InputDecoration(labelText: "Full Name")),
            TextField(controller: _email, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _password, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            TextField(controller: _phone, decoration: InputDecoration(labelText: "Phone")),
            TextField(controller: _address, decoration: InputDecoration(labelText: "Address")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: Text("Register")),
          ],
        ),
      ),
    );
  }
}

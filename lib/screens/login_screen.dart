import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    var response = await ApiService.loginWorker(_emailController.text, _passwordController.text);

    if (response != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('worker', jsonEncode(response['worker']));

      Navigator.pushReplacementNamed(context, "/profile", arguments: response['worker']);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.purple.shade100, Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text("Login", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple)),
              SizedBox(height: 32),
              TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder())),
              SizedBox(height: 16),
              TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder())),
              SizedBox(height: 24),
              ElevatedButton(onPressed: _login, child: Text("Login"), style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50))),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, "/register"),
                child: Text("Don't have an account? Sign up here."),
              )
            ],
          ),
        ),
      ),
    );
  }
}

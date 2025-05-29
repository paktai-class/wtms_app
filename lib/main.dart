import 'package:flutter/material.dart';
import 'package:wtms/screens/submit_report_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/task_list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WTMS',
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: {
        "/login": (context) => LoginScreen(),
        "/register": (context) => RegistrationScreen(),
        "/profile": (context) => ProfileScreen(),
        "/tasks": (context) => TaskListScreen(),
        "/submit_report": (context) => SubmitReportScreen(),
      },
    );
  }
}

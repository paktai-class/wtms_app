# WTMS App - Worker Task Management System

This is a mobile application developed using **Flutter**, with a **PHP & MySQL** backend. It allows workers to register, log in, and view their profile information.

## Features

- Worker registration
- Worker login
- View profile (name, email, phone, address)
- Logout and session handling
- Data stored in MySQL
- Backend written in PHP
- Session saved using SharedPreferences
- Register & login worker accounts
- View assigned tasks
- Submit task reports (1 per task)
- View submission history
- Edit previous reports
- View & update worker profile
- Navigation via BottomNavigationBar

## Technologies Used

- Flutter (Frontend)
- PHP (Backend)
- MySQL (Database)
- SharedPreferences (Session management)
- HTTP package (API calls)

## How to Run

### 1. Backend Setup (XAMPP)
- Start Apache and MySQL in XAMPP
- Import `wtms_db.sql` in phpMyAdmin
- Copy `wtms_api` to `C:\xampp\htdocs`

### 2. Flutter App
- Open `wtms_app` in VS Code
- Make sure `pubspec.yaml` includes `http` and `shared_preferences`
- Run the app on Android Emulator or physical device

> Note: In API file, use `http://10.0.2.2/wtms_api` for emulator and `http://your-ip/wtms_api` for physical device

## YouTube Demo

📺 Watch the demo here: (https://youtu.be/YydSPICrjWw)
🔗 Watch the 2nd phase demo here: (https://youtu.be/qFwuDfw0aK0)
🔗 Watch the FINAL phase demo here: (https://youtu.be/EqHbtsQvqZE)


## Author
MUHAMMAD UMAIR BIN NORAZLAN (297248) – STIWK2114 Lab Assignment 2 – A242

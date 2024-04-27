import 'package:flutter/material.dart';
import 'package:task_tide/screens/tasks_screen.dart'; // Ensure this import path is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo List App', // Updated title to reflect the app's purpose
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch:
              Colors.deepOrange, // Using a swatch for better theme integration
        ).copyWith(
          primary: const Color(0xFF883007),
          secondary: Colors
              .deepOrangeAccent, // Additional color for secondary elements
        ),
        useMaterial3:
            true, // Confirm this setting works well with all your UI components
      ),
      home:
          const TasksScreen(), // Ensure consistency with constant constructors
    );
  }
}

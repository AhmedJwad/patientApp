import 'package:flutter/material.dart';
import 'package:healthcare/screen/login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthCare App',
      home: loginScreen(),
      
    );
  }
}
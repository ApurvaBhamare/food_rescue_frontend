
import 'package:flutter/material.dart';

import 'view/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Rescue',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const RegisterScreen(),
    );
  }
}

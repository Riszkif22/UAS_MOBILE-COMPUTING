import 'package:flutter/material.dart';
import 'welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rilah Marathon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const WelcomePage(),
    );
  }
}
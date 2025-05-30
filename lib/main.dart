import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(UndercoverApp());
}

class UndercoverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "L'Apostat",
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}

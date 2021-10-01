import 'package:flutter/material.dart';
import 'package:zimcon/Ranto/screens/home/home_screen.dart';

class Rantohome extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'House Rentals',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

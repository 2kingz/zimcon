import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zimcon/splash_screen.dart';
import 'package:zimcon/utility/drawer/provider/navigation_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: MaterialApp(
        theme: ThemeData(
            accentColor: Colors.pinkAccent,
            appBarTheme: AppBarTheme(backgroundColor: Colors.pink),
            primaryColor: Colors.pink),
        color: Colors.pink,
        debugShowCheckedModeBanner: true,
        home: SplashScreen(),
      ));
}

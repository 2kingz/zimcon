import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:zimcon/splash_screen.dart';
import 'package:zimcon/utility/drawer/provider/navigation_provider.dart';

void main() {
  configLoading();
  runApp(MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.orangeAccent
    ..backgroundColor = Colors.pink
    ..indicatorColor = Colors.orangeAccent
    ..textColor = Colors.orangeAccent
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
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
        builder: EasyLoading.init(),
      ));
}

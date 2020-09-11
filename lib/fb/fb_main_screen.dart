import 'package:covid_19_app/fb/fb_navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FbMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Facebook App',
      theme: ThemeData(
        primaryColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData.dark(),
      home: FbNavBarScreen(),
    );
  }
}

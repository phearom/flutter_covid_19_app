import 'package:covid_19_app/page/home_page.dart';
import 'package:covid_19_app/page/test_page.dart';
import 'package:covid_19_app/style/style.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COVID-19 App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: StyleHelper.mainColor,
        scaffoldBackgroundColor: Color(0xFF333333),
        //remove color from widget
        // highlightColor: Colors.transparent,
        // splashColor: Colors.transparent,
      ),
      home: HomePage(), //SplashPage(),
      routes: <String, WidgetBuilder>{
        '/HomePage': (BuildContext context) => new HomePage(),
      },
    );
  }
}

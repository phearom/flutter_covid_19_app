import 'package:connectivity/connectivity.dart';
import 'package:covid_19_app/helper/connectivity_service.dart';
import 'package:covid_19_app/page/home_page.dart';
import 'package:covid_19_app/style/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityResult>(
      create: (_) => ConnectivityService().connectionStatusController.stream,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'COVID-19 App',
        theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: StyleHelper.mainColor,
          scaffoldBackgroundColor: Color(0xFF333333),
        ),
        home: HomePage(), //SplashPage(),
        routes: <String, WidgetBuilder>{
          '/HomePage': (BuildContext context) => new HomePage(),
        },
      ),
    );
  }
}

import 'package:covid_19_app/fb/fb_home_screen.dart';
import 'package:covid_19_app/fb/fb_main_screen.dart';
import 'package:covid_19_app/fb/fb_navbar_screen.dart';
import 'package:covid_19_app/navigator/navigator_helper.dart';
import 'package:covid_19_app/page/about_covid_page.dart';
import 'package:covid_19_app/page/all_countries_page.dart';
import 'package:covid_19_app/page/covid_symptom_page.dart';
import 'package:covid_19_app/page/dynamic_form.dart';
import 'package:covid_19_app/page/dynamic_widget.dart';
import 'package:covid_19_app/page/home_page.dart';
import 'package:covid_19_app/page/my_widget.dart';
import 'package:covid_19_app/page/shop/shop_1.dart';
import 'package:covid_19_app/page/shop/shop_2.dart';
import 'package:covid_19_app/page/todo_page.dart';
import 'package:covid_19_app/style/style.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: StyleHelper.mainColor,
        child: ListView(
          //Column
          children: <Widget>[
            Container(
              color: Colors.blue,
              width: double.infinity,
              child: DrawerHeader(
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset('assets/icon/fav.png', width: 70),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'COVID-19 App',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          Divider(
                            color: Colors.transparent,
                          ),
                          Text(
                            "Join together to help the world.",
                            style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.transparent,
            ),
            ListTile(
              leading: Icon(Icons.home, color: StyleHelper.textColor),
              title: Text('Main Data', style: StyleHelper.drawerTitle),
              onTap: () {
                Navigator.pop(context);
                NavigatorHelper.push(context, HomePage());
              },
            ),
            ListTile(
              leading: Icon(Icons.verified_user, color: StyleHelper.textColor),
              title: Text('About COVID-19', style: StyleHelper.drawerTitle),
              onTap: () {
                Navigator.pop(context);
                NavigatorHelper.push(context, AboutCovidPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.sync, color: StyleHelper.textColor),
              title: Text('COVID-19 Symptoms', style: StyleHelper.drawerTitle),
              onTap: () {
                Navigator.pop(context);
                NavigatorHelper.push(context, CovidSymptomPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: StyleHelper.textColor),
              title: Text('What You Need TO DO?', style: StyleHelper.drawerTitle),
              onTap: () {
                Navigator.pop(context);
                NavigatorHelper.push(context, TodoPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.all_inclusive, color: StyleHelper.textColor),
              title: Text('All Countries Data', style: StyleHelper.drawerTitle),
              onTap: () {
                Navigator.pop(context);
                NavigatorHelper.push(context, AllCountriesPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.folder, color: StyleHelper.textColor),
              title: Text('Dynamic Form', style: StyleHelper.drawerTitle),
              onTap: () {
                Navigator.pop(context);
                NavigatorHelper.push(context, DynamicForm());
              },
            ),
            ListTile(
              leading: Icon(Icons.shop, color: StyleHelper.textColor),
              title: Text('S1', style: StyleHelper.drawerTitle),
              onTap: () {
                Navigator.pop(context);
                NavigatorHelper.push(context, Shop1());
              },
            ),
            ListTile(
              leading: Icon(Icons.shop, color: StyleHelper.textColor),
              title: Text('S2', style: StyleHelper.drawerTitle),
              onTap: () {
                Navigator.pop(context);
                NavigatorHelper.push(context, Shop2());
              },
            ),
            ListTile(
              leading: Icon(Icons.shop, color: StyleHelper.textColor),
              title: Text('Facebook', style: StyleHelper.drawerTitle),
              onTap: () {
                Navigator.pop(context);
                NavigatorHelper.push(context, FbMainScreen());
              },
            ),
            // Expanded(
            //   child: Align(
            //     alignment: Alignment.bottomLeft,
            //     child: ListTile(
            //       title: Text(
            //         "Version 1.0.0",
            //         style: TextStyle(color: Colors.white),
            //         textAlign: TextAlign.left,
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

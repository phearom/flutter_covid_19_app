import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:covid_19_app/style/style.dart';
import 'package:covid_19_app/widget/no_network_connection.dart';
import 'package:covid_19_app/widget/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final todos = [
    {"id": 1, "title": "Wash your hand"},
    {"id": 2, "title": "Do not touch your face, mouth, eye without cleaning your hand"},
    {"id": 3, "title": "Reduce go to crowded place"},
    {"id": 4, "title": "Stay at home as much as you can"},
    {"id": 5, "title": "Living clean"},
    {"id": 6, "title": "Eat well cook food"}
  ];
  Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isVisible = false;

  @override
  void initState() {
    this.initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_checkConnectionStatus);
    super.initState();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _checkConnectionStatus(result);
  }

  Future<void> _checkConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      setState(() => _isVisible = true);
    } else {
      setState(() => _isVisible = false);
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("What You Need TO DO?")),
      drawer: DrawerMenu(),
      body: Column(
        children: <Widget>[
          NoNetworkConnection(
            visible: _isVisible,
          ),
          SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                var data = todos[index];
                return Card(
                  margin: EdgeInsets.only(left: 5,right: 5,bottom: 5),
                  color: StyleHelper.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ConstrainedBox(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            data["id"].toString() + " - " + data["title"],
                            style: StyleHelper.text1Title,
                          ),
                        ],
                      ),
                    ),
                    constraints: BoxConstraints(
                      minHeight: 80,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:covid_19_app/style/style.dart';
import 'package:covid_19_app/widget/no_network_connection.dart';
import 'package:covid_19_app/widget/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CovidSymptomPage extends StatefulWidget {
  @override
  _CovidSymptomPageState createState() => _CovidSymptomPageState();
}

class _CovidSymptomPageState extends State<CovidSymptomPage> {
  final data = [
    "Fever",
    "Coughing",
    "Shortness of breath",
    "Fatigue",
    "Chills, sometimes with shaking",
    "Body aches",
    "Headache",
    "Sore throat",
    "Loss of smell or taste",
    "Nausea",
    "Diarrhea"
  ];

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isVisible = false;
  String _message="";

  @override
  void initState() {
    _message="It seems no network connection.";
    initConnectivity();
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
      appBar: AppBar(
        title: Text("Symptoms"),
      ),
      drawer: DrawerMenu(),
      body: Column(
        children: <Widget>[
          NoNetworkConnection(
            message: _message,
            visible: _isVisible,
            onRefreshed: () {
              setState(()=>_message="Loading...");
            },
          ),
          Expanded(
            child: ListView.builder(
              //physics: BouncingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 15, left: 15),
                      child: Text(
                        (index + 1).toString() + ". " + data[index],
                        style: TextStyle(color: StyleHelper.textColor),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

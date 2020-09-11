import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:covid_19_app/api/api_helper.dart';
import 'package:covid_19_app/helper/connectivity_helper.dart';
import 'package:covid_19_app/helper/dialog_helper.dart';
import 'package:covid_19_app/helper/function_helper.dart';
import 'package:covid_19_app/page/my_widget.dart';
import 'package:covid_19_app/style/style.dart';
import 'package:covid_19_app/widget/drawer_menu.dart';
import 'package:covid_19_app/widget/loading_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  var mapData = Map<String, dynamic>();
  var globalData;
  var countriesCount = 0;
  @override
  void initState() {
    //this._connectivitySubscription = _connectivity.onConnectivityChanged.listen(_checkConnectionStatus);
    this._getGlobalData();
    super.initState();
  }

  @override
  void dispose() {
    print('dispose');
    _connectivitySubscription.cancel();
    _timer.cancel();
    super.dispose();
  }

  void _getGlobalData() async {
    _startTimer();
    var data = await ApiHelper.getStringData('https://api.covid19api.com/summary');
    if (!mounted) {
      return;
    }
    if (data != null) {
      setState(() {
        mapData = Map<String, dynamic>.from(json.decode(data));
        globalData = mapData['Global'];
        var countries = mapData['Countries'] as List;
        countriesCount = countries.length;
        _timer.cancel();
        //print(globalData);
      });
    } else {
      setState(() {
        mapData = null;
        globalData = null;
        _timer.cancel();
      });
    }
  }

  Timer _timer;
  int _start = 15;
  void _startTimer() {
    _timer = new Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
          print(_start);
        },
      ),
    );
  }

  var i = 0;
  void _checkConnectionStatus(ConnectivityResult result) async {
    var connectionType = await ConnectivityHelper.updateConnectivityStatus(result);
    setState(() {
      if (connectionType != ConnectivityType.Connected || i > 0) {
        if (connectionType == ConnectivityType.Connected) {
          //_showAlertDialog('Network connected.');
          DialogHelper.showAlert(context, title: "Network", body: "Network connected.");
          _getGlobalData();
        } else {
          //_showAlertDialog('No network connection.');
          DialogHelper.showAlert(context, title: "Network", body: "No network connection.");
        }
        i = i + 1;
      }
    });
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text("Network"),
          content: Text(message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: StyleHelper.textColor,
            ),
            onPressed: () {
              _settingModalBottomSheet(context);
            },
          ),
        ],
      ),
      drawer: DrawerMenu(),
      body: mapData == null || mapData.length == 0
          ? Center(
              // child: Text(
              //   mapData == null ? "An error has occured" : "Loading...",
              //   style: StyleHelper.homeTitle,
              // ),
              child: mapData == null ? Text("An error has occured") : LoadingWidget(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      "World Wide Data",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: _generateCard("Total Cases", "", globalData['TotalConfirmed'], 4000),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: _generateCard("Total Death", "", globalData['TotalDeaths'], 600),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _generateCard("Total Recovered", "", globalData['TotalRecovered'], 0),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: _generateCard("New Confirmed", "", globalData['NewConfirmed'], 0),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _generateCard("New Recovered", "", globalData['NewRecovered'], 0),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: _generateCard("Countries Affected", "", countriesCount, 0),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget _generateCard(String title, String imageUrl, int amount1, int amount2) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: StyleHelper.mainColor,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 120,
      child: Column(
        children: <Widget>[
          Container(
            child: Text(title, style: StyleHelper.homeTitle),
          ),
          SizedBox(height: 20),
          Container(
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset('assets/image/hospital.png', width: 30),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        //amount1.toString().replaceAllMapped(reg, mathFunc),
                        FunctionHelper.toIntWithComma(amount1),
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      if (amount2 > 0) ...[
                        Text(
                          //amount2.toString().replaceAllMapped(reg, mathFunc),
                          FunctionHelper.toIntWithComma(amount2),
                          style: TextStyle(color: Colors.white),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                    title: Text(
                      "Choose Notification",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  new ListTile(
                    leading: new Icon(Icons.note),
                    title: new Text('Recovered'),
                    trailing: Icon(
                      Icons.check_box,
                      color: _recovered ? Colors.blue : Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        if (_recovered == false) {
                          _recovered = true;
                        } else {
                          _recovered = false;
                        }
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.casino),
                    title: Text('New cases'),
                    trailing: Icon(
                      Icons.check_box,
                      color: _newCaseCheck ? Colors.blue : Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        if (_newCaseCheck == false) {
                          _newCaseCheck = true;
                        } else {
                          _newCaseCheck = false;
                        }
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.dashboard),
                    title: Text("New deaths"),
                    trailing: Icon(
                      Icons.check_box,
                      color: _newDeathCheck ? Colors.blue : Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        if (_newDeathCheck == false) {
                          _newDeathCheck = true;
                        } else {
                          _newDeathCheck = false;
                        }
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.data_usage),
                    title: Text("Total data"),
                    trailing: Icon(
                      Icons.check_box,
                      color: _totalCheck ? Colors.blue : Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        if (_totalCheck == false) {
                          _totalCheck = true;
                        } else {
                          _totalCheck = false;
                        }
                      });
                    },
                  ),
                  ListTile(
                    trailing: RaisedButton(
                      color: Colors.blue,
                      child: Text("Save", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(height: 65),
                ],
              ),
            );
          },
        );
      },
    );
  }

  var _totalCheck = true;
  var _newDeathCheck = false;
  var _newCaseCheck = false;
  var _recovered = true;
}

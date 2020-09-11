import 'dart:async';

import 'package:covid_19_app/api/api_helper.dart';
import 'package:covid_19_app/helper/function_helper.dart';
import 'package:covid_19_app/style/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CountryDetailPage extends StatefulWidget {
  final String countrySlug;
  final String countryName;
  final int newConfirmed;
  final int todayDeaths;
  final int totalRecovered;
  final int totalDeaths;

  const CountryDetailPage(
      {Key key, this.countrySlug, this.countryName, this.newConfirmed, this.todayDeaths, this.totalRecovered, this.totalDeaths})
      : super(key: key);

  @override
  _CountryDetailPageState createState() => _CountryDetailPageState();
}

class _CountryDetailPageState extends State<CountryDetailPage> {
  final dateFormat = new DateFormat('dd-MMM-yyyy');
  var countryDetails = [];

  @override
  void initState() {
    this._getCountryData();
    super.initState();
  }

  void _getCountryData() async {
    startTimer();
    var apiUrl = 'https://api.covid19api.com/total/country/${widget.countrySlug}';
    var data = await ApiHelper.getListData(apiUrl);
    //print(data);
    if (!this.mounted) {
      return;
    }
    setState(() {
      if (data != null) {
        countryDetails = data..sort((a, b) => b['Date'].compareTo(a['Date']));
      } else {
        countryDetails = null;
      }
    });
  }

  Timer _timer;
  int _start = 15;
  void startTimer() {
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.countryName),
      ),
      body: Column(
        children: <Widget>[
          Container(
            //height: 200,
            width: double.infinity,
            color: StyleHelper.mainColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    ClipOval(
                      child: Image.network(
                        'http://cdn.countryflags.com/thumbs/${widget.countrySlug}/flag-square-250.png',
                        width: 100,
                      ),
                    ),
                    //Text(widget.countryName, style: StyleHelper.homeTitle),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(child: _generateHeader("New Confirmed", widget.newConfirmed)),
                        VerticalDivider(color: Colors.transparent, width: 10),
                        Expanded(child: _generateHeader("Today Deaths", widget.todayDeaths))
                      ],
                    ),  
                    Divider(color: Colors.transparent, height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(child: _generateHeader("Total Recovered", widget.totalRecovered)),
                        VerticalDivider(color: Colors.transparent, width: 10),
                        Expanded(child: _generateHeader("Total Deaths", widget.totalDeaths))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: countryDetails == null || countryDetails.length == 0
                ? Center(
                    child: Text(
                      countryDetails == null ? "An error has occured!!" : _start == 0 ? "No data found." : "Loading...",
                      style: StyleHelper.homeTitle,
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: countryDetails.length,
                    itemBuilder: (context, index) {
                      _timer.cancel();
                      var detail = countryDetails[index];
                      var date = DateTime.parse(detail['Date'].toString());
                      return Container(
                        child: Card(
                          color: StyleHelper.mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                Text('Date : ' + dateFormat.format(date), style: StyleHelper.drawerTitle),
                                Divider(color: Colors.transparent),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text("Confirmed", style: TextStyle(color: StyleHelper.textColor)),
                                          Divider(color: Colors.transparent),
                                          Text(
                                            detail['Confirmed'] == null ? "0" : FunctionHelper.toIntWithComma(detail['Confirmed']),
                                            style: TextStyle(color: StyleHelper.textColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text("Deaths", style: TextStyle(color: StyleHelper.textColor)),
                                          Divider(color: Colors.transparent),
                                          Text(
                                            detail['Deaths'] == null ? "0" : FunctionHelper.toIntWithComma(detail['Deaths']),
                                            style: TextStyle(color: StyleHelper.textColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text("Recovered", style: TextStyle(color: StyleHelper.textColor)),
                                          Divider(color: Colors.transparent),
                                          Text(
                                            detail['Recovered'] == null ? "0" : FunctionHelper.toIntWithComma(detail['Recovered']),
                                            style: TextStyle(color: StyleHelper.textColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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

  Widget _generateHeader(String title, int amount) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey,
      ),
      child: Column(
        children: <Widget>[
          Text(title, style: TextStyle(color: StyleHelper.textColor)),
          Divider(color: Colors.transparent, height: 10),
          Text(
            amount == null ? "0" : FunctionHelper.toIntWithComma(amount),
            style: TextStyle(color: StyleHelper.textColor),
          ),
        ],
      ),
    );
  }
}

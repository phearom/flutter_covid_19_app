import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:covid_19_app/api/api_helper.dart';
import 'package:covid_19_app/helper/function_helper.dart';
import 'package:covid_19_app/navigator/navigator_helper.dart';
import 'package:covid_19_app/page/country_detail_page.dart';
import 'package:covid_19_app/style/style.dart';
import 'package:covid_19_app/widget/loading_widget.dart';
import 'package:covid_19_app/widget/no_network_connection.dart';
import 'package:covid_19_app/widget/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class AllCountriesPage extends StatefulWidget {
  @override
  _AllCountriesPageState createState() => _AllCountriesPageState();
}

class _AllCountriesPageState extends State<AllCountriesPage> with AutomaticKeepAliveClientMixin {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isNotConnected = true;

  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<dynamic>> key = new GlobalKey();
  var countriesDataOrigin = [];
  var countriesData = [];
  List<String> favouriteList = [];
  bool isSearching = false;

  @override
  void initState() {
    this.initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_checkConnectionStatus);
    this._getCountriesFavourite();
    this._getCountriesData();
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
      setState(() => _isNotConnected = true);
    } else {
      setState(() => _isNotConnected = false);
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

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _timer.cancel();
    super.dispose();
  }

  void _getCountriesFavourite() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getStringList("fav") ?? null;
    //print(data);
    if (data != null) {
      favouriteList = data;
      print(favouriteList);
    }
  }

  void _getCountriesData() async {
    _startTimer();
    var data = await ApiHelper.getStringData('https://api.covid19api.com/summary');
    if (!mounted) {
      return;
    }
    if (data != null) {
      setState(() {
        var mapData = Map<String, dynamic>.from(json.decode(data));
        countriesData = mapData['Countries'] as List;
        countriesDataOrigin = countriesData;
        _timer.cancel();
      });
    } else {
      setState(() {
        countriesData = null;
        _timer.cancel();
      });
    }
  }

  String currentSelect = "0";
  void _onSortChange(String choice) {
    if (currentSelect == choice) {
      return;
    }
    if (!this.mounted) {
      return;
    }
    setState(() {
      if (choice == "1") {
        countriesData = countriesDataOrigin..sort((a, b) => b['NewConfirmed'].compareTo(a['NewConfirmed']));
      } else if (choice == "2") {
        countriesData = countriesDataOrigin..sort((a, b) => a['NewConfirmed'].compareTo(b['NewConfirmed']));
      } else if (choice == "3") {
        countriesData = countriesDataOrigin..sort((a, b) => b['TotalDeaths'].compareTo(a['TotalDeaths']));
      } else if (choice == "4") {
        countriesData = countriesDataOrigin..sort((a, b) => a['TotalDeaths'].compareTo(b['TotalDeaths']));
      } else if (choice == "5") {
        countriesData = countriesDataOrigin..sort((a, b) => a['Country'].compareTo(b['Country']));
      } else if (choice == "6") {
        countriesData = countriesDataOrigin..sort((a, b) => b['Country'].compareTo(a['Country']));
      }
      currentSelect = choice;
    });
  }

  bool _isFav = false;
  void _getSortByFavourite() async {
    setState(() {
      countriesData = countriesDataOrigin.where((a) => favouriteList.contains(a["Slug"])).toList();
      if (countriesData.length == 0) {
        _start = 0;
        _isFav = true;
      }
    });
  }

  var popupMenu = [
    {'id': 1, 'name': 'New Cases : high to low'},
    {'id': 2, 'name': 'New Cases : low to high'},
    {'id': 3, 'name': 'Deaths : high to low'},
    {'id': 4, 'name': 'Deaths : low to high'},
    {'id': 5, 'name': 'Countries : A to Z'},
    {'id': 6, 'name': 'Countries : Z to A'},
  ];

  void _onClickFavourite(String slug) async {
    var message = "";
    setState(() {
      if (favouriteList.where((c) => c.contains(slug)).length > 0) {
        favouriteList.remove(slug);
        message = "Removed from favourite";
      } else {
        favouriteList.add(slug);
        message = "Added to favourite";
      }
    });
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList("fav", favouriteList);
    Fluttertoast.showToast(msg: message, gravity: ToastGravity.CENTER);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("All Countries Data"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              _getSortByFavourite();
            },
          ),
          PopupMenuButton<String>(
            offset: Offset(0, 100),
            color: StyleHelper.mainColor,
            icon: Icon(Icons.sort),
            onSelected: _onSortChange,
            itemBuilder: (BuildContext context) {
              return popupMenu.map((map) {
                return PopupMenuItem<String>(
                  value: map['id'].toString(),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.sort, color: StyleHelper.textColor),
                      SizedBox(width: 10),
                      Text(map['name'], style: TextStyle(color: StyleHelper.textColor))
                    ],
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      drawer: DrawerMenu(),
      body: _generateBody(),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _generateBody() {
    if (countriesData == null) {
      return _loadMessage("An error has occured.");
    } else if (countriesData.length == 0) {
      if (_start == 0) {
        if (_isFav) {
          return _loadMessage("No favourite found.");
        } else {
          return _loadMessage("No data found.");
        }
      } else {
        return _loadMessage("Loading...");
      }
    } else {
      return Column(
        children: <Widget>[
          NoNetworkConnection(
            visible: _isNotConnected,
            onRefreshed: () {},
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            height: 50,
            child: searchTextField = _getAutoComplete(),
          ),
          SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                return _onRefreshData();
                // Completer<Null> completer = new Completer<Null>();
                // Timer timer = new Timer(new Duration(seconds: 3), () {
                //   completer.complete();
                // });
                // return completer.future;
              },
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: countriesData.length,
                itemBuilder: (context, index) {
                  var mxData = countriesData[index];
                  var slug = mxData['Slug'];
                  if (slug == null) {
                    slug = 'na';
                  }
                  return GestureDetector(
                    onTap: () {
                      NavigatorHelper.push(
                        context,
                        CountryDetailPage(
                          countrySlug: mxData['Slug'],
                          countryName: mxData['Country'],
                          newConfirmed: mxData['NewConfirmed'],
                          todayDeaths: mxData['NewDeaths'],
                          totalRecovered: mxData['TotalRecovered'],
                          totalDeaths: mxData['TotalDeaths'],
                        ),
                      );
                    },
                    onLongPress: () {
                      //_onClickFavourite(mxData['Slug']);
                      // var message = "";
                      // setState(() {
                      //   if (favouriteList.where((c) => c.contains(mxData['Slug'])).length > 0) {
                      //     favouriteList.remove(mxData["Slug"]);
                      //     message = "Removed from favourite";
                      //   } else {
                      //     favouriteList.add(mxData["Slug"]);
                      //     message = "Added to favourite";
                      //   }
                      // });
                      // var prefs = await SharedPreferences.getInstance();
                      // prefs.setStringList("fav", favouriteList);
                      // Fluttertoast.showToast(msg: message, gravity: ToastGravity.CENTER);
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Card(
                            color: StyleHelper.mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: ClipOval(
                                      //child: Image.asset('assets/image/hospital.png'),
                                      child: Image.network('http://cdn.countryflags.com/thumbs/$slug/flag-square-250.png'),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(
                                                mxData['Country'],
                                                style: StyleHelper.drawerTitle,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // Icon(
                                            //   Icons.favorite,
                                            //   color: favouriteList.where((c) => c.contains(mxData['Slug'])).length > 0
                                            //       ? Colors.red
                                            //       : Colors.white,
                                            // ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Total Cases : " + FunctionHelper.toIntWithComma(mxData['TotalConfirmed']),
                                          style: StyleHelper.homeTitle,
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: _generateCase('New Cases', mxData['NewConfirmed'], Colors.green),
                                            ),
                                            Expanded(child: _generateCase('Today Deaths', mxData['NewDeaths'], Colors.red[200])),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(child: _generateCase('Total Recovered', mxData['TotalRecovered'], Colors.blue)),
                                            Expanded(child: _generateCase('Total Deaths', mxData['TotalDeaths'], Colors.red)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () {
                              _onClickFavourite(mxData['Slug']);
                            },
                            icon: Icon(Icons.favorite),
                            color: favouriteList.where((c) => c.contains(mxData['Slug'])).length > 0 ? Colors.red : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    }
  }

  Future<Null> _onRefreshData() async {
    Completer<Null> completer = new Completer<Null>();
    Timer(new Duration(seconds: 3), () {
      completer.complete();
      Fluttertoast.showToast(msg: "Loaded successfully.");
    });
    return completer.future;
  }

  Widget _loadMessage(String message) {
    return Center(
      child: LoadingWidget(loadingText: message), //Text(message, style: StyleHelper.drawerTitle),
    );
  }

  Widget _generateCase(String title, int amount, Color barColor) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: barColor,
            ),
          ),
        ),
        VerticalDivider(width: 10),
        Expanded(
          flex: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$title', style: TextStyle(color: StyleHelper.textColor)),
              SizedBox(height: 10),
              Text('${FunctionHelper.toIntWithComma(amount)}', style: TextStyle(color: StyleHelper.textColor)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getAutoComplete() {
    return AutoCompleteTextField<dynamic>(
      textChanged: (v) {
        setState(() {
          if (v.length == 0) {
            countriesData = countriesDataOrigin;
          }
        });
      },
      key: key,
      clearOnSubmit: false,
      suggestions: countriesDataOrigin,
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      decoration: _inputDecoration,
      itemFilter: (item, query) {
        setState(() {
          isSearching = true;
        });
        print('x1 ' + isSearching.toString());

        return item['Country'].toLowerCase().startsWith(query.toLowerCase());
      },
      itemSorter: (a, b) {
        print('x2');
        return a['Country'].compareTo(b['Country']);
      },
      itemSubmitted: (item) {
        setState(() {
          searchTextField.textField.controller.text = item['Country'];
          countriesData = countriesDataOrigin.where((a) => a['Country'].toString().contains(item['Country'].toString())).toList();
          print(countriesData);
        });
      },
      itemBuilder: (context, item) {
        print('x3');
        return _searchHint(item);
      },
    );
  }

  Widget _searchHint(dynamic country) {
    return Container(
      color: StyleHelper.mainColor,
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              country['Country'],
              style: TextStyle(fontSize: 16.0, color: StyleHelper.textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 10.0),
          Flexible(
            child: Text(
              country['Country'],
              style: TextStyle(color: StyleHelper.textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration get _inputDecoration => InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: StyleHelper.greyColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: StyleHelper.greyColor, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: StyleHelper.greyColor, width: 1.0),
        ),
        labelText: "Search",
        labelStyle: TextStyle(color: Colors.white),
        // suffixIcon: isSearching == false
        //     ? Icon(Icons.search, color: StyleHelper.textColor)
        //     : IconButton(
        //         icon: Icon(
        //           Icons.close,
        //           color: StyleHelper.textColor,
        //         ),
        //         onPressed: () {
        //           setState(() {
        //             isSearching = false;
        //           });
        //           print('ds ' + isSearching.toString());
        //         },
        //       ),
      );
}

import 'package:connectivity/connectivity.dart';
import 'package:covid_19_app/helper/connectivity_helper.dart';
import 'package:covid_19_app/navigator/navigator_helper.dart';
import 'package:covid_19_app/style/style.dart';
import 'package:covid_19_app/widget/shimmer_loading.dart';
import 'package:covid_19_app/widget/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:covid_19_app/page/test_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AboutCovidPage extends StatefulWidget {
  @override
  _AboutCovidPageState createState() => _AboutCovidPageState();
}

class _AboutCovidPageState extends State<AboutCovidPage> {
  @override
  void initState() {
    super.initState();
  }

  var previous;
  ConnectivityType ctype = ConnectivityType.Unknown;
  void checkConnectivity3() {
    var i = 0;

    var connectivityResult = Provider.of<ConnectivityResult>(context);
    var conn = ConnectivityHelper.getConnectivityType(connectivityResult);
    //print(previous);
    if (conn == ctype) {
      print('hello ');
      return;
    }
    print('ctype-' + ctype.toString());
    print('conn-' + conn.toString());
    ctype = conn;
    setState(() {
      i = i + 1;
      previous = conn;
      var bb = 'pp :: ' + conn.toString();
      print(i.toString() + "-" + bb + "-" + DateTime.now().toString());
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

  final _filter = new TextEditingController();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('About COVID-19');

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          autofocus: true,
          controller: _filter,
          decoration: new InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          style: TextStyle(color: Colors.white),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('About COVID-19');
        //filteredNames = names;
        _filter.clear();
      }
    });
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: _appBarTitle,
      actions: <Widget>[
        IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //checkConnectivity3();
    var bodyHeight = MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    var shimmerCount = bodyHeight / 110;
    var cc = shimmerCount.toInt();
    return Scaffold(
      appBar: _buildBar(context),
      drawer: DrawerMenu(),
      // body: FlatButton(
      //   child: Center(
      //     child: Text(
      //       "Under Construction!",
      //       style: StyleHelper.drawerTitle,
      //     ),
      //   ),
      //   onPressed: () {
      //     //NavigatorHelper.push(context, TestPage());
      //   },
      // ),
      // body: ShimmerLoading(
      //   height: double.infinity,
      //   width: double.infinity,
      // ),
      body: Container(
        margin: EdgeInsets.only(top:10),
        child: Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.blue,
          child: Container(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: shimmerCount.toInt(),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                      ),
                      VerticalDivider(
                        width: 20,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 80 / 3,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey,
                            ),
                            Divider(height: 10),
                            Container(
                              height: 80 / 3,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey,
                            ),
                            Divider(height: 10),
                            Container(
                              height: 80 / 3,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:covid_19_app/navigator/navigator_helper.dart';
import 'package:covid_19_app/page/dynamic_widget.dart';
import 'package:covid_19_app/style/style.dart';
import 'package:covid_19_app/widget/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DynamicForm extends StatefulWidget {
  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  var formItems = [
    {"id": 1, "name": "Courses"},
    {"id": 2, "name": "Students"},
    {"id": 3, "name": "Scores"},
    {"id": 4, "name": "Manage Classes"},
    {"id": 5, "name": "Join Events"},
    {"id": 6, "name": "Bookings"},
    {"id": 7, "name": "Add Skills"}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dynamic Form"),
      ),
      drawer: DrawerMenu(),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.all(25),
              child: Text(
                "Available Forms",
                style: StyleHelper.drawerTitle,
              ),
            ),
            Container(
              // decoration: BoxDecoration(
              //   border: Border(
              //     bottom: BorderSide(
              //       width: 1,
              //       color: Colors.red,
              //     ),
              //   ),
              // ),
              child: TabBar(
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  //borderRadius: BorderRadius.circular(15),
                  //Colors.blueAccent,
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                tabs: <Widget>[
                  Tab(
                    text: "All Forms",
                  ),
                  Tab(
                    text: "My Form",
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: formItems
                          .map(
                            (e) => FlatButton(
                              color: Colors.blueGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  e['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                NavigatorHelper.push(context, DynamicWidget(formId: e['id'], formName: e['name']));
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Center(
                    child: RaisedButton(
                      onPressed: _sendTelegramAlert,
                      child: Text(
                        "Notify Telegram",
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendTelegramAlert() async {
    var token = '1399310280:AAEKhHWGPpvzniF0OtkXLrKRIuW-vWyIUWY';
    var chatId = '266131718';
    var message = 'Hell flutter ' + DateTime.now().toString();
    var url = 'https://api.telegram.org/bot$token/sendMessage?chat_id=$chatId&text=$message';
    var response = await http.get(url);
    print(response.body);
  }
}

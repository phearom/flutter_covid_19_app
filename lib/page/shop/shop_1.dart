import 'package:covid_19_app/navigator/navigator_helper.dart';
import 'package:covid_19_app/page/shop/shop_detail.dart';
import 'package:covid_19_app/style/style.dart';
import 'package:covid_19_app/widget/drawer_menu.dart';
import 'package:flutter/material.dart';

class Shop1 extends StatefulWidget {
  @override
  _Shop1State createState() => _Shop1State();
}

class _Shop1State extends State<Shop1> {
  var categories = {"0": "All", "10": "Man", "20": "Women", "30": "Boy", "40": "Girl", "5": "Jewelry", "6": "Shoes", "7": "Clothes"};
  var productLists = [1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15, 20, 21, 22, 23, 24, 25, 30, 31, 32, 33, 34, 35, 40, 41, 42, 43, 44, 45];
  var selected = 0;

  void _getProducts() {
    if (selected == 0) {
      productSelected = productLists;
    } else {
      productSelected = productLists.where((item) => item > selected).toList();
    }
    print(productSelected);
  }

  var productSelected = new List<int>();

  @override
  void initState() {
    super.initState();
    this._getProducts();
  }

  @override
  Widget build(BuildContext context) {
    print('h');
    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      drawer: DrawerMenu(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Category",
              style: StyleHelper.homeTitle,
            ),
          ),
          Container(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.keys
                  .map(
                    (e) => InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          selected = int.parse(e);
                        });
                        this._getProducts();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              categories[e].toString(),
                              style: TextStyle(
                                color: selected.toString() == e ? Colors.blue : Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "____",
                              style: TextStyle(
                                color: selected.toString() == e ? Colors.blue : Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 0.80,
              children: productSelected
                  .map(
                    (e) => InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        NavigatorHelper.push(context, ShopDetail(tagId: e));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(000333), //Colors.green[400],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)
                                  ),
                                ),
                                child: Hero(
                                  tag: e,
                                  child: Image.asset('assets/image/bag_1.png'),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Item $e",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5)
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

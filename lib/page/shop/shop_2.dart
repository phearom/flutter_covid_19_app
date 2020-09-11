import 'package:covid_19_app/navigator/navigator_helper.dart';
import 'package:covid_19_app/page/shop/product_model.dart';
import 'package:covid_19_app/page/shop/shop_detail.dart';
import 'package:covid_19_app/widget/drawer_menu.dart';
import 'package:flutter/material.dart';

class Shop2 extends StatefulWidget {
  @override
  _Shop2State createState() => _Shop2State();
}

class _Shop2State extends State<Shop2> with SingleTickerProviderStateMixin {
  var categories = {"0": "All", "10": "Man", "20": "Women", "30": "Boy", "40": "Girl", "5": "Jewelry", "6": "Shoes", "7": "Clothes"};
  var productLists = [1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15, 20, 21, 22, 23, 24, 25, 30, 31, 32, 33, 34, 35, 40, 41, 42, 43, 44, 45];
  int itemSelected = 0;
  int itemIndex = 0;
  var productSelected = new List<ProductModel>();
  void _getProducts() {
    if (itemSelected == 0) {
      //productSelected = productLists;
      productSelected = products;
    } else {
      //productSelected = productLists.where((item) => item > itemSelected).toList();
      productSelected = products.where((p) => int.parse(p.id) > itemIndex + 2).toList();
    }
    //print(productSelected);
    print("Click $itemSelected");

    var p = new ProductModel();
    p.id = "003";
    print(p.id);
  }

  TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: categories.length, vsync: this);
    _controller.addListener(() {
      var keys = categories.keys.toList();
      setState(() {
        //selected = _controller.index;
        itemSelected = int.parse(keys[_controller.index]);
        itemIndex = _controller.index;
      });
      print("Swipe $itemSelected");
      _getProducts();
    });

    ///productSelected = productLists;
    productSelected = products;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('hello');
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _controller,
            isScrollable: true,
            onTap: (index) {
              var keys = categories.keys.toList();
              setState(() {
                itemSelected = int.parse(keys[index]);
                itemIndex = index;
              });
              //print(selected);
              _getProducts();
            },
            tabs: categories.keys
                .map((e) => Tab(
                      text: categories[e],
                    ))
                .toList(),
          ),
          title: Text('Shop 2'),
        ),
        drawer: DrawerMenu(),
        body: TabBarView(
          controller: _controller,
          children: categories.keys
              .map((e) => Container(
                    padding: EdgeInsets.all(10),
                    child: productSelected.length == 0
                        ? Center(child: Text("No data found."))
                        : GridView.count(
                            physics: BouncingScrollPhysics(),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 3,
                            childAspectRatio: 0.80,
                            children: productSelected
                                .map(
                                  (e) => InkWell(
                                    onTap: () {
                                      NavigatorHelper.push(
                                        context,
                                        ShopDetail(
                                          title: e.name,
                                          tagId: int.parse(e.id),
                                          color: e.color,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: e.color,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: Hero(
                                              tag: int.parse(e.id),
                                              child: Image.asset(
                                                'assets/image/bag_1.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            e.name,
                                            style: TextStyle(color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('20', style: TextStyle(color: Colors.white))
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

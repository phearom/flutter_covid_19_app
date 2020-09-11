import 'dart:math';

import 'package:flutter/material.dart';

class ShopDetail extends StatefulWidget {
  final String title;
  final int tagId;
  final Color color;

  const ShopDetail({Key key, this.title, this.tagId, this.color}) : super(key: key);
  @override
  _ShopDetailState createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title??"Item ${widget.tagId}"),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 160),
              decoration: BoxDecoration(color: widget.color ?? Colors.blueAccent),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: widget.tagId,
                    child: Image.asset(
                      'assets/image/bag_1.png',
                      width: 200,
                    ),
                  ),
                  //Text("Item " + widget.tagId.toString()),
                  Text(widget.title ?? "Item ${widget.tagId}"),
                  Container(
                    decoration: BoxDecoration(
                        //border: Border(bottom: BorderSide(color: Colors.white,width: 2))
                        ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      tabs: <Widget>[
                        Tab(text: "Spec"),
                        Tab(text: "Detail"),
                        Tab(text: "Image"),
                      ],
                    ),
                  ),
                  Expanded(
                    //height: 100,
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        Text("---spec---"),
                        Text("---detail---"),
                        Text("---image---"),
                      ],
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
}

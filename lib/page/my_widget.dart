import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyWidgetState();
  }
}

class _MyWidgetState extends State<MyWidget> {
  bool loading = true;
  // Desired duration for the animation
  Duration _animationDuration = Duration(milliseconds: 1000);

// Change these properties to trigger the animation. You are not limited to these properties, feel free to explore!
  Color _backgroundColor = Colors.blueGrey;
  double _height = 100;
  double _width = 300;
  double _borderRadius = 10;
  double _padding = 50;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          AnimatedContainer(
            duration: _animationDuration,
            height: _height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(_padding),
            decoration: BoxDecoration(
              color: _backgroundColor,
            ),
            child: Container(
              color: Colors.red,
            )
          ),
          IconButton(
            icon: Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _height = 0;
                _width = 0;
                _borderRadius = 30;
                _backgroundColor = Colors.red;
                _padding = 10;
              });
            },
          ),IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _height = 100;
                _width = 330;
                _borderRadius = 30;
                _backgroundColor = Colors.red;
                _padding = 10;
              });
            },
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String loadingText;

  const LoadingWidget({Key key, this.loadingText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          backgroundColor: Colors.blue,
        ),
        SizedBox(height: 20),
        Text(
          loadingText ?? "Loading...",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

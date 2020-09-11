import 'package:flutter/material.dart';

class NoNetworkConnection extends StatelessWidget {
  final bool visible;
  final String message;
  final VoidCallback onRefreshed;

  const NoNetworkConnection({Key key, @required this.visible, this.message, this.onRefreshed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var _defaultMessage = "No network connection!";
    return AnimatedContainer(
      duration: Duration(milliseconds: 1000),
      height: visible ? 45 : 0,
      width: MediaQuery.of(context).size.width, // - 10,
      decoration: BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: Text(
          message ?? _defaultMessage,
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Visibility(
      child: Container(
        width: MediaQuery.of(context).size.width, // - 10,
        height: 45,
        decoration: BoxDecoration(
          //borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: FlatButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: onRefreshed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (onRefreshed != null) ...[
                Icon(Icons.refresh, color: Colors.red),
              ],
              VerticalDivider(width: 10),
              Text(
                message ?? _defaultMessage,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      maintainAnimation: true,
      maintainState: true,
      visible: visible,
    );
  }
}

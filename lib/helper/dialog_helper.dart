import 'package:flutter/material.dart';

class DialogHelper {
  static void showAlert(BuildContext context, {String title, String body}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title ?? "Title"),
          content: Text(body ?? "Body"),
          actions: <Widget>[
            FlatButton(
              child: Text("Close",style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}

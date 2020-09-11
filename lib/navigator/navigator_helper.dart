import 'package:flutter/material.dart';

import 'fade_route.dart';

class NavigatorHelper {
  static void push(BuildContext context, Widget page) {
    Navigator.push(context, FadeRoute(page: page));
  }

  static void push2(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

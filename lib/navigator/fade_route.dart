import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          //transitionDuration: Duration(milliseconds: 1000),
          transitionsBuilder: (ontext, animation, secondaryAnimation, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

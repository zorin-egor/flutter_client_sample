import 'package:flutter/material.dart';


Route animateRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        child: child,
        position: animation.drive(
            Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.fastOutSlowIn))
        )
      );
    },
  );
}
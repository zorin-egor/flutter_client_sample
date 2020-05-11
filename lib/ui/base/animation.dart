import 'package:flutter/material.dart';


Route animateRoute({
  @required Widget widget,
  opaque = true,
  barrierDismissible = false
}) {
  return PageRouteBuilder(
    opaque: opaque,
    barrierDismissible: barrierDismissible,
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
import 'package:flutter/widgets.dart';

class MainAnimation {
  final AnimationController animationController;
  final Animation<double> listViewAnimation;

  MainAnimation(this.animationController)
      :
        // ignore: prefer_int_literals
        listViewAnimation = Tween(begin: 0.0, end: 0.5).animate(
            CurvedAnimation(parent: animationController, curve: Curves.easeIn));
}

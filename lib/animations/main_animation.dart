import 'package:flutter/widgets.dart';
import '../utils/app_color_palette.dart';

class MainAnimation {
  final AnimationController animationController;
  final Animation<double> listViewAnimation;
  final Animation<Color> floatingActionButtonAnimation;
  final Animation<double> animateFloatingActionButtonIcon;

  MainAnimation(this.animationController)
      :
        // ignore: prefer_int_literals
        listViewAnimation = Tween(begin: 0.0, end: 0.5).animate(
            CurvedAnimation(parent: animationController, curve: Curves.easeIn)),
        floatingActionButtonAnimation = ColorTween(
                begin: AppColorPalette().primaryColorLight,
                end: AppColorPalette().primaryColorDark)
            .animate(CurvedAnimation(
                parent: animationController, curve: const Interval(0, 1))), 
                // ignore: prefer_int_literals
                animateFloatingActionButtonIcon = Tween(begin: 0.0, end: 0.5).
                animate(animationController);
}

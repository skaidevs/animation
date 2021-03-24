import 'dart:math';

import 'package:animation/src/widgets/cat.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late Animation<double> catAnimation;
  late AnimationController catController;
  late Animation<double> boxFlapAnimation;
  late AnimationController boxFlapController;

  initState() {
    super.initState();

    boxFlapController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );

    boxFlapAnimation = Tween(
      begin: pi * 0.6,
      end: pi * 0.65,
    ).animate(
      CurvedAnimation(
        parent: boxFlapController,
        curve: Curves.linear,
      ),
    );

    boxFlapAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxFlapController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxFlapController.forward();
      }
    });

    boxFlapController.forward();

    catController = new AnimationController(
      duration: Duration(
        milliseconds: 400,
      ),
      vsync: this,
    );
    catAnimation = Tween(begin: -35.0, end: -80.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation'),
      ),
      body: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
      ),
    );
  }

  void onTap() {
    if (catController.status == AnimationStatus.completed) {
      boxFlapController.forward();
      catController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      boxFlapController.stop();
      catController.forward();
    }
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
        animation: boxFlapAnimation,
        child: Container(
          height: 10,
          width: 125,
          color: Colors.brown,
        ),
        builder: (context, child) {
          return Transform.rotate(
            alignment: Alignment.topLeft,
            angle: boxFlapAnimation.value,
            child: child,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
        animation: boxFlapAnimation,
        child: Container(
          height: 10,
          width: 125,
          color: Colors.brown,
        ),
        builder: (context, child) {
          return Transform.rotate(
            alignment: Alignment.topRight,
            angle: -boxFlapAnimation.value + 0.2,
            child: child,
          );
        },
      ),
    );
  }

  Widget buildBoxTag() {
    return Transform.rotate(
      angle: pi / 12.0,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: const Color(0xFFE8581C),
        child: const Text('Apartment for rent!'),
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: Container(child: child),
          top: catAnimation.value,
          left: 0.0,
          right: 0.0,
        );
      },
      child: Cat(),
    );
  }
}

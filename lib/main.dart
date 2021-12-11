import 'package:flutter/material.dart';
import 'package:game/flappyBird/homepage.dart';
import 'package:game/flappyBird/splashScreen.dart';
import 'package:game/hungrySnake/game.dart';
import 'package:game/mainPage.dart';
import 'package:game/tetris/gamePage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Practice',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game/flappyBird/homepage.dart';
import 'package:game/hungrySnake/game.dart';
import 'package:game/tetris/gamePage.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        height: queryData.size.height,
        width: queryData.size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Let's Play",
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (context) => HomePage()));
              },
              child: Container(
                child: Text(
                  'Flappy Bird',
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (context) => GamePage()));
              },
              child: Container(
                child: Text(
                  'Tetris',
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (context) => HungrySnake()));
              },
              child: Container(
                child: Text(
                  'Snake',
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

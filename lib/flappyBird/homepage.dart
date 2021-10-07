import 'dart:async';
import 'package:flutter/material.dart';
import 'package:game/flappyBird/barriers.dart';
import 'package:game/flappyBird/bird.dart';
import 'package:game/flappyBird/store.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double time = 0;
  double height = 0;
  double initialHeight = 0;
  bool gameStarted = false;
  static double barrierX_1 = 0;
  double barrierX_2 = barrierX_1 + 1.5;
  int score = 0;
  int best = 0;
  int money = 0;
  String birdImage = "assets/images/peace.png";

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdY;
    });
  }

  void startGame() {
    gameStarted = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdY = initialHeight - height;
        barrierX_1 -= 0.05;
        barrierX_2 -= 0.05;
      });
      setState(() {
        if (barrierX_1 < -2) {
          barrierX_1 += 3.5;
        } else {
          barrierX_1 -= 0.05;
        }
      });
      setState(() {
        if (barrierX_2 < -2) {
          barrierX_2 += 3.5;
        } else {
          barrierX_2 -= 0.05;
        }
      });
      setState(() {
        if (barrierX_1 < -0.2 && barrierX_1 > -0.3) {
          score += 1;
          print("get score");
        } else {
          score = score;
        }
      });
      setState(() {
        if (barrierX_2 < -0.2 && barrierX_2 > -0.3) {
          score += 1;
          print("get score");
        } else {
          score = score;
        }
      });
      if (birdY > 1) {
        timer.cancel();
        gameOver();
      }
      if (barrierX_1 < 0.127 && barrierX_1 > -0.127) {
        if (birdY < -0.284 || birdY > 0.284) {
          timer.cancel();
          gameOver();
        }
      }
      if (barrierX_2 < 0.127 && barrierX_2 > -0.127) {
        if (birdY < -0.188 || birdY > 0.5) {
          timer.cancel();
          gameOver();
        }
      }
    });
  }

  void gameOver() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          titleTextStyle: TextStyle(
              color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 24),
          content: Text("You earn ${score} coin!"),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.brown[200]),
              ),
              onPressed: resetGame,
              child: Text("New game"),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    Navigator.pop(context);
    money += score;
    setState(() {
      if (score > best) {
        best = score;
      }
      birdY = 0;
      barrierX_1 = 0;
      barrierX_2 = 1.5;
      time = 0;
      height = 0;
      initialHeight = 0;
      score = 0;
    });
    gameStarted = false;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      floatingActionButton: IconButton(
        color: Colors.brown[100],
        icon: Icon(Icons.store),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => StorePage(
              callback: (value) {
                setState(() {
                  birdImage = value;
                });
                return '';
              },
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (gameStarted) {
            jump();
          } else {
            startGame();
          }
        },
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdY),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: MyBird(
                      birdImage: birdImage,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierX_1, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(size: queryData.size.height * 0.256),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierX_1, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(size: queryData.size.height * 0.256),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierX_2, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(size: queryData.size.height * 0.192),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierX_2, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(size: queryData.size.height * 0.32),
                  ),
                  Container(
                    alignment: Alignment(0, -0.3),
                    child: gameStarted
                        ? Text("")
                        : Text(
                            "T A P  T O  P L A Y",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Score",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          score.toString(),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Best",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          best.toString(),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class HungrySnake extends StatefulWidget {
  const HungrySnake({Key? key}) : super(key: key);

  @override
  _HungrySnakeState createState() => _HungrySnakeState();
}

class _HungrySnakeState extends State<HungrySnake> {
  bool isStart = false;
  Random random = Random();
  List<int> snakeBody = [];
  int snakeDirection = 0;
  int apple = -1;
  List<int> obstacle = [];
  int score = 0;
  int speedControl = 5;
  int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void startGame() {
    isStart = true;
    snakeBody.add(random.nextInt(149));
    snakeDirection = random.nextInt(3);
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (counter % speedControl == 0) {
        if (snakeBody.length > 1) {
          if (snakeBody[snakeBody.length - 1] ==
              snakeBody[snakeBody.length - 2]) {
            for (int i = snakeBody.length - 2; i >= 1; i--) {
              snakeBody[i] = snakeBody[i - 1];
            }
          }
          for (int i = snakeBody.length - 1; i >= 1; i--) {
            snakeBody[i] = snakeBody[i - 1];
          }
        }
        if (snakeDirection == 0) {
          if (snakeBody[0] ~/ 10 == 0) {
            timer.cancel();
            gameover();
          }
          snakeBody[0] -= 10;
        } else if (snakeDirection == 1) {
          if (snakeBody[0] % 10 == 9) {
            timer.cancel();
            gameover();
          }
          snakeBody[0] += 1;
        } else if (snakeDirection == 2) {
          if (snakeBody[0] ~/ 10 == 14) {
            timer.cancel();
            gameover();
          }
          snakeBody[0] += 10;
        } else if (snakeDirection == 3) {
          if (snakeBody[0] % 10 == 0) {
            timer.cancel();
            gameover();
          }
          snakeBody[0] -= 1;
        }
        if (snakeBody.length > 1) {
          for (int i = 1; i < snakeBody.length - 1; i++) {
            if (snakeBody[i] == snakeBody[0]) {
              timer.cancel();
              gameover();
            }
          }
        }
        if (apple == -1) {
          apple = random.nextInt(149);
        } else {
          if (snakeBody[0] == apple) {
            eat();
          }
        }
        setState(() {});
      }
      counter += 1;
    });
  }

  void rotateLeft() {
    if (snakeDirection == 0) {
      snakeDirection = 3;
    } else {
      snakeDirection -= 1;
    }
  }

  void rotateRight() {
    if (snakeDirection == 3) {
      snakeDirection = 0;
    } else {
      snakeDirection += 1;
    }
  }

  void eat() {
    snakeBody.add(snakeBody[snakeBody.length - 1]);
    apple = -1;
    score += 20;
  } // When the snake eat an apple

  void gameover() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'GAME OVER',
            style: TextStyle(
              color: Colors.deepPurple[300],
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              apple = -1;
              score = 0;
              snakeBody = [];
              startGame();
            },
            child: Card(
              color: Colors.deepPurple[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Press to restart'),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10),
                  itemCount: 150,
                  itemBuilder: (context, index) {
                    if (snakeBody.contains(index)) {
                      if (snakeBody[0] == index) {
                        return Card(
                          color: Colors.deepPurple[300],
                        );
                      } else {
                        return Card(
                          color: Colors.white,
                        );
                      }
                    } else if (apple == index) {
                      return Card(
                        color: Colors.green,
                      );
                    } else {
                      return Card(color: Colors.grey[800]);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      color: Colors.grey[800],
                      alignment: Alignment.center,
                      height: 80,
                      width: 80,
                      child: Text(
                        'Score: ${score}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[300],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: rotateLeft,
                      child: Container(
                        color: Colors.grey[800],
                        height: 80,
                        width: 80,
                        child: Icon(
                          Icons.rotate_left,
                          size: 50,
                          color: Colors.deepPurple[300],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: rotateRight,
                      child: Container(
                        color: Colors.grey[800],
                        height: 80,
                        width: 80,
                        child: Icon(
                          Icons.rotate_right,
                          size: 50,
                          color: Colors.deepPurple[300],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (TapDownDetails tapDownDetails) {
                        speedControl = 1;
                      },
                      onTapUp: (TapUpDetails tapUpDetails) {
                        speedControl = 5;
                      },
                      child: Container(
                        color: Colors.grey[800],
                        height: 80,
                        width: 80,
                        child: Icon(
                          Icons.speed,
                          size: 50,
                          color: Colors.deepPurple[300],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          if (!isStart)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Snake',
                    style: TextStyle(
                      color: Colors.deepPurple[300],
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: startGame,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          'New Game',
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

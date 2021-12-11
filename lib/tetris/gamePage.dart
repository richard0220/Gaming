import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int point = 0;
  int checkBlockCounter = 0;
  Random random = Random();
  int index = 0;
  Color colorPaint = Colors.white;
  bool rightMax = false;
  bool leftMax = false;
  int rotateCount = 0;
  int axis = 0;
  List<List<int>> blocks = [
    [4, 5, 14, 15],
    [4, 14, 15, 25],
    [5, 14, 15, 24],
    [4, 14, 15, 24],
    [5, 14, 15, 25],
    [3, 4, 5, 6],
    [4, 14, 24, 34],
    [4, 14, 24, 25],
    [5, 15, 24, 25],
  ];

  List<Color> colors = [
    Colors.blue[100]!,
    Colors.pink[200]!,
    Colors.teal[200]!,
    Colors.amber[100]!,
    Colors.blueGrey,
    Colors.deepPurple[200]!,
    Colors.indigo,
    Colors.lightBlue,
    Colors.red
  ];

  List<int> movingBlock = [];
  List<int> existBlock = [];
  List<Color> existColor = List.generate(150, (index) {
    return Colors.grey[800]!;
  });

  void startGame() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (movingBlock.isEmpty) {
        index = random.nextInt(8);
        setState(() {
          for (int i = 0; i < 4; i++) {
            movingBlock.add(blocks[index][i]);
            existColor[blocks[index][i]] = colors[index];
          }
        });
      } else {
        checkBlockCounter = 0;
        for (int i = 0; i < movingBlock.length; i++) {
          // Check if the next line is empty
          if (movingBlock[i] + 10 >= 150) {
            checkBlockCounter += 1;
            break;
          }
          if (existBlock.contains(movingBlock[i] + 10)) {
            checkBlockCounter += 1;
            break;
          }
        }
        if (checkBlockCounter == 0) {
          for (int i = 3; i >= 0; i--) {
            existColor[movingBlock[i] + 10] = existColor[movingBlock[i]];
            existColor[movingBlock[i]] = Colors.grey[800]!;
            movingBlock[i] += 10;
          }
        } else {
          for (int i = 0; i < 4; i++) {
            existBlock.add(movingBlock[i]);
          }
          existBlock.sort();
          print(existBlock);
          movingBlock = [];
          rotateCount = 0;
          if (existBlock[0] ~/ 10 == 0) {
            timer.cancel();
            gameover();
          }
        }
        // check
        if (existBlock.length > 9) {
          for (int i = 0; i < existBlock.length - 9; i++) {
            if (existBlock[i] % 10 == 0) {
              if ((existBlock[i + 9] / 10).floor() == existBlock[i] / 10) {
                print('clear');
                clearLine(existBlock[i] ~/ 10);
              }
            }
          }
        }
      }
      setState(() {});
    });
  }

  void gameover() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Game Over',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text('Score: ${point}'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.pop(context);
              resetGame;
            },
          ),
        ],
      ),
    );
  }

  void resetGame() {
    for (int i = 0; i < existColor.length; i++) {
      existColor[i] = Colors.grey[800]!;
    }
    existBlock = [];
    movingBlock = [];
    point = 0;
    startGame();
  }

  void clearLine(int lineIndex) {
    // clear the line
    for (int i = 0; i < 10; i++) {
      existBlock.remove(lineIndex * 10 + i);
      existColor[lineIndex * 10 + i] = Colors.grey[800]!;
    }
    // set down the blocks
    int blockAbove = 0;
    for (int i = 0; i < existBlock.length; i++) {
      if (existBlock[i] < lineIndex * 10) {
        blockAbove += 1;
      }
    }
    for (int i = blockAbove - 1; i >= 0; i--) {
      print('${existBlock[i]}');
      existColor[existBlock[i] + 10] = existColor[existBlock[i]];
      existColor[existBlock[i]] = Colors.grey[800]!;
      existBlock[i] += 10;
    }
    point += 30;
  }

  void rightShift() {
    rightMax = false;
    for (int i = 0; i < 4; i++) {
      if (movingBlock[i] % 10 == 9) {
        rightMax = true;
        break;
      }
      if (existBlock.contains(movingBlock[i] + 1)) {
        rightMax = true;
        break;
      }
    }
    if (!rightMax) {
      for (int i = 3; i >= 0; i--) {
        existColor[movingBlock[i] + 1] = existColor[movingBlock[i]];
        existColor[movingBlock[i]] = Colors.grey[800]!;
        movingBlock[i] += 1;
        setState(() {});
      }
    }
  }

  void leftShift() {
    leftMax = false;
    for (int i = 0; i < 4; i++) {
      if (movingBlock[i] % 10 == 0) {
        leftMax = true;
        break;
      }
      if (existBlock.contains(movingBlock[i] - 1)) {
        leftMax = true;
        break;
      }
    }
    if (!leftMax) {
      for (int i = 0; i < 4; i++) {
        existColor[movingBlock[i] - 1] = existColor[movingBlock[i]];
        existColor[movingBlock[i]] = Colors.grey[800]!;
        movingBlock[i] -= 1;
        setState(() {});
      }
    }
  }

  void rotate() {
    Color temp = existColor[movingBlock[0]];
    axis = movingBlock[0];
    for (int i = 0; i < 4; i++) {
      existColor[movingBlock[i]] = Colors.grey[800]!;
    }
    if (rotateCount == 0) {
      if (temp == Colors.pink[200]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis + 11, axis + 12, axis + 20, axis + 21]);
      } else if (temp == Colors.teal[200]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis + 9, axis + 10, axis + 20, axis + 21]);
      } else if (temp == Colors.amber[100]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis + 9, axis + 10, axis + 11, axis + 20]);
      } else if (temp == Colors.blueGrey) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis, axis + 9, axis + 10, axis + 11]);
      } else if (temp == Colors.deepPurple[200]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis - 9, axis + 1, axis + 11, axis + 21]);
      } else if (temp == Colors.indigo) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis + 9, axis + 10, axis + 11, axis + 12]);
      } else if (temp == Colors.lightBlue) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis + 9, axis + 10, axis + 11, axis + 19]);
      } else if (temp == Colors.red) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis - 1, axis + 9, axis + 10, axis + 11]);
      }
    } else if (rotateCount == 1) {
      if (temp == Colors.pink[200]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis - 10, axis, axis + 1, axis + 11]);
      } else if (temp == Colors.teal[200]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis - 9, axis, axis + 1, axis + 10]);
      } else if (temp == Colors.amber[100]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis - 9, axis, axis + 1, axis + 11]);
      } else if (temp == Colors.blueGrey) {
        movingBlock.removeRange(0, 4);
        movingBlock
            .addAll([axis, axis + 10, axis + 11, axis + 20]); // stop here
      } else if (temp == Colors.deepPurple[200]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis + 9, axis + 10, axis + 11, axis + 12]);
      } else if (temp == Colors.indigo) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis - 9, axis + 1, axis + 11, axis + 21]);
      } else if (temp == Colors.lightBlue) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis - 10, axis - 9, axis + 1, axis + 11]);
      } else if (temp == Colors.red) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis + 1, axis + 2, axis + 11, axis + 21]);
      }
    } else if (rotateCount == 2) {
      if (temp == Colors.pink[200]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis + 11, axis + 12, axis + 20, axis + 21]);
      } else if (temp == Colors.teal[200]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis + 9, axis + 10, axis + 20, axis + 21]);
      } else if (temp == Colors.amber[100]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis, axis + 9, axis + 10, axis + 11]);
      } else if (temp == Colors.blueGrey) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis + 9, axis + 10, axis + 11, axis + 20]);
      } else if (temp == Colors.deepPurple[200]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis - 9, axis + 1, axis + 11, axis + 21]);
      } else if (temp == Colors.indigo) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis + 9, axis + 10, axis + 11, axis + 12]);
      } else if (temp == Colors.lightBlue) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis + 2, axis + 10, axis + 11, axis + 12]);
      } else if (temp == Colors.red) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis + 9, axis + 10, axis + 11, axis + 21]);
      }
    } else if (rotateCount == 3) {
      if (temp == Colors.pink[200]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis - 10, axis, axis + 1, axis + 11]);
      } else if (temp == Colors.teal[200]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis - 9, axis, axis + 1, axis + 10]);
      } else if (temp == Colors.amber[100]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis, axis + 10, axis + 11, axis + 20]);
      } else if (temp == Colors.blueGrey) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis - 9, axis, axis + 1, axis + 11]); // stop here
      } else if (temp == Colors.deepPurple[200]) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis + 9, axis + 10, axis + 11, axis + 12]);
      } else if (temp == Colors.indigo) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis - 9, axis + 1, axis + 11, axis + 21]);
      } else if (temp == Colors.lightBlue) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis - 1, axis + 9, axis + 19, axis + 20]);
      } else if (temp == Colors.red) {
        movingBlock.removeRange(0, 4);
        movingBlock.addAll([axis - 9, axis + 1, axis + 10, axis + 11]);
      }
    }
    if (rotateCount == 3) {
      rotateCount = 0;
    } else {
      rotateCount += 1;
    }
    for (int i = 0; i < 4; i++) {
      existColor[movingBlock[i]] = temp;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
              itemCount: 150,
              itemBuilder: (context, index) {
                return Card(
                  color: existColor[index],
                );
              },
            ),
          ),
          Text(
            "Point: ${point}",
            style: TextStyle(color: Colors.white),
          ),
          Container(
            padding: EdgeInsets.all(5),
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: startGame,
                  child: Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey[800],
                    alignment: Alignment.center,
                    child: Text(
                      'PLAY',
                      style: TextStyle(color: Colors.grey, fontSize: 28),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: leftShift,
                  child: Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey[800],
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_left,
                      size: 70,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: rightShift,
                  child: Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey[800],
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_right,
                      size: 70,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: rotate,
                  child: Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey[800],
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.rotate_right,
                      size: 50,
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

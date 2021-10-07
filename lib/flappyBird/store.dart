import 'package:flutter/material.dart';
import 'package:game/flappyBird/commodity.dart';
import 'package:hive_flutter/hive_flutter.dart';

typedef StringValue = String Function(String);

class StorePage extends StatefulWidget {
  final StringValue callback;
  const StorePage({Key? key, required this.callback}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<bool> itemState = [true, false, false, false, false];
  int currentBird = 0;
  int money = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.indigo[800],
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(
              Icons.money_rounded,
              color: Colors.indigo[800],
            ),
            Text(
              ": ${money} ",
              style: TextStyle(color: Colors.indigo[800]),
            ),
          ],
        ),
      ),
      body: Container(
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          children: [
            Commodities(
              image: "assets/images/peace.png",
              name: "Richard",
              cost: 0,
              index: 0,
              state: itemState[0],
              callback: (value) {
                setState(() {
                  itemState[currentBird] = false;
                  itemState[0] = value;
                  currentBird = 0;
                });
                return true;
              },
              callbackUrl: (value) {
                return widget.callback(value);
              },
            ),
            Commodities(
              image: "assets/images/bird.png",
              name: "Isabel",
              cost: 500,
              index: 1,
              state: itemState[1],
              callback: (value) {
                setState(() {
                  itemState[currentBird] = false;
                  itemState[1] = value;
                  currentBird = 1;
                });
                return true;
              },
              callbackUrl: (value) {
                return widget.callback(value);
              },
            ),
            Commodities(
              image: "assets/images/rooster.png",
              name: "Nemo",
              cost: 350,
              index: 2,
              state: itemState[2],
              callback: (value) {
                setState(() {
                  itemState[currentBird] = false;
                  itemState[2] = value;
                  currentBird = 2;
                });
                return true;
              },
              callbackUrl: (value) {
                return widget.callback(value);
              },
            ),
            Commodities(
              image: "assets/images/hummingbird.png",
              name: "Jason",
              cost: 100,
              index: 3,
              state: itemState[3],
              callback: (value) {
                setState(() {
                  itemState[currentBird] = false;
                  itemState[3] = value;
                  currentBird = 3;
                });
                return true;
              },
              callbackUrl: (value) {
                return widget.callback(value);
              },
            ),
            Commodities(
              image: "assets/images/origami.png",
              name: "Ryder",
              cost: 1000,
              index: 4,
              state: itemState[4],
              callback: (value) {
                setState(() {
                  itemState[currentBird] = false;
                  itemState[4] = value;
                  currentBird = 4;
                });
                return true;
              },
              callbackUrl: (value) {
                return widget.callback(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

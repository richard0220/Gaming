import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:game/flappyBird/bird.dart';
import 'package:game/flappyBird/homepage.dart';
import 'package:game/flappyBird/store.dart';
import 'package:hive_flutter/hive_flutter.dart';

typedef StateValue = bool Function(bool);
typedef StringValue = String Function(String);

class Commodities extends StatefulWidget {
  final String image;
  final String name;
  final int cost;
  final int index;
  final bool state;
  final StateValue callback;
  final StringValue callbackUrl;

  const Commodities({
    Key? key,
    required this.image,
    required this.name,
    required this.cost,
    required this.index,
    required this.state,
    required this.callback,
    required this.callbackUrl,
  }) : super(key: key);

  @override
  _CommoditiesState createState() => _CommoditiesState();
}

class _CommoditiesState extends State<Commodities> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.brown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            widget.image,
            scale: 0.5,
          ),
          Text(
            widget.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.brown[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "\$${widget.cost}",
                    style: TextStyle(color: Colors.brown[800]),
                  ),
                  TextButton(
                    onPressed: () {
                      if (widget.state) {
                      } else {
                        setState(() {
                          widget.callback(true);
                          widget.callbackUrl(widget.image);
                        });
                      }
                    },
                    child: Text(
                      widget.state ? "Select" : "BUY",
                      style: TextStyle(color: Colors.brown[800]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

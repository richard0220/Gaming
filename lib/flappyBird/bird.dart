import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  String birdImage;
  MyBird({required this.birdImage});

  @override
  Widget build(BuildContext context) {
    return Image.asset(birdImage);
  }
}

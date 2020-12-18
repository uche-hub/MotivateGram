import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("Home Page", style: TextStyle(
          fontFamily: 'Langar',
          fontWeight: FontWeight.w900,
          fontSize: 28
        ),),
      ),
    );
  }
}
